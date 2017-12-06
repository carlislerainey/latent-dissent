
# From Murdie and and Bhasin (2010): 
#
#    To create the new measures, we relied on the IDEA framework (Bond et al. 
#    2003). IDEA is a data set of all daily events in Reuters Global News 
#    Service. These data were organized in a "who" did "what" to "whom" manner
#    for each particular event, over 10 million events in the complete data set
#    (King and Lowe 2003).
#    
#    For our variables, we isolated events where... 
#    - a domestic group or individual is the "who," 
#    - the "what" is either violent or nonviolent protest, and 
#    - the "whom" is either a state agent or a state physical office. 
#    As mentioned earlier, violent protests are protests with the threat or use
#    of force. Attacking a government official or office, destroying government 
#    property, or a bombing of a government official's home are all examples of 
#    violent protest. Conversely, protest marches, demonstrations, boycotts, and
#    sit-ins are some of the many examples of nonviolent protest.[6] Our 
#    procedure identified over 50,000 violent and 20,000 nonviolent protest 
#    events from 1991 to 2004.
#    
#    [6] Tables of all the types of events included as protest and summary 
#    statistics are provided in the online replication materials.
#
# Their online replication materials (SI) are available in `data/raw/Murdie 
# Bhasin JCR Online Replication Materials 05.13.10.doc` and from 
# http://journals.sagepub.com/doi/suppl/10.1177/0022002710374715. The script 
# `R/01-create-murdie-bhasin-events.R` creates a the file 
# `data/murdie-bhasin-events.csv` that contains these events.

# load events that murdie and bhasin classify as protest events
mb_events_df <- read_csv("data/murdie-bhasin-events.csv")

# load data set with description of sectors
## from http://hdl.handle.net/1902.1/FYXLAWZRIA (King and Lowe 2003)
sector_codes_df <- read_csv("data/raw/Sectors of Source _ Target.txt", 
                            col_names = c("TGTSECTO", "target_description"))

# load data set with description of levels
level_codes_df <- read_csv("data/raw/Levels of Source _ Target.txt", 
                           col_names = c("SRCLEVEL", 
                                         "source_description", 
                                         "source_detailed_description"))
# load data set with description of names
names_codes_df <- read_csv("data/raw/Names of Source _ Target.txt", 
                           col_names = c("SRCNAME", 
                                         "name_description"))

# create vector of sectors for "a state agent or a state physical office."
## I had a hard time with the sectors, but I found this helpful on the Wayback machine.
## http://web.archive.org/web/20040822062637/http://vranet.com:80/idea/coderhelp/testcoderhelp.htm
## I captured the relevant webpages as pdfs in `data/raw/wayback-sector-hierarchy.pdf` and
## `data/raw/wayback-sector-descriptions.pdf`. I'm including sectors listed under
## "government agents," which *I hope* includes a "state physical office" (??). See the file 
## `data/raw/Sectors of Source _ Target.txt` (from King and Lowe's dataverse) for the 
## codes
state_agents <- c("<GAGE>",  # government agents
                  "<JUDI>",  # judiciary
                  "<DIPL>",  # diplomats
                  "<MILI>",  # military
                  "<NEXE>",  # national executive
                  "<NLEG>",  # legislators
                  "<OFFI>",  # officials
                  "<SNOF>",  # sub-national officials
                  "<PKOS>",  # peace-keeping forces
                  "<POLI>")  # police

# read raw data
## from http://hdl.handle.net/1902.1/FYXLAWZRIA (King and Lowe 2003)
idea90_raw_df <- read_tsv("data/raw/1990-1994 Data (N=2_679_938).tab")
idea95_raw_df <- read_tsv("data/raw/1995-1999 Data (N=4_108_102).tab")
idea00_raw_df <- read_tsv("data/raw/2000-2004 Data (N=3464898).tab") %>%
  setNames(toupper(names(.))) %>%
  rename(EVENTDAT = EVENTDATE,
         EVENTFOR = EVENTFORM,
         SRCSECTO = SRCSECTOR,
         TGTSECTO = TGTSECTOR)
idea_raw_df <- bind_rows(idea90_raw_df, idea95_raw_df) %>%
  bind_rows(idea00_raw_df) %>%
  mutate(SRCNAME = toupper(SRCNAME),
         TGTNAME = toupper(TGTNAME),
         PLACE = toupper(PLACE))
rm(idea90_raw_df, idea95_raw_df, idea00_raw_df)  # remove these large data frames

# write the merged idea data to file
write_csv(idea_raw_df, "data/idea-all-events.csv")

# create a vector of names to drop, see lines 178-195 of `data/raw/RepressDissentCoding.do`
names_to_drop <- c("UN", "_AFR", "_ARC","_ASA", "_CAM", "_EUR", "_NAM", "_SAM", 
                   "_WOR", 
                   # and I'm adding these on a hunch, notice when combining with cow codes
                   "_AF", "_AS", "_CA", "_EU", "_WO", "ARBL", 
                   "CAS", "CASA", "EEC", "EEU", "GAZ", "MES", "MEST", "NAT", 
                   "NATO", "OAS", "OIN", "OIND", "OPA", "OSCE", "SAS", "SASA",
                   "SCA", "SEAS", "SEE", "SEEU", "WAF", "WAFR", "WBK", "WSA")  
## filter events
idea_df <- idea_raw_df %>%
  filter(EVENTFOR %in% mb_events_df$IDEA.CODE) %>%  # what: violent or non-violent protests (murdie and bhasin appendix)
  filter(SRCLEVEL %in% c("<GROU>", "<INDI>")) %>%  # who: group or individual (murdie and bhasin text above)
  filter(SRCNAME == TGTNAME) %>%  # who: domestic (murdie and bhasin text above, see lines 36-37 of `data/raw/RepressDissentCoding.do`)
  filter(!(SRCNAME %in% names_to_drop)) %>%  # who: domestic (see lines 178-195 of `data/raw/RepressDissentCoding.do`)
  filter(!(TGTNAME %in% names_to_drop)) %>%  # who: domestic (see lines 178-195 of `data/raw/RepressDissentCoding.do`)
  filter(TGTSECTO %in% state_agents)  # whom: state agent

glimpse(idea_df)

dissent_df <- idea_df %>%
  left_join(sector_codes_df) %>%
  left_join(level_codes_df) %>%
  left_join(names_codes_df) %>%
  left_join(mb_events_df, by = c("EVENTFOR" = "IDEA.CODE")) %>%
  select(date = EVENTDAT,
         where = name_description,
         what = ACTIVITY, 
         who = source_description,
         whom = target_description,
         where_idea = SRCNAME,
         what_idea = EVENTFOR,
         who_idea = SRCLEVEL,
         whom_idea = TGTSECTO) %>%
  separate(date, c("date", "time"), sep = " ", fill = "right", remove = TRUE) %>%
  #separate(date, c("month", "day", "year"), remove = FALSE) %>%
  mutate(date = mdy(date))

glimpse(dissent_df)

# write data file
write_csv(dissent_df, "data/idea-dissent-events.csv")
