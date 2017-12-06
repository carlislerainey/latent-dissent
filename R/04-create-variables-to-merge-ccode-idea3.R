
# clear workspace
rm(list = ls())

# add cow codes
fixes_df <- read.csv("data/raw/where-idea-fixes.csv")

codes_df <- read_csv("data/idea-dissent-events.csv") %>%
  select(where, where_idea) %>%
  mutate(cown_by_cowc = countrycode(where_idea, 
                                    origin = "cowc", 
                                    destination = "cown", 
                                    custom_match = c("PAL" = NA))) %>% # the cow code incorrectly classifies PAL as Palau, which has no cow code
  mutate(cown_by_fixes = countrycode(where_idea, 
                                     origin = "where_idea", 
                                     destination = "cown", 
                                     custom_dict = fixes_df)) %>%  # use fixes_df
  mutate(ccode = ifelse(is.na(cown_by_cowc), cown_by_fixes, cown_by_cowc)) %>%
  select(-starts_with("cown_by")) %>%
  mutate(country_name = countrycode(ccode, origin = "cown", destination = "country.name.en")) %>%
  distinct() %>%
  glimpse()

# check names that do not exactly match
mismatches <- group_by(codes_df, where, country_name) %>%
  summarize(n = n()) %>%
  filter(where != country_name)
cbind(mismatches$where, mismatches$country_name)

codes_df %>%
  select(-country_name) %>%
  write_csv("data/variables-to-merge-ccode-idea3.csv")
