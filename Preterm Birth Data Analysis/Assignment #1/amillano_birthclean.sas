***************************************************************;
* Program: Assignment 1										  *; 
* Date: 01252024											  *;	
* Programmers: Bryanda Amillano and Sushma Sadgun 			  *;
*															  *;
* Purpose: This program explores the birth certificate  	  *;
* data in preperation for creating a celan analysis           *;
* dataset for assignment 1.  		 						  *;
*															  *;
***************************************************************;

	/*step 2.3 library name for the path 
	to where your original data are stored*/;
	libname mydata "/home/u63742906"; 

*DATA STEP;
	/*step 2.4 create a temporary data set 
	called births in which you will make changes*/;
data births;
	set mydata.birthsamp;
	
	/*step 2.9 excluding obs not based 
	on 2003 birth certificate data*/;
		if revision = "A";
	
	/*step 2.10 (Question 6) number of obs that
	were not singleton births*/;	
		if dplural=1;
	
	/*step 2.13 recoding missing values to 
	SAS missings.*/;
		if cig_rec eq "U" then cig_rec=" ";
		if combgest eq 99 then combgest=.;
		if precare eq 99 then precare=.;
		if mbrace eq 99 then mbrace=.;
		if uprevis eq 99 then uprevis=.;
		if umhisp eq 9 then umhisp=.;

	/*step 2.15 recoding invalid values
	identified*/
		if combgest eq 98 then combgest=.;
		if mager eq 5 then mager=.;
		if mager eq 7 then mager=.;
		if mager eq 61 then mager=.;
		if mager eq 62 then mager=.;
		if mager eq 68 then mager=.;
		if mager eq	83 then mager=.;

	/*step 2.17 (Question 10) setting inconsistent 
	variables to missing*/;
		if precare = 0 and uprevis > 0 then do;
		precare = .;
		uprevis = .;
		end;
		if precare > 0 and uprevis = 0 then do;
		precare = .;
		uprevis = .;
		end;

	/*step 2.18 creating a new variable called precarew*/;
		precarew=ceil(((precare-1)*30.4+1)/7);

	/*step 2.19 setting precarew equal to missing when
	precare equals 0*/;
		if precare eq 0 then precarew=.;

	/*step 2.20 creating indicator variable to show when 
	there is a problem with the timing of prenatal care*/;
		if combgest=. or precare=. then probcare= .;
		else if 0 le precare le 9 and combgest ne . then probcare = 0;
		else if precarew > combgest then probcare= 1;
		
	/*step 2.21 label new variables (precarew & probcare) 
	to add to codebook*/;
		label probcare="Problem ith prenatal care timing"
		precarew="Number of weeks pregnant when entering prenatal care";
		
	/*step 2.23 creating new variable called birthcare to 
	ensure the max number of days that could occur between entry into
	prenatal care and delivery*/
		birthcare=(combgest - precarew)*7+7;
	
	/*labeling new variable as directed from previous questions 
	to place into codebook*/;
		label birthcare="Max number of days between entry into
	prenatal care and delivery";
	
	/*step 2.24 making sure variable was created correctly for crosstab
	in later proc freq step*/;
		if combgest=. or precarew=. then birthcare=.;
		
	/*step 2.26 code that sets probcare up to set contributing
	variables to missing*/;
		if probcare ne 1 and birthcare lt uprevis and birthcare ne . then probcare=2;
	
	/*step 2.28 write code that sets certain parameters regarding probcare*/;
		if probcare=2 then precare=. and precarew=. and combgest=. and uprevis=.;

	/*step 2.30, creating new variable to indicate
	eligibility for gestational age*/; 
		if combgest>20 then elg_ga=1;
		else if combgest<=20  and combgest ne . then elg_ga=0;
		else if combgest=. then elg_ga=.;

	/*labeling new variable as directed from previous questions 
	to place into codebook*/;
		label elg_ga="Indicator variable for eligibility based on gestational
		age";
	
	/*step 2.33, creating new variable that counts the number of
	variables with missing value for each obs*/;
		numiss=0;
       if combgest eq . then numiss=numiss+1;
       if mager eq . then numiss=numiss+1;
       if mbrace eq . then numiss=numiss+1;
       if precare eq . then numiss=numiss+1;
       if umhisp eq . then numiss=numiss+1;
       if uprevis eq . then numiss=numiss+1;
       if cig_rec eq " " then numiss=numiss+1;
       label numiss = "Number of missing variables";

	/*step 2.35, creating the outcome variable
	called preterm*/;
		if combgest ge 37 then preterm=0;
		if 21 le combgest le 36 then preterm=1;
		else if combgest < 21 then preterm =.;
	
	/*labeling new variable as directed from previous questions 
	to place into codebook*/;
		label preterm="Whether or not born preterm (outcome)";
		
	/*step 2.38 creating new variable for exposure of early entry
	into prenatal care*/;
		if 1 le precare < 5 then earlycare=1;
		else if precare=0 or precare>=5 then earlycare=0;
		else if precare =. then earlycare =.;
		label precare = "Whether or not entered prenatal care early exposure";

	/*step 2.41 creating new variable that is the numeric version of smoking
	cigarettes called smoke*/;
		if cig_rec= "Y" then smoke=1;
		else if cig_rec= "N" then smoke=0;
		else if cig_rec=" " then smoke=.;
		label smoke = "Smoking habits numeric"
		
	/*step 2.43E creating new variable that combines two existing variables: multiracial 
	and hispanic/latina (umhisp)*/;
		if mbrace = . and 1 le umhisp le 5 then mraceeth = 6;
		else if 1 le mbrace le 14 and 1 le umhisp le 5 then mraceeth=6;
		else if mbrace = . and umhisp=0 or umhisp=. then mraceeth = .;
		else if 21 le mbrace le 24 then mraceeth = 7;
		else if 11 le mbrace le 14 and umhisp=. then mraceeth = .;
		else if mbrace = 1 and umhisp=0 then mraceeth = 1;
		else if mbrace = 2 and umhisp=0 then mraceeth = 2;
		else if mbrace = 3 and umhisp=0 then mraceeth =3;
		else if 4 le mbrace le 10 and umhisp=0 then mraceeth=4;
		else if 11 le mbrace le 14 and umhisp=0 then mraceeth=5;
		label mraceeth = "Combined other ethnicity and race";
	
	/*step 2.45 creating new dichotomous variable*/;
		if 1 le umhisp le 5 then mhisp = 1;
		else if umhisp = 0 then mhisp = 0;
		label mhsip = "Dichotomous variable mother hispanic"
		
	/*step 2.48 creating a 5-year maternal age group (categorical variable
	from continuous variable)*/;
		if mager eq . then mage5yr=.;
   		else if mager ge 12 and mager le 14 then mage5yr=1;
   		else if mager ge 15 and mager le 19 then mage5yr=2;
   		else if mager ge 20 and mager le 24 then mage5yr=3;
   		else if mager ge 25 and mager le 29 then mage5yr=4;
   		else if mager ge 30 and mager le 34 then mage5yr=5;
   		else if mager ge 35 and mager le 39 then mage5yr=6;
   		else if mager ge 40 and mager le 44 then mage5yr=7;
   		else if mager ge 45 and mager le 50 then mage5yr=8;

run;	

*PROC STEPS	
	*step 2.6 run proc contents to view some observations;
	*overview of the data;
	*proc contents data=births;
		*run;

	/*step 2.7 sense of data through print
	of observations and specifying number
	of observations*/;
	/*proc print data= births (obs=20);
		var combgest studyid mbrace;
	run;*/
	
	/*step 2.8 (Question 5) frequency table
	to show obs recorded that did not use
	2003 birth certificate*/;
	/*proc freq data=births;
		tables revision;
	run;*/

	/*part of 2.10, frequency table showing obs not singleton births*/;
	/*proc freq data=births;
		tables dplural;
	run;*/

	/*part of step 2.13 frequency table showing recoded missing and invalid values*/;
	/*proc freq data=births;
		tables cig_rec;
		tables combgest;
		tables precare;
		tables mbrace;
		tables uprevis;
		tables umhisp;
		tables mager;
	run;*/

	/*step 2.16 (Question 9) frequency table showing
	inconsistent obs related to mother's race*/;
	/*proc freq data=births;
		tables mbrace * mracerec;
	run;*/

	/*frequency table comparing when prenatal care 
	began and number of prenatal visits*/;
	/*proc freq data=births;
		tables precare/list;
	run;*/

	/*checking to ensure missing variables are removed 
	and comparing timing of entry into prenatal care to 
	gestational age*/;
	/*proc freq data=births;
		tables precare * precarew;
		tables precarew * combgest;
	run;*/

	/*step 2.22 running a crosstab of probcare, precarew, 
	combgest, and precare to practice checking code 
	when creating new variables*/;
	/*proc freq data=births;
		tables probcare * precarew * combgest * precare/list;
	run;*/

	/*step 2.24 running a crosstab of birthcare, combgest, precarew*/
	/*proc freq data=births;
		tables birthcare * combgest * precarew/list;
	run;*/
	
	/*step 2.25 crosstab of birthcare and uprevis and making restrictions
	using a where statement*/;
	/*proc freq data=births;
		where birthcare lt uprevis;
		tables birthcare * uprevis/list;
	run;*/
	
	/*step 2.27 crosstab to ensure probcare is coded correctly*/;
	/*proc freq data=births;
		tables birthcare * uprevis * probcare/list;
	run;*/
	
	/*step 2.29 distribution of counts for probcare*/;
	/*proc freq data=births;
		tables probcare/list;
	run;*/

	/*step 2.31 crosstab between eligible births and gestational age*/;
	/*proc freq data=births;
		tables elg_ga * combgest/list;*/
	
	/*step 2.32 distribution of counts for elg_ga
		tables elg_ga/list;
	run;*/
	
	/*step 2.34 looking at counts for numiss*/;
	/*proc freq data=births;
		tables numiss/list;
	run;*/
	
	/*step 2.36 crosstab to check new variable preterm and gestational age*/;
	/*proc freq data=births;
		tables preterm * combgest/list;
	run;*/
	
	/*step 2.37 distribution counts for preterm*/;
	/*proc freq data=births;
		tables preterm/list;
	run;*/
	
	/*step 2.39 crosstab to check earlycare variable*/;
	/*proc freq data=births;
		tables preterm * earlycare/list;
	run;*/
	
	/*step 2.40 distribution counts for earlycare*/;
	/*proc freq data=births;
		tables earlycare/missing;
	run;*/
	
	/*step 2.42 crosstab of smoke variable againes cig_rec*/;
	/*proc freq data=births;
		tables smoke * cig_rec/list;
	run;
	
	/*step 2.43 crosstab of mraceeth, mbrace, umhisp*/;
	/*proc freq data=births;
		tables mraceeth * mbrace *umhisp/list;
	*step 2.44 distribution counts of mraceeth;
		tables mraceeth/list;
	run;*/

	/*step 2.46 crosstab to check mhisp coding*/;
	/*proc freq data=births;
		tables umhisp * mhisp/list;
	*step 2.47 distribution counts for mhisp;
		tables mhisp/list;
	run;*/
	
	/*step 2.49 crosstab to check coding for mage5yr*/;
	/*proc freq data=births;
		tables mager * mage5yr/list;
	run;


/*saving data method is done within the data step
and we were allowed to have two datasteps for this assignment: 1 
with cleaning code and 2 for saving data*/;
data mydata.birthsclean;
	*second step: existing dataset;
	set births;
	run;

*Birthfin (Analysis Data), dropped observations missing preterm or earlycare;
*second data step to create a second dataset for assignment 2;
data mydata.birthfin;
	set mydata.birthsclean;
	*Step 1 exclude obs missing preterm;
	if preterm ne .;
	*Step 1 exclude obs missing earlycare;
	if earlycare ne .;
	run;
	
data mydata.birthfin; *save a copy;
	set mydata.birthsclean; *second step refers to existing dataset;
	run;



	
	
	

















	