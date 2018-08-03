
# -------------
# phony targets
# -------------

all: tests model data
data: data/idea-counts.csv
model: latent-dissent.csv latent-dissent.dta
tests: 	figs/eta.png figs/cors.png figs/fariss-test.png figs/hj-test.png figs/nordas-davenport-test.png figs/nordas-davenport-compare-measures.png

# ----------
# clean data
# ----------

# use *'s to replace middle sections of long filenames
data/raw/king-lowe-2008/1990*.txt data/raw/king-lowe-2008/1995*.txt data/raw/king-lowe-2008/2000*.txt data/raw/king-lowe-2008/levels*.txt data/raw/king-lowe-2008/names*.txt data/raw/king-lowe-2008/sectors*.txt: R/*-download-king-lowe-data.R
	Rscript $<

data/murdie-bhasin-events.csv: R/*-create-murdie-bhasin-events-df.R
	Rscript $<

data/empty-country-years-to-fill.csv: R/*-create-empty-country-years.R data/raw/system2016.csv
	Rscript $<

data/idea-dissent-events.csv data/idea-all-events.csv: R/*-clean-idea-data.R data/murdie-bhasin-events.csv data/raw/king-lowe-2008/1990*.txt data/raw/king-lowe-2008/1995*.txt data/raw/king-lowe-2008/2000*.txt data/raw/king-lowe-2008/levels*.txt data/raw/king-lowe-2008/names*.txt data/raw/king-lowe-2008/sectors*.txt
	Rscript $<	
	
data/variables-to-merge-ccode-idea3.csv: R/*-create-variables-to-merge-ccode-idea3.R data/idea-dissent-events.csv data/raw/where-idea-fixes.csv	
	Rscript $<
	
data/idea-counts.csv: R/*-fill-country-years-with-counts.R data/empty-country-years-to-fill.csv data/variables-to-merge-ccode-idea3.csv	data/idea-dissent-events.csv data/idea-all-events.csv
	Rscript $<

# ---------
# fit model
# ---------

latent-dissent.csv latent-dissent.dta: R/*-add-model-estimates.R src/binomial.stan data/idea-counts.csv
	Rscript $<
	
# -----------------
# evaluate measures
# -----------------	

figs/eta.png: R/*-plot-eta.R latent-dissent.csv
	Rscript $<
	
figs/cors.png: R/*-plot-cors.R latent-dissent.csv
	Rscript $<	

figs/fariss-test.png: R/test-fariss.R latent-dissent.csv data/farriss-scores.csv
	Rscript $<

figs/hj-test.png: R/test-hill-jones.R latent-dissent.csv data/hill-jones-2014-si.csv
	Rscript $<

figs/nordas-davenport-test.png figs/nordas-davenport-compare-measures.png: R/test-nordas-davenport.R latent-dissent.dta data/nordas-davenport-2013-replication.dta 
	Rscript $<

# ---------------
# clean directory
# ---------------

cleantests: 
	rm -f figs/eta.png
	rm -f figs/cors.png
	rm -f figs/fariss-test.png
	rm -f figs/hj-test.png
	rm -f figs/nordas-davenport-test.png 
	rm -f figs/nordas-davenport-compare-measures.png

cleanmodel: cleantests
	rm -f latent-dissent.csv 
	rm -f latent-dissent.dta

cleanALL: cleanmodel
	rm -r data/raw/king-lowe-2008
	rm -f data/murdie-bhasin-events.csv
	rm -f data/empty-country-years-to-fill.csv
	rm -f data/idea-dissent-events.csv
	rm -f data/idea-all-events.csv
	rm -f data/variables-to-merge-ccode-idea3.csv
	rm -f latent-dissent.csv 
	rm -f latent-dissent.dta
