***************************************************
** Do-File to create data for repression and dissent, using the 
** Integrated Data for Event Analysis 
** event data, weighted (if desired) by the Bond et al scale of conflict & cooperation
**
** Sub-daily event data may be aggregated according to need
**
** Emily Hencken Ritter
** emily.ritter@ua.edu
**
** File name: RepressDissentCoding.do
** Purpose: Dataset management for dissertation
** Output file(s): repressdissentmonth_[date].do
**
** Last updated: February 13, 2012
**
***************************************************

clear
set mem 600m

/*
*****************

Pare raw IDEA event data into events that have the source and target in the same state.
Events related to repression or dissent only. 
Unweighted, disaggreggated.

*****************
*/

/*
**Raw IDEA files downloaded 2-3-2008 for Ritter dissertation
*insheet using "/Users/emilyritter/Documents/Data/IDEA/Raw IDEA/1990-1994 Data (N=2679938).txt", clear

* Use only those events that are intrastate.
keep if  srcname==tgtname
compress

* Recode date into Stata date format
gen edate=eventdate
gen edate2=word(edate,1)
gen edate3=date(edate2,"MDY")
format edate3 %td
label var edate3 "Stata date format"
drop edate edate2 eventdate
rename edate3 date

**Need to keep all instances of EITHER repression OR dissent.  
**So drop irrelevant event types and irrelevant actors.
drop if eventform=="<ANIA>"
drop if eventform=="<DECC>"
drop if eventform=="<SAID>"
drop if eventform=="<OCOM>"
drop if eventform=="<CONS>"
drop if eventform=="<CLAR>"
drop if eventform=="<DISC>"
drop if eventform=="<MEDI>"
drop if eventform=="<NEGO>"
drop if eventform=="<VISI>"
drop if eventform=="<HOST>"
drop if eventform=="<ENDO>"
drop if eventform=="<PRAI>"
drop if eventform=="<EMPA>"
drop if eventform=="<FORG>"
drop if eventform=="<RATI>"
drop if eventform=="<PROM>"
drop if eventform=="<PROO>"
drop if eventform=="<PRMS>"
drop if eventform=="<PRME>"
drop if eventform=="<PRMM>"
drop if eventform=="<PRMH>"
drop if eventform=="<ASSR>"
drop if eventform=="<AMED>"
drop if eventform=="<GRAN>"
drop if eventform=="<INVI>"
drop if eventform=="<SHEP>"
drop if eventform=="<GASY>"
drop if eventform=="<EVAC>"
drop if eventform=="<REWD>"
drop if eventform=="<SRAL>"
drop if eventform=="<REQS>"
drop if eventform=="<SEEK>"
drop if eventform=="<SOLS>"
drop if eventform=="<ASKM>"
drop if eventform=="<ASKE>"
drop if eventform=="<ASKI>"
drop if eventform=="<ASKH>"
drop if eventform=="<RFIN>"
drop if eventform=="<REME>"
drop if eventform=="<ASKP>"
drop if eventform=="<REJC>"
drop if eventform=="<RPRO>"
drop if eventform=="<RCEA>"
drop if eventform=="<RPKO>"
drop if eventform=="<RSET>"
drop if eventform=="<RRMA>"
drop if eventform=="<RPMD>"
drop if eventform=="<RMED>"
drop if eventform=="<RALL>"
drop if eventform=="<OPEN>"
drop if eventform=="<BLAW>"
drop if eventform=="<ACCU>"
drop if eventform=="<HIDE>"
drop if eventform=="<IHRA>"
drop if eventform=="<INMA>"
drop if eventform=="<DEPS>"
drop if eventform=="<DEAI>"
drop if eventform=="<DEPK>"
drop if eventform=="<DEME>"
drop if eventform=="<DEWI>"
drop if eventform=="<DECF>"
drop if eventform=="<DEMN>"
drop if eventform=="<DEII>"
drop if eventform=="<HPKO>"
drop if eventform=="<CRAR>"
drop if eventform=="<MONI>"
drop if eventform=="<ECON>"
drop if eventform=="<TRAN>"
drop if eventform=="<CCTA>"
drop if eventform=="<DEFA>"
drop if eventform=="<GDEF>"
drop if eventform=="<CDEF>"
drop if eventform=="<OHAC>"
drop if eventform=="<VOTE>"
drop if eventform=="<GADJ>"
drop if eventform=="<ILLN>"
drop if eventform=="<HINF>"
drop if eventform=="<NILL>"
drop if eventform=="<DEAT>"
drop if eventform=="<ESTA>"
drop if eventform=="<BOPS>"
drop if eventform=="<RESE>"
drop if eventform=="<EXCH>"
drop if eventform=="<EPRI>"
drop if eventform=="<EQUP>"
drop if eventform=="<EQDN>"
drop if eventform=="<EARN>"
drop if eventform=="<EAAX>"
drop if eventform=="<EABX>"
drop if eventform=="<REAL>"
drop if eventform=="<CPRI>"
drop if eventform=="<INTR>"
drop if eventform=="<INUP>"
drop if eventform=="<INDN>"
drop if eventform=="<COGN>"
drop if eventform=="<AFFE>"
drop if eventform=="<BELI>"
drop if eventform=="<OHCO>"
drop if eventform=="<NATD>"
drop if eventform=="<DROU>"
drop if eventform=="<EART>"
drop if eventform=="<FLOO>"
drop if eventform=="<HURR>"
drop if eventform=="<TORN>"
drop if eventform=="<VOLC>"
drop if eventform=="<TSUN>"
drop if eventform=="<WFIR>"
drop if eventform=="<CLIM>"
drop if eventform=="<ACCI>"
drop if eventform=="<SPIL>"
drop if eventform=="<NUKA>"
drop if eventform=="<ORIN>"
drop if eventform=="<AATT>"
drop if eventform=="<ADEA>"
drop if eventform=="<AILL>"
drop if eventform=="<OANI>"
drop if eventform=="<PERF>"
drop if eventform=="<SPOR>"
drop if eventform=="<HACT>"
drop if eventform=="<HCON>"
drop if eventform=="<OINC>"
drop if eventform=="<PHEN>"
drop if eventform=="<GCTA>"
drop if eventform=="<LITI>"
drop if eventform=="<MINE>"
drop if eventform=="<JACK>"
drop if tgtname=="UN"
drop if srcname=="UN"
drop if srcname=="_AFR"
drop if tgtname=="_AFR"
drop if srcname=="_ARC"
drop if tgtname=="_ARC"
drop if srcname=="_ASA"
drop if tgtname=="_ASA"
drop if srcname=="_CAM"
drop if tgtname=="_CAM"
drop if srcname=="_EUR"
drop if tgtname=="_EUR"
drop if srcname=="_NAM"
drop if tgtname=="_NAM"
drop if srcname=="_SAM"
drop if tgtname=="_SAM"
drop if srcname=="_WOR"
drop if tgtname=="_WOR"


** RUN ON ALL THREE DATASETS AND MERGE DATASETS TOGETHER

save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1990-1994"

clear
insheet using "/Users/emilyritter/Documents/Data/IDEA/Raw IDEA/1995-1999 Data (N=4108102).txt"
*do the above!
sort date srcname
save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1995-1999"

clear
insheet using "/Users/emilyritter/Documents/Data/IDEA/Raw IDEA/2000-2004 Data (N=3464898).txt"
*do the above!
sort date srcname
save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted2000-2004"

*Merge together
use "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1990-1994", clear
sort date srcname
merge m:m date srcname using "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1995-1999"
drop _merge
sort date srcname
merge m:m date srcname using "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted2000-2004"
drop _merge

*Label and save data: 1,422,231 events from 1990-1994 with source state = target state and events relevant to repression or dissent
label data "IDEA repression and dissent data, event-level, 1990-2004, unweighted"
save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1990-2004"
*/




/*
*****************

Code the source and target of all events as govt or civilian.
This allows us to determine which events are repression (state events targeted at non-state actors within the territorial jursidiction)
or dissent (non-state actors within the state's territory targeting an event at a state actor).

*****************
*/

use "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1990-2004", clear

gen srcisstate=0
label var srcisstate "Source is an agent of the state
gen srcisciv=0
label var srcisciv "Source is civilian (not business)
gen tgtisstate=0
label var tgtisstate "Target is an agent of the state
gen tgtisciv=0
label var tgtisciv "Target is civilian (not business)
replace srcisciv=1 if srcsector=="<ACIV>"
replace tgtisciv=1 if tgtsector=="<ACIV>"
replace srcisciv=1 if  srcsector=="<ARAB>"
replace tgtisciv=1 if  tgtsector=="<ARAB>"
replace srcisciv=1 if  srcsector=="<ARTS>"
replace tgtisciv=1 if  tgtsector=="<ARTS>"
replace srcisciv=1 if  srcsector=="<ATHL>"
replace tgtisciv=1 if  tgtsector=="<ATHL>"
replace srcisstate=1 if  srcsector=="<BILL>"
replace tgtisstate=1 if  tgtsector=="<BILL>"
*include all bosnian groups as civilians...state militaries will be under <MILT>
replace srcisciv=1 if srcsector=="<BOSC>"
replace tgtisciv=1 if tgtsector=="<BOSC>"
replace srcisciv=1 if srcsector=="<BOSM>"
replace tgtisciv=1 if tgtsector=="<BOSM>"
replace srcisciv=1 if srcsector=="<BOSS>"
replace tgtisciv=1 if tgtsector=="<BOSS>"
replace srcisstate=1 if srcsector=="<CAPI>"
replace tgtisstate=1 if tgtsector=="<CAPI>"
replace srcisciv=1 if srcsector=="<CHRO>"
replace tgtisciv=1 if tgtsector=="<CHRO>"
replace srcisciv=1 if srcsector=="<CHRT>"
replace tgtisciv=1 if tgtsector=="<CHRT>"
replace srcisciv=1 if srcsector=="<CIVI>"
replace tgtisciv=1 if tgtsector=="<CIVI>"
replace srcisciv=1 if srcsector=="<CIVS>"
replace tgtisciv=1 if tgtsector=="<CIVS>"
replace srcisstate=1 if srcsector=="<CTRY>"
replace tgtisstate=1 if tgtsector=="<CTRY>"
replace srcisciv=1 if srcsector=="<CULT>"
replace tgtisciv=1 if tgtsector=="<CULT>"
replace tgtisciv=1 if tgtsector=="<DETA>"
replace srcisciv=1 if srcsector=="<DETA>"
replace srcisstate=1 if srcsector=="" & tgtsector=="<DETA>"                          
replace tgtisstate=1 if tgtsector=="" & srcsector=="<DETA>"                          
replace srcisstate=1 if srcsector=="DIPL"
replace tgtisstate=1 if tgtsector=="<DIPL>"
replace srcisstate=1 if srcsector=="<DIPL>"
replace srcisciv=1 if srcsector=="<EDUC>"
replace tgtisciv=1 if tgtsector=="<EDUC>"
replace srcisciv=1 if srcsector=="<ETHN>"
replace tgtisciv=1 if tgtsector=="<ETHN>"
replace srcisciv=1 if srcsector=="<FARM>"
replace tgtisciv=1 if tgtsector=="<FARM>"
replace srcisstate=1 if srcsector=="<GAGE>"
replace tgtisstate=1 if tgtsector=="<GAGE>"
replace srcisciv=1 if srcsector=="<HIND>"
replace tgtisciv=1 if tgtsector=="<HIND>"
drop if srclevel=="<IGOS>"
drop if tgtlevel=="<IGOS>"
replace srcisciv=1 if srcsector=="<INSU>"
replace tgtisciv=1 if tgtsector=="<INSU>"
replace srcisciv=1 if srcsector=="<JEWS>"
replace tgtisciv=1 if tgtsector=="<JEWS>"
**Leave out judiciary as state and target, since separate in model as constraint.  
**Note this means protest against courts is left out...
**replace srcisstate=1 if srcsector=="<JUDI>"
**replace tgtisstate=1 if tgtsector=="<JUDI>"
replace srcisciv=1 if srcsector=="<KURD>"
replace tgtisciv=1 if tgtsector=="<KURD>"
replace srcisstate=1 if srcsector=="<MACT>"
replace tgtisstate=1 if tgtsector=="<MACT>"
*What to do about mass media?  I think leave them out of either category...
replace srcisciv=1 if srcsector=="<MEDI>"
replace tgtisciv=1 if tgtsector=="<MEDI>"
replace srcisciv=1 if srcsector=="<MIGR>"
replace tgtisciv=1 if tgtsector=="<MIGR>"
replace srcisstate=1 if srcsector=="<MILH>"
replace tgtisstate=1 if tgtsector=="<MILH>"
replace srcisstate=1 if srcsector=="<MILI>"
replace tgtisstate=1 if tgtsector=="<MILI>"
replace srcisciv=1 if srcsector=="<MOSL>"
replace tgtisciv=1 if tgtsector=="<MOSL>"
replace srcisstate=1 if srcsector=="<NEXE>"
replace tgtisstate=1 if tgtsector=="<NEXE>"
replace srcisciv=1 if srclevel=="<NGOS>"
replace tgtisciv=1 if tgtlevel=="<NGOS>"
replace srcisstate=1 if srcsector=="<NLEG>"
replace tgtisstate=1 if tgtsector=="<NLEG>"
replace srcisciv=1 if  srcsector=="<NOMI>"
replace tgtisciv=1 if  tgtsector=="<NOMI>"
replace tgtisstate=1 if tgtsector=="" & srcsector=="<NOMI>"                          
replace srcisstate=1 if srcsector=="" & tgtsector=="<NOMI>"                          
replace srcisciv=1 if  srcsector=="<OCCU>"
replace tgtisciv=1 if  tgtsector=="<OCCU>"
replace srcisstate=1 if  srcsector=="<OFFI>" & srclevel=="<CAPI>"
replace srcisstate=1 if  srcsector=="<OFFI>" & srclevel=="<CITY>"
replace srcisstate=1 if  srcsector=="<OFFI>" & srclevel=="<CTRY>"
replace srcisstate=1 if  srcsector=="<OFFI>" & srclevel=="<REGI>"
replace srcisstate=1 if  srcsector=="<OFFI>" & srclevel=="<SUBS>"
replace srcisciv=1 if  srcsector=="<OFFI>" & srclevel=="<ERST>"
replace srcisciv=1 if  srcsector=="<OFFI>" & srclevel=="<GATH>"
replace srcisciv=1 if  srcsector=="<OFFI>" & srclevel=="<GROU>"
replace srcisciv=1 if  srcsector=="<OFFI>" & srclevel=="<INDI>"
replace srcisciv=1 if  srcsector=="<OFFI>" & srclevel=="<ORGA>"
replace tgtisstate=1 if  tgtsector=="<OFFI>" & tgtlevel=="<CAPI>"
replace tgtisstate=1 if  tgtsector=="<OFFI>" & tgtlevel=="<CITY>"
replace tgtisstate=1 if  tgtsector=="<OFFI>" & tgtlevel=="<CTRY>"
replace tgtisstate=1 if  tgtsector=="<OFFI>" & tgtlevel=="<REGI>"
replace tgtisstate=1 if  tgtsector=="<OFFI>" & tgtlevel=="<SUBS>"
replace tgtisciv=1 if  tgtsector=="<OFFI>" & tgtlevel=="<ERST>"
replace tgtisciv=1 if  tgtsector=="<OFFI>" & tgtlevel=="<GATH>"
replace tgtisciv=1 if  tgtsector=="<OFFI>" & tgtlevel=="<GROU>"
replace tgtisciv=1 if  tgtsector=="<OFFI>" & tgtlevel=="<INDI>"
replace tgtisciv=1 if  tgtsector=="<OFFI>" & tgtlevel=="<ORGA>"
replace tgtisciv=1 if  tgtsector=="<OFFI>" & tgtlevel=="<THNG>"
replace srcisciv=1 if  srcsector=="<OFFI>" & srclevel=="<THNG>"
replace srcisstate=1 if  srcsector=="<OPPS>" & srclevel=="<CITY>"
replace srcisstate=1 if  srcsector=="<OPPS>" & srclevel=="<CTRY>"
replace srcisstate=1 if  srcsector=="<OPPS>" & srclevel=="<REGI>"
replace srcisstate=1 if  srcsector=="<OPPS>" & srclevel=="<SUBS>"
replace srcisciv=1 if  srcsector=="<OPPS>" & srclevel=="<ERST>"
replace srcisciv=1 if  srcsector=="<OPPS>" & srclevel=="<GATH>"
replace srcisciv=1 if  srcsector=="<OPPS>" & srclevel=="<GROU>"
replace srcisciv=1 if  srcsector=="<OPPS>" & srclevel=="<INDI>"
replace srcisciv=1 if  srcsector=="<OPPS>" & srclevel=="<ORGA>"
replace srcisciv=1 if  srcsector=="<OPPS>" & srclevel=="<THNG>"
replace tgtisstate=1 if  tgtsector=="<OPPS>" & tgtlevel=="<CITY>"
replace tgtisstate=1 if  tgtsector=="<OPPS>" & tgtlevel=="<CTRY>"
replace tgtisstate=1 if  tgtsector=="<OPPS>" & tgtlevel=="<REGI>"
replace tgtisstate=1 if  tgtsector=="<OPPS>" & tgtlevel=="<SUBS>"
replace tgtisciv=1 if  tgtsector=="<OPPS>" & tgtlevel=="<ERST>"
replace tgtisciv=1 if  tgtsector=="<OPPS>" & tgtlevel=="<GATH>"
replace tgtisciv=1 if  tgtsector=="<OPPS>" & tgtlevel=="<GROU>"
replace tgtisciv=1 if  tgtsector=="<OPPS>" & tgtlevel=="<INDI>"
replace tgtisciv=1 if  tgtsector=="<OPPS>" & tgtlevel=="<ORGA>"
replace tgtisciv=1 if  tgtsector=="<OPPS>" & tgtlevel=="<THNG>"
replace srcisstate=1 if  srcsector=="<PAGE>" & srclevel=="<CTRY>"
replace srcisstate=1 if  srcsector=="<PAGE>" & srclevel=="<REGI>"
replace srcisciv=1 if  srcsector=="<PAGE>" & srclevel=="<GATH>"
replace srcisciv=1 if  srcsector=="<PAGE>" & srclevel=="<GROU>"
replace srcisciv=1 if  srcsector=="<PAGE>" & srclevel=="<INDI>"
replace srcisciv=1 if  srcsector=="<PAGE>" & srclevel=="<ORGA>"
replace tgtisstate=1 if  tgtsector=="<PAGE>" & tgtlevel=="<CTRY>"
replace tgtisstate=1 if  tgtsector=="<PAGE>" & tgtlevel=="<REGI>"
replace tgtisciv=1 if  tgtsector=="<PAGE>" & tgtlevel=="<GATH>"
replace tgtisciv=1 if  tgtsector=="<PAGE>" & tgtlevel=="<GROU>"
replace srcisciv=1 if  srcsector=="<PALT>"
replace tgtisciv=1 if  tgtsector=="<PALT>"
replace srcisstate=1 if srcsector=="<PART>"
replace tgtisstate=1 if tgtsector=="<PART>"
**Haven't done anything with PEXE...too vague.
replace srcisciv=1 if srcsector=="<PHIL>"
replace tgtisciv=1 if tgtsector=="<PHIL>"
replace srcisstate=1 if srcsector=="<POLI>"
replace tgtisstate=1 if tgtsector=="<POLI>"
replace srcisstate=1 if srcsector=="<RAD2>"
replace tgtisstate=1 if tgtsector=="<RAD2>"
replace srcisciv=1 if srcsector=="<RELI>"
replace tgtisciv=1 if tgtsector=="<RELI>"
replace srcisciv=1 if srcsector=="<RIOT>"
replace tgtisciv=1 if tgtsector=="<RIOT>"
replace srcisstate=1 if srcsector=="<ROYA>"
replace tgtisstate=1 if tgtsector=="<ROYA>"
replace srcisstate=1 if srcsector=="<SNOF>"
replace tgtisstate=1 if tgtsector=="<SNOF>"
replace srcisciv=1 if srcsector=="<STRI>"
replace tgtisciv=1 if tgtsector=="<STRI>"
replace srcisciv=1 if srcsector=="<STUD>"
replace tgtisciv=1 if tgtsector=="<STUD>"
**replace srcisstate=1 if srcsector=="<SUBS>"
replace srcisstate=1 if  srcsector=="<TAGE>" & srclevel=="<CAPI>"
replace srcisstate=1 if  srcsector=="<TAGE>" & srclevel=="<CITY>"
replace srcisstate=1 if  srcsector=="<TAGE>" & srclevel=="<CTRY>"
replace srcisstate=1 if  srcsector=="<TAGE>" & srclevel=="<REGI>"
replace srcisciv=1 if  srcsector=="<UNIO>"
replace tgtisciv=1 if  tgtsector=="<UNIO>"
label var place "State Location of Report Desk"


**Generate variables as to whether the event is an offer, accepted offer, dissent, repression, or revision

gen offer=0
gen accept=0
gen dissct=0
gen repct=0
gen revise=0
label var offer "State makes offer to civilians
label var accept "Civilians accept offer from state
label var dissct "Dichotomous dissent presence
label var repct "Dichotomous repression presence
label var revise "State revises existing repression
replace repct=1 if eventform=="<PCOM>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<PCOM>" & srcisciv==1 & tgtisstate==1
replace revise=1 if eventform=="<APOL>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<EASS>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<TRUC>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<RPOL>" & srcisstate==1 
replace revise=1 if eventform=="<RSAN>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<DMOB>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<RCUR>" & srcisstate==1 
drop if eventform=="<DMIN>"
replace revise=1 if eventform=="<EESB>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<EMSA>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<RELE>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<RRPE>" & srcisstate==1 & tgtisciv==1
replace revise=1 if eventform=="<RRPR>" & srcisstate==1 & tgtisciv==1
replace offer=1 if eventform=="<EEAI>" & srcisstate==1 & tgtisciv==1
replace offer=1 if eventform=="<EMAI>" & srcisstate==1 & tgtisciv==1
replace offer=1 if eventform=="<EHAI>" & srcisstate==1 & tgtisciv==1
replace accept=1 if eventform=="<AGRE>" & srcisciv==1 & tgtisstate==1
replace accept=1 if eventform=="<AGAC>" & srcisciv==1 & tgtisstate==1
replace accept=1 if eventform=="<ATPK>" & srcisciv==1 & tgtisstate==1
replace accept=1 if eventform=="<ATME>" & srcisciv==1 & tgtisstate==1
replace accept=1 if eventform=="<ATNE>" & srcisciv==1 & tgtisstate==1
replace accept=1 if eventform=="<ATSE>" & srcisciv==1 & tgtisstate==1
replace accept=1 if eventform=="<COLL>" & srcisciv==1 & tgtisstate==1
replace offer=1 if eventform=="<RWCF>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<CALL>" & srcisciv==1 & tgtisstate==1
replace offer=1 if eventform=="<PROP>" & srcisstate==1 & tgtisciv==1
replace offer=1 if eventform=="<PTRU>" & srcisstate==1 & tgtisciv==1
replace offer=1 if eventform=="<PTMN>" & srcisstate==1 & tgtisciv==1
replace offer=1 if eventform=="<PTME>" & srcisstate==1 & tgtisciv==1
replace repct=1 if eventform=="<BANA>" & srcisstate==1 
replace repct=1 if eventform=="<CENS>" & srcisstate==1 
replace dissct=1 if eventform=="<DEFY>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<BLAM>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<BLAM>" & srcisstate==1 & tgtisciv==1
replace repct=1 if eventform=="<COMP>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<COMP>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<ICOM>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<ICOM>" & srcisstate==1 & tgtisciv==1
replace repct=1 if eventform=="<FCOM>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<FCOM>" & srcisciv==1 & tgtisstate==1
**DENY?  i think ignore...
**Treat demand as an offer, since it is if the state offers it to civilians.
replace offer=1 if eventform=="<DEMA>" & srcisstate==1 & tgtisciv==1
replace offer=1 if eventform=="<DERI>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<WARN>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<WARN>" & srcisstate==1 & tgtisciv==1
replace repct=1 if eventform=="<ALER>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<ALER>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MALT>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MALT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<NUCA>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<NUCA>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<INCC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<INCC>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MDIS>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MDIS>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<ADIS>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<ADIS>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<NDIS>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<NDIS>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TDIS>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TDIS>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<THRT>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<THRT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TUNS>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TUNS>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TSAN>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TSAN>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<THEN>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<THEN>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<THME>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<THME>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TRSA>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TRSA>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TBOE>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TBOE>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TRBR>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TRBR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MTHR>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MTHR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TATT>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TATT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TBLO>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TBLO>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TOCC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TOCC>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TWAR>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TWAR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TNUC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TNUC>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<TCBR>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<TCBR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<ULTI>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<ULTI>" & srcisciv==1 & tgtisstate==1
**What to do about threats?  Seems like they shouldn't count since not ACTUAL repression or dissent, but Shellman seems to include them if they count as negative statements...keep them.
replace repct=1 if eventform=="<NMFT>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<NMFT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<DEMO>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<DEMO>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<PDEM>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<POBS>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<PMAR>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<PPRO>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<PALT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MDEM>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MDEM>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MOBL>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MOBL>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<BFOR>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<BFOR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<SANC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<SANC>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MBLO>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MBLO>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<REDR>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<REDR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<REDA>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<REDA>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<HECO>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<HECO>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<HAID>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<HAID>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<HMIL>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<HMIL>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<HALO>" & srcisstate==1 & tgtisciv==1
replace repct=1 if eventform=="<HALO>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<HALO>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<HALT>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<HALT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<HAME>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<HAME>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<BREL>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<BREL>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<STRI>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<DWAR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<DWAR>" & srcisstate==1 & tgtisciv==1
replace repct=1 if eventform=="<EXIL>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<EXIL>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<SEIZ>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<SEIZ>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<SEZR>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<SEZR>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MOCC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MOCC>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<BVIO>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<BVIO>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<POAR>" & srcisstate==1 & tgtisciv==1
replace repct=1 if eventform=="<ABDU>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<ABDU>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<HTAK>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<HTAK>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<FORC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<FORC>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<PASS>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<PASS>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<BEAT>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<BEAT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<CORP>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<CORP>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<SEXA>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<SEXA>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<MAIM>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<MAIM>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<RAID>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<RAID>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<CLAS>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<CLAS>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<ASSA>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<ASSA>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<COUP>" & srcisciv==1 & tgtisstate==1
replace dissct=0 if eventform=="<COUP>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<PEXE>" & srcisstate==1 & tgtisciv==1
replace dissct=0 if eventform=="<PEXE>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<GRPG>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<PEXE>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<GRPG>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<SBOM>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<VBOM>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<VBOM>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<AERI>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<AERI>" & srcisciv==1 & tgtisstate==1
replace dissct=1 if eventform=="<RIOT>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<CBRU>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<CBRU>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<CBIO>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<CBIO>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<RNUC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<RNUC>" & srcisciv==1 & tgtisstate==1
replace repct=1 if eventform=="<CONC>" & srcisstate==1 & tgtisciv==1
replace dissct=1 if eventform=="<CONC>" & srcisciv==1 & tgtisstate==1

**TO REDUCE DUPLICATE EVENTS (and also vague coding for offers and such)
**Reduce dataset to just repression and dissent

drop offer
drop accept
drop revise

**Don't need if all of these variables are equal to zero, since building a count and level
**Only need to know when it starts and the level of conflict
drop if dissct==0 & repct==0 
* That leaves 95,138 repression or dissent events in the data: 44,187 repression events and 50,951 dissent events

save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1990-2004.dta", replace


**Generate COW Codes
do "C:\Users\Emily Ritter\Desktop\Dissertation Data\IDEAS 2-3-08\ideas 2 cowact.do"
drop if cowcode>9999
label var cowcode "COW Country Codes"



duplicates report id

**7326 observations are a duplicated story id, meaning one story yielded multiple events or event type
**Since there is no way to discern if an event is actually being duplicated without the leads, 
**I'll leave them in the dataset and assume them to be separate events in a single lead.
**However, if an event has the same event id and all variables of source, target, date, and event 
**are identical, I drop the duplicates to avoid inflating dissent or repression events.

duplicates report id place date eventform srcname srcsector srclevel tgtname tgtsector tgtlevel srcisstate srcisciv tgtisstate tgtisciv dissct repct cowcode

*There are 921 surplus...extra listings of the identical event.

duplicates drop id place date eventform srcname srcsector srclevel tgtname tgtsector tgtlevel srcisstate srcisciv tgtisstate tgtisciv dissct repct cowcode, force
 
**Observations left: 91133


* extract parts from date
gen year =year(date)gen month=month(date)gen qtr=quarter(date)gen day =day(date)

label var year Year
label var month Month
label var qtr Quarter
label var day Day

rename cowcode ccode

save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsunweighted1990-2004.dta", replace




/*
*****************

CODING FOR CONFLICT LEVELS

Taylor et al (1999) Intrastate Conflict Levels
Note: I cannot replicate the formation of these levels, and so I cannot extend them to eventforms
that are not included.  This means loss of low level repressive events, though more than the 
average dataset are included.  Fewer events than IPI, but more coverage.  Shellman means loss of 
detail. Goldstein intended only for interstate. Used do file from David R. Davis.

*****************
*/

gen govactor=srcisstate
gen wrepress=0
label var wrepress "Taylor et al Conflict-Cooperation Weights (Repression)
replace wrepress=-2.063 if eventform=="<ACCU>" & govactor==1replace wrepress=-11.22 if eventform=="<AERI>" & govactor==1replace wrepress=-9.876 if eventform=="<ASSA>" & govactor==1
replace wrepress=-5.813 if eventform=="<BANA>" & govactor==1replace wrepress=-8.689 if eventform=="<BEAT>" & govactor==1replace wrepress=-6.470 if eventform=="<BFOR>" & govactor==1replace wrepress=-2.063 if eventform=="<BLAM>" & govactor==1replace wrepress=-5.314 if eventform=="<BREL>" & govactor==1replace wrepress=-10.813 if eventform=="<CBIO>" & govactor==1replace wrepress=-11.033 if eventform=="<CBRU>" & govactor==1replace wrepress=-2.969 if eventform=="<CENS>" & govactor==1replace wrepress=-2.939 if eventform=="<CLAR>" & govactor==1replace wrepress=-10.657 if eventform=="<CLAS>" & govactor==1replace wrepress=-3.844 if eventform=="<CONC>" & govactor==1replace wrepress=-8.282 if eventform=="<CORP>" & govactor==1replace wrepress=-10.001 if eventform=="<DWAR>" & govactor==1replace wrepress=-10.5 if eventform=="<GRPG>" & govactor==1replace wrepress=-3.658 if eventform=="<HALT>" & govactor==1replace wrepress=-4.782 if eventform=="<HAME>" & govactor==1replace wrepress=-8.719 if eventform=="<MAIM>" & govactor==1replace wrepress=-3.064 if eventform=="<MALT>" & govactor==1replace wrepress=-7.095 if eventform=="<MBLO>" & govactor==1replace wrepress=-7.204 if eventform=="<MDEM>" & govactor==1replace wrepress=-9.626 if eventform=="<MINE>" & govactor==1replace wrepress=-7.938 if eventform=="<MOBL>" & govactor==1replace wrepress=-4.501 if eventform=="<MOCC>" & govactor==1replace wrepress=-4.657 if eventform=="<MONI>" & govactor==1replace wrepress=-9.183 if eventform=="<MTHR>" & govactor==1replace wrepress=-7.376 if eventform=="<NMFT>" & govactor==1replace wrepress=-3.032 if eventform=="<OPEN>" & govactor==1replace wrepress=-8.571 if eventform=="<PASS>" & govactor==1replace wrepress=-9.907 if eventform=="<PEXE>" & govactor==1replace wrepress=-4.939 if eventform=="<POAR>" & govactor==1replace wrepress=-10.399 if eventform=="<RAID>" & govactor==1replace wrepress=-4.667 if eventform=="<RALL>" & govactor==1replace wrepress=-5.376 if eventform=="<RCEA>" & govactor==1replace wrepress=-5.118 if eventform=="<REDA>" & govactor==1replace wrepress=-3.626 if eventform=="<REDR>" & govactor==1replace wrepress=-4.539 if eventform=="<REJC>" & govactor==1replace wrepress=-11.033 if eventform=="<RNUC>" & govactor==1replace wrepress=-3.876 if eventform=="<RPMD>" & govactor==1replace wrepress=-4.803 if eventform=="<RPRO>" & govactor==1replace wrepress=-5.529 if eventform=="<SANC>" & govactor==1replace wrepress=-6.250 if eventform=="<SEIZ>" & govactor==1replace wrepress=-4.501 if eventform=="<SEZR>" & govactor==1replace wrepress=-9.126 if eventform=="<TATT>" & govactor==1
replace wrepress=-6.814 if eventform=="<TBLO>" & govactor==1replace wrepress=-5.251 if eventform=="<TBOE>" & govactor==1replace wrepress=-9.876 if eventform=="<TCBR>" & govactor==1replace wrepress=-4.657 if eventform=="<THEN>" & govactor==1replace wrepress=-4.188 if eventform=="<THME>" & govactor==1replace wrepress=-6.940 if eventform=="<THRT>" & govactor==1replace wrepress=-10.813 if eventform=="<TNUC>" & govactor==1replace wrepress=-8.438 if eventform=="<TOCC>" & govactor==1replace wrepress=-4.282 if eventform=="<TRBR>" & govactor==1replace wrepress=-4.688 if eventform=="<TRSA>" & govactor==1replace wrepress=-4.613 if eventform=="<TSAN>" & govactor==1replace wrepress=-4.969 if eventform=="<TUNS>" & govactor==1replace wrepress=-10.032 if eventform=="<TWAR>" & govactor==1replace wrepress=-6.657 if eventform=="<ULTI>" & govactor==1replace wrepress=-11.001 if eventform=="<VBOM>" & govactor==1

tab eventform if wrepress==0 & govactor==1

*Added to David's file based on scales in excel files.  Also, some not listed, and added (where noted).

replace wrepress=-8.532 if eventform=="<ABDU>" & govactor==1 
*applied HTAK to ABDU
replace wrepress=-3.064 if eventform=="<ALER>" & govactor==1 
*applied armed force alert to ALER
replace wrepress=-7.845 if eventform=="<BVIO>" & govactor==1 
drop if eventform=="<CALL>" & govactor==1
replace wrepress=-2.079 if eventform=="<COMP>" & govactor==1 
*average ICOM and FCOM
replace wrepress=-6.313 if eventform=="<EXIL>" & govactor==1
replace wrepress=-2.251 if eventform=="<FCOM>" & govactor==1
replace wrepress=-9.571 if eventform=="<FORC>" & govactor==1 
*average all subheadings starting 22
replace wrepress=-5.064 if eventform=="<HAID>" & govactor==1
replace wrepress=-4.220 if eventform=="<HALO>" & govactor==1 
*average HALT and HAME
replace wrepress=-5.313 if eventform=="<HECO>" & govactor==1
replace wrepress=-8.532 if eventform=="<HTAK>" & govactor==1
replace wrepress=-1.907 if eventform=="<ICOM>" & govactor==1
replace wrepress=-3.064 if eventform=="<INCC>" & govactor==1 
*applied armed force alert to INCC (like ALER)
replace wrepress=-2.938 if eventform=="<MDIS>" & govactor==1 
*average all subheadings ADIS NDIS TDIS
replace wrepress=-3.97  if eventform=="<NUCA>" & govactor==1
replace wrepress=-1.282 if eventform=="<PCOM>" & govactor==1
replace wrepress=-8.594 if eventform=="<SEXA>" & govactor==1
replace wrepress=-2.688 if eventform=="<TDIS>" & govactor==1
replace wrepress=-3.064 if eventform=="<WARN>" & govactor==1 
*applied armed force alert to WARN (like ALER)

tab eventform if wrepress==0 & govactor==1

**Now weight dissent actions

gen civactor=srcisciv 
gen wdissent=0
label var wdissent "Taylor et al Conflict-Cooperation Weights (Dissent)"

*use same weights as repression, but with civilian actor

replace wdissent=-2.063 if eventform=="<ACCU>" & civactor==1replace wdissent=-11.22 if eventform=="<AERI>" & civactor==1replace wdissent=-9.876 if eventform=="<ASSA>" & civactor==1replace wdissent=-5.813 if eventform=="<BANA>" & civactor==1replace wdissent=-8.689 if eventform=="<BEAT>" & civactor==1replace wdissent=-6.470 if eventform=="<BFOR>" & civactor==1replace wdissent=-2.063 if eventform=="<BLAM>" & civactor==1replace wdissent=-5.314 if eventform=="<BREL>" & civactor==1replace wdissent=-10.813 if eventform=="<CBIO>" & civactor==1replace wdissent=-11.033 if eventform=="<CBRU>" & civactor==1replace wdissent=-2.969 if eventform=="<CENS>" & civactor==1replace wdissent=-2.939 if eventform=="<CLAR>" & civactor==1replace wdissent=-10.657 if eventform=="<CLAS>" & civactor==1replace wdissent=-3.844 if eventform=="<CONC>" & civactor==1replace wdissent=-8.282 if eventform=="<CORP>" & civactor==1replace wdissent=-10.001 if eventform=="<DWAR>" & civactor==1replace wdissent=-10.5 if eventform=="<GRPG>" & civactor==1replace wdissent=-3.658 if eventform=="<HALT>" & civactor==1replace wdissent=-4.782 if eventform=="<HAME>" & civactor==1replace wdissent=-8.719 if eventform=="<MAIM>" & civactor==1replace wdissent=-3.064 if eventform=="<MALT>" & civactor==1replace wdissent=-7.095 if eventform=="<MBLO>" & civactor==1replace wdissent=-7.204 if eventform=="<MDEM>" & civactor==1replace wdissent=-9.626 if eventform=="<MINE>" & civactor==1replace wdissent=-7.938 if eventform=="<MOBL>" & civactor==1replace wdissent=-4.501 if eventform=="<MOCC>" & civactor==1replace wdissent=-4.657 if eventform=="<MONI>" & civactor==1replace wdissent=-9.183 if eventform=="<MTHR>" & civactor==1replace wdissent=-7.376 if eventform=="<NMFT>" & civactor==1replace wdissent=-3.032 if eventform=="<OPEN>" & civactor==1replace wdissent=-8.571 if eventform=="<PASS>" & civactor==1replace wdissent=-9.907 if eventform=="<PEXE>" & civactor==1replace wdissent=-4.939 if eventform=="<POAR>" & civactor==1replace wdissent=-10.399 if eventform=="<RAID>" & civactor==1replace wdissent=-4.667 if eventform=="<RALL>" & civactor==1replace wdissent=-5.376 if eventform=="<RCEA>" & civactor==1replace wdissent=-5.118 if eventform=="<REDA>" & civactor==1replace wdissent=-3.626 if eventform=="<REDR>" & civactor==1replace wdissent=-4.539 if eventform=="<REJC>" & civactor==1replace wdissent=-11.033 if eventform=="<RNUC>" & civactor==1replace wdissent=-3.876 if eventform=="<RPMD>" & civactor==1replace wdissent=-4.803 if eventform=="<RPRO>" & civactor==1replace wdissent=-5.529 if eventform=="<SANC>" & civactor==1replace wdissent=-6.250 if eventform=="<SEIZ>" & civactor==1replace wdissent=-4.501 if eventform=="<SEZR>" & civactor==1replace wdissent=-9.126 if eventform=="<TATT>" & civactor==1
replace wdissent=-6.814 if eventform=="<TBLO>" & civactor==1replace wdissent=-5.251 if eventform=="<TBOE>" & civactor==1replace wdissent=-9.876 if eventform=="<TCBR>" & civactor==1replace wdissent=-4.657 if eventform=="<THEN>" & civactor==1replace wdissent=-4.188 if eventform=="<THME>" & civactor==1replace wdissent=-6.940 if eventform=="<THRT>" & civactor==1replace wdissent=-10.813 if eventform=="<TNUC>" & civactor==1replace wdissent=-8.438 if eventform=="<TOCC>" & civactor==1replace wdissent=-4.282 if eventform=="<TRBR>" & civactor==1replace wdissent=-4.688 if eventform=="<TRSA>" & civactor==1replace wdissent=-4.613 if eventform=="<TSAN>" & civactor==1replace wdissent=-4.969 if eventform=="<TUNS>" & civactor==1replace wdissent=-10.032 if eventform=="<TWAR>" & civactor==1replace wdissent=-6.657 if eventform=="<ULTI>" & civactor==1replace wdissent=-11.001 if eventform=="<VBOM>" & civactor==1

tab eventform if wdissent==0 & civactor==1

*Added to David's file based on scales in excel files.  Also, some not listed, and added (where noted).

replace wdissent=-8.532 if eventform=="<ABDU>" & civactor==1 
*applied HTAK to ABDU
replace wdissent=-3.282 if eventform=="<ADIS>" & civactor==1 
replace wdissent=-3.064 if eventform=="<ALER>" & civactor==1 
*applied armed force alert to ALER
replace wdissent=-7.845 if eventform=="<BVIO>" & civactor==1 
drop if eventform=="<CALL>" & civactor==1
replace wdissent=-2.079 if eventform=="<COMP>" & civactor==1 
*average ICOM and FCOM
replace wdissent=-3.886 if eventform=="<DEFY>" & civactor==1
*average all subheadings coded 113 
replace wdissent=-6.105 if eventform=="<DEMO>" & civactor==1 
*average all subheadings coded 18 except 1815 which is not in set
replace wdissent=-6.313 if eventform=="<EXIL>" & civactor==1
replace wdissent=-2.251 if eventform=="<FCOM>" & civactor==1
replace wdissent=-9.571 if eventform=="<FORC>" & civactor==1 
*average all subheadings starting 22
replace wdissent=-5.064 if eventform=="<HAID>" & civactor==1
replace wdissent=-4.220 if eventform=="<HALO>" & civactor==1 
*average HALT and HAME
replace wdissent=-5.313 if eventform=="<HECO>" & civactor==1
replace wdissent=-5.032 if eventform=="<HMIL>" & civactor==1 
replace wdissent=-8.532 if eventform=="<HTAK>" & civactor==1
replace wdissent=-1.907 if eventform=="<ICOM>" & civactor==1
replace wdissent=-3.064 if eventform=="<INCC>" & civactor==1 
*applied armed force alert to INCC (like ALER)
replace wdissent=-2.938 if eventform=="<MDIS>" & civactor==1 
*average all subheadings ADIS NDIS TDIS
replace wdissent=-3.97  if eventform=="<NUCA>" & civactor==1
replace wdissent=-6.032 if eventform=="<PALT>" & civactor==1 
replace wdissent=-1.282 if eventform=="<PCOM>" & civactor==1
replace wdissent=-5.556 if eventform=="<PDEM>" & civactor==1 
*average all subheadings coded 181 except informational which is not in set
replace wdissent=-4.094 if eventform=="<PMAR>" & civactor==1 
replace wdissent=-5.001 if eventform=="<POBS>" & civactor==1 
replace wdissent=-7.095 if eventform=="<PPRO>" & civactor==1 
replace wdissent=-9.126 if eventform=="<RIOT>" & civactor==1 
replace wdissent=-10.876 if eventform=="<SBOM>" & civactor==1 
replace wdissent=-8.594 if eventform=="<SEXA>" & civactor==1
replace wdissent=-5.782 if eventform=="<STRI>" & civactor==1
replace wdissent=-2.688 if eventform=="<TDIS>" & civactor==1
replace wdissent=-3.064 if eventform=="<WARN>" & civactor==1 
*applied armed force alert to WARN (like ALER)

tab eventform if wdissent==0 & civactor==1

*drop weights if target is not correct opponent

replace wrepress=0 if wrepress!=0 & repct==0
replace wdissent=0 if wdissent!=0 & dissct==0

*Save as unaggregated file: repdisseventsweighted1990-2004.dta
label data "IDEA repression and dissent data, event-level, 1990-2004, weighted"
save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsweighted1990-2004.dta", replace




/*
*****************

As a robustness check, create an indicator that counts representative events in categories that are distinctly different,
since it's difficult to assume that these events are all actually on a continuous latent variable. Then can predict likelihood 
(did this type of event occur) and compare the categories of level.
(Code originally in RDevents9-8-09.do, updated Feb 13, 2012.)

*****************
*/

use "/Users/emilyritter/Documents/Data/IDEA/repdisseventsweighted1990-2004.dta", clear
compress

*this data is already coded as to weight, so I can use it to see what is obviously 
*a different level.

tab eventform if wdissent<=-10
tab eventform if wdissent<=-7 & wdissent>-10
tab eventform if wdissent<=-4 & wdissent>-7
tab eventform if wdissent<0 & wdissent>-4

*raid (-10.399): armed hostilities (actions or battles, 2024 events)
gen armeddis=0
replace armeddis=1 if eventform=="<RAID>" & dissct==1
label var armeddis "Armed dissent hostilities"

*physical assault (-8.571) & corporal punishment (-8.282)& beating (-8.689): all uses of non-armed physical force in assaults against people (2497 events)
gen assaultdis=0
replace assaultdis=1 if (eventform=="<PASS>" | eventform=="<CORP>" | eventform=="<BEAT>") & dissct==1
label var assaultdis "Non-armed physical assault, dissent"

*non-military protest & sit-ins (-5.001), protest processions(-4.094), and protests that place the protester at risk (-6.032): 2268 events
gen protest=0
replace protest=1 if (eventform=="<POBS>" |eventform=="<PMAR>" | eventform=="<PALT>") & dissct==1
label var protest "Non-violent protests, dissent"

tab eventform if wrepress<=-10
tab eventform if wrepress<=-7 & wrepress>-10
tab eventform if wrepress<=-4 & wrepress>-7
tab eventform if wrepress<0 & wrepress>-4

*raid (-10.399): armed battle (2542 events)
gen armedrep=0
replace armedrep=1 if eventform=="<RAID>" & repct==1
label var armedrep "Armed repressive hostilities"

*physical assualt (-8.571) & corporal punishment (-8.282)& beating (-8.689): 3210 events
gen assaultrep=0
replace assaultrep=1 if (eventform=="<PASS>" | eventform=="<CORP>" | eventform=="<BEAT>") & repct==1
label var assaultrep "Non-armed physical assault, repression"

*declare martial law or curfew and the imposition of similar rules (-5.813): 2413 events
gen restrict=0
replace restrict=1 if eventform=="<BANA>" & repct==1
label var restrict "Declare martial law or curfew, repression"


*So we can use each of those dichotomous indicators individually, or use an indicator when any of these three clear events occurs
gen d3=0
replace d3=1 if armeddis==1 | assaultdis==1 | protest==1
label var d3 "Indicator of clear dissent: =1 if armeddis, assaultdis, or protest=1"
gen r3=0 
replace r3=1 if armedrep==1 | assaultrep==1 | restrict==1
label var r3 "Indicator of clear repression: =1 if armedrep, assaultrep, or restrict=1"

*Weight each of the individual indicators, to create a measure of severity without the conceptual muddling of the unclear latent variable
*involved in the aggregation of ALL of the IDEA events. 

gen diss3=0
replace diss3=wdissent if eventform=="<RAID>" & dissct==1
replace diss3=wdissent if (eventform=="<PASS>" | eventform=="<CORP>" | eventform=="<BEAT>") & dissct==1
replace diss3=wdissent if (eventform=="<POBS>" |eventform=="<PMAR>" | eventform=="<PALT>") & dissct==1
label var diss3 "Conflict level of 3 types of dissent events: armeddis, assaultdis, protest"

gen rep3=0
replace rep3=wrepress if eventform=="<RAID>" & repct==1
replace rep3=wrepress if (eventform=="<PASS>" | eventform=="<CORP>" | eventform=="<BEAT>") & repct==1
replace rep3=wrepress if eventform=="<BANA>" & repct==1
label var rep3 "Conflict level of 3 types of repression events: armedrep, assaultrep, restrict"

label data "IDEA repression and dissent data, event-level, 1990-2004, weighted, index created"
save "/Users/emilyritter/Documents/Data/IDEA/repdisseventsweightedindex1990-2004.dta", replace

/*
*****************

Now aggregate by chosen time period

*****************
*/

use "/Users/emilyritter/Documents/Data/IDEA/repdisseventsweightedindex1990-2004.dta", replace
gen count=1
collapse (sum) violeventct=count repct dissct rep3 diss3 r3 d3 wrepress wdissent armeddis assaultdis protest armedrep assaultrep restrict, by(ccode year) //by(ccode month year)
gen repwgtavg = wrepress/repct
gen disswgtavg = wdissent/dissct
*average is missing if the count is zero (undefined value)
replace repwgtavg = 0 if repct==0
replace disswgtavg = 0 if dissct==0

label var violeventct "Number of repression and dissent events reported in total"
label var wrepress "Additive Repression Conflict Level"
label var wdissent "Additive Dissent Conflict Level"
label var repct "Number of All Repression Events"
label var dissct "Number of All Dissent Events"
label var r3 "Number of Repression Events: 3 event types"
label var d3 "Number of Dissent Events: 3 event types"
label var rep3 "Additive Repression Conflict Level: 3 event types"
label var diss3 "Additive Dissent Conflict Level: 3 event types"
label var ccode "COW Identification Code"
label var repwgtavg "Average Repression Conflict Level"
label var disswgtavg "Average Dissent Conflict Level"
label var armeddis "Armed dissent hostilities"
label var assaultdis "Non-armed physical assault, dissent"
label var protest "Non-violent protests, dissent"
label var armedrep "Armed repressive hostilities"
label var assaultrep "Non-armed physical assault, repression"
label var restrict "Declare martial law or curfew, repression"

* Fill out the rest of the observations to balance the panels: should be 0s if there were no repression or dissent
*events reported in that month...not missing. 

gen edate=ym(year,month)
format edate %tm
label var edate "Observation Month and Year"

*xtset ccode edate
*tsfill

*I sure would like to fill in the rest of the panel, but it's not correctly extracting the right month from the electronic dates,
*making me super suspicious that the dates are correct....
*replace month=month(edate) if month==.





*Save as aggregated file: repdiss[aggtimeperiod]weighted1990-2004.dta
*label data "IDEA repression and dissent data, event-level, 1990-2004, weighted"
*label data "IDEA repression and dissent data, month-level, 1990-2004, weighted, index created"
*save "/Users/emilyritter/Documents/Data/IDEA/repdissmonthlyweightedindex1990-2004.dta", replace

sort ccode year
label data "IDEA repression and dissent data, annual-level, 1990-2004, weighted, index created"
save "/Users/emilyritter/Documents/Data/IDEA/repdissannualweightedindex1990-2004.dta", replace
