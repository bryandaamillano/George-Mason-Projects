***************************************************************;
* Program: Cleaning Survey Data								  *; 
* Date: 05272024											  *;	
* Programmers: Bryanda Amillano 			           	      *;
*															  *;
* Purpose: The purpose is the clean the Deer survey data and  *; 
* create tables for multiple questions to look at the 		  *;
* frequency of answers for each question.	 				  *;		  
*															  *;
***************************************************************;

	*Defining a library reference for the path to where your original data are stored;
libname mydata "/home/u63742906";

	*Creating a working dataset to make all changes while keeping the original dataset
	saved;
data dmvdeer2;
	set mydata.dmvdeer1;
	*Excluding observations that are considered practice survey responses;
	if practice ne 1;
	*Excluding observations that are 0 in analysiskeep;
	if AnalysisKeep ne 0;
	
	*Creating new categories for race: non-hispanic white, non-hispanic black, hispanic, and other);
	*Labeling Hispanic from Q43 in survey;
	if Q43_hispanic = 1 then Hispanic = "Yes";
    else if Q43_hispanic = 2 then Hispanic = "No";
    else Hispanic =.;
	
	*Recoding Q43, 44, and 45 to create a new variables indicating race;
	if Q44_primary_race = 7 and Q45_white_race = 1 then Race = "NH White";
	else if Q44_primary_race = 1 then Race = "NH White"; /*Mark as Non-Hispanic White if Q44 is 'White'*/
    else if Q43_hispanic=1 then Race = "Hispanic"; /*Mark as Hispanic if Q44 is 'Hispanic only'*/
    else if Q44_primary_race = 2 then Race = "NH Black"; /*Mark as Non-Hispanic Black if Q44 is 'Black or African American'*/
    else if Q44_primary_race >2 then Race = "Other";
    else if Q44_primary_race=. then Race="Other";
    *Create dummy variables for Race for when I run the logistic models I 
    have the non-generic ouput with "vs";
    if Race = "NH Black" then Race_NHBlack = 1; else Race_NHBlack = 0;
    if Race = "Hispanic" then Race_Hispanic = 1; else Race_Hispanic = 0;
    if Race = "Other" then Race_Other = 1; else Race_Other = 0;
   
    *Creating different age groups from our survey data;
    if Q42_age = . then do;
        AgeCat = "Missing";
    end;
    else if Q42_age < 40 then do;
        AgeCat = 1;
        AgeCat_Label = "Young Adult";
    end;
    else if Q42_age >= 40 and Q42_age < 60 then do;
        AgeCat = 2;
        AgeCat_Label = "MA Adult";
    end;
    else if Q42_age >= 60 then do;
        AgeCat = 3;
        AgeCat_Label = "Older Adult";
    end;
    *Create dummy variables for AgeCat;
    if AgeCat = 2 then AgeCat_2 = 1; else AgeCat_2 = 0;
    if AgeCat = 3 then AgeCat_3 = 1; else AgeCat_3 = 0;
    
    *Creating three different variables for income to use during analysis;
    *Create Income1 with specified ranges (Dr. Roess's Income2 variable);
    if Q47_household_income in (1,2) then Income1 = 1; /* <50,000 */
    else if Q47_household_income = 3 then Income1 = 2; /* 50,000-74,999 */
    else if Q47_household_income = 4 then Income1 = 3; /* 75,000-99,999 */
    else if Q47_household_income in (5,6) then Income1 = 4; /* >=100,000 */
   	else Income1=.;
   	*Create dummy variables for Income1;
    if Income1 = 2 then Income1_2 = 1; else Income1_2 = 0;
    if Income1 = 3 then Income1_3 = 1; else Income1_3 = 0;
    if Income1 = 4 then Income1_4 = 1; else Income1_4 = 0;
   	
	*Create Income2 with specified ranges (Dr. Roess's Income1);
	if Q47_household_income in (1,2,3) then Income2 = 1; /* <75,000 */
    else if Q47_household_income = 4 then Income2 = 2; /* 75,000-99,999*/
    else if Q47_household_income in (5,6) then Income2 = 3; /* >=100,000*/
    else Income2=.; /* Handle 'Prefer not to answer' or missing values*/
 	*Create dummy variables for Income2;
    if Income2 = 1 then Income2_1 = 1; else Income2_1 = 0;
    if Income2 = 2 then Income2_2 = 1; else Income2_2 = 0;
    if Income2 = 3 then Income2_3 = 1; else Income2_3 = 0;
 
	*Create Income3 as a dichotomous variable (Dr. Roess's Income3 variable);
    if Q47_household_income in (1,2,3) then Income3 = 1; /* <75,000 */
    else if Q47_household_income in (4,5,6) then Income3 = 2; /* >=75,000 */
    else Income3=.; /* Handle 'Prefer not to answer' or missing values*/
   	*Create dummy variables for Income3;
    if Income3 = 1 then Income3_1 = 1; else Income3_1 = 0;
    if Income3 = 2 then Income3_2 = 1; else Income3_2 = 0;
   
	*Creating two different variables for education level;
	*Create EduCat1 with specified ranges;
    if Q46_degree_level = 1 then EduCat1 = 1; /* Less than high school */
    else if Q46_degree_level = 2 then EduCat1 = 2; /* High school graduate or equivalent */
    else if Q46_degree_level = 3 then EduCat1 = 3; /* Some college */
    else if Q46_degree_level = 4 then EduCat1 = 4; /* Bachelor's degree */
    else if Q46_degree_level = 5 then EduCat1 = 5; /* Graduate degree */
    else Educate1 = .; /* Handle 'Prefer not to answer' or missing values */
	*Create dummy variables for EduCat1;
    if EduCat1 = 2 then EduCat1_2 = 1; else EduCat1_2 = 0;
    if EduCat1 = 3 then EduCat1_3 = 1; else EduCat1_3 = 0;
    if EduCat1 = 4 then EduCat1_4 = 1; else EduCat1_4 = 0;
    if EduCat1 = 5 then EduCat1_5 = 1; else EduCat1_5 = 0;

	*Create EduCat2 with specified ranges;
    if Q46_degree_level in (1, 2) then EduCat2 = 1; /* High school degree or less */
    else if Q46_degree_level in (3, 4, 5) then EduCat2 = 2; /* Some college or more */
    else Educate2 = .; /* Handle 'Prefer not to answer' or missing values */
	*Create dummy variables for EduCat2;
    if EduCat2 = 2 then EduCat2_2 = 1; else EduCat2_2 = 0;
    
   	*Create EduCat3 with specified ranges;
   	if Q46_degree_level = . then do;
        EduCat3 = "Missing";
    end;
    else if Q46_degree_level < 3 then do;
        EduCat3 = 1;
        EduCat3_Label = "HS Degree or Less";
    end;
    else if Q46_degree_level in (3,4) then do;
        EduCat3 = 2;
        EduCat3_Label = "Some College or BS";
    end;
    else if Q46_degree_level = 5 then do;
        EduCat3 = 3;
        EduCat3_Label = "Grad School";
    end;
    *Create dummy variables for EduCat3;
    if EduCat3 = 2 then EduCat3_2 = 1; else EduCat3_2 = 0;
    if EduCat3 = 3 then EduCat3_3 = 1; else EduCat3_3 = 0;

    
    *Residence have yard 
    (comment from Dr. Roess: the majority of people who has a yard(space) or 
    own property has seen evidence of deer);
    if Q11_residence=2 then ResidenceHasYard=0;
    else if Q11_residence=1 then ResidenceHasYard=1;
    else ResidenceHasYard=.;
    *Seen signs of deer on property;
    if Q12_signs_of_deer=2 then SeenDeerSignsProperty=0;
    else if Q12_signs_of_deer=1 then SeenDeerSignsProperty=1;
    else SeenDeerSignsProperty=.;
    
    *Q15 actively feeding deer (generate variable FeedDeer)--> 56% of urban folks feed deer;
    if Q15_no=1 then FeedDeer=0;
    if Q15_yes_leavefood=1 then FeedDeer=1;
   	if Q15_yes_feed_outofhands=1 then FeedDeer=1;
    if Q15_Yes_anotherway=1 then FeedDeer=1;
    *Those that feed deer out of their hands;
    if Q15_yes_feed_outofhands=1 then FeedDeerHand=1;
    if Q15_yes_feed_outofhands=. then FeedDeerHand=0;
   	*Those that leave food out for deer;
    if Q15_yes_leavefood=1 then FeedDeerLeaveFood=1;
    if Q15_yes_leavefood=. then FeedDeerLeaveFood=0;
  
	*Relabeling tick question variables to be able to place in the logistic models;
    if Q34_had_ticks=1 then TicksMe=1;
    if Q34_had_ticks=. then TicksMe=0;
	if Q34_family_hadticks=1 then TicksFamily=1;
	if Q34_family_hadticks=. then TicksFamily=0;
	if TicksMe=1 or TicksFamily=1 then TicksMeFamily=1;
	if TicksMe=0 and TicksFamily=. then TicksMeFamily=0;
	if Q34_dog_hadticks=1 then TicksDogs=1;
	if Q34_dog_hadticks=. then TicksDogs=0;
	if Q35_other_petsticks=1 then TicksPets=1;
	if Q35_other_petsticks=.  then TicksPets=0;
	if TicksDogs=1 or TicksPets=1 then TicksDogPets=1;
	if TicksDogs=0 and TicksPets=0 then TicksDogPets=0;
	if Q34_seen_yard=1 then TicksYard=1;
    if Q34_seen_yard=. then TicksYard=0;
	if Q34_seen_parks=1 then TicksPark=1;
	if Q34_seen_parks=. then TicksPark=0;
	if TicksYard=1 or TicksPark=1 then TicksYardPark=1;
	if TicksYard=0 and TicksPark=0 then TicksYardPark=0;
	if Q34_increase_ticksyard=1 then TicksIncreaseYard=1;
	if Q34_increase_ticksyard=. then TicksIncreaseYard=0;
	if Q34_increase_ticksparks=1 then TicksIncreasePark=1;
	if Q34_increase_ticksparks=. then TicksIncreasePark=0;
	if TicksIncreaseYard=1 or TicksIncreasePark=1 then TicksIncreaseParksYard=1;
	if TicksIncreaseYard=0 and TicksIncreasePark=0 then TicksIncreaseParksYard=0;
	
	*Combining variables for do you enjoy seeing deer survey question to place into model;
	if Q19_enjoy_seeing_deer=1 then enjoyseedeer=1;
	if Q19_enjoy_seeing_deer=2 then enjoyseedeer=0;
	
	*Combining variables for conflict between neighbors for presence of deer survey questions;
	if Q20_presence_conflict=1 then ConflictNeighbor=1;
	if Q20_presence_conflict=2 then ConflictNeighbor=0;
	if Q21_conflict_feeding=1 then ConflictNeighborFeed=1;
	if Q21_conflict_feeding=. then ConflictNeighborFeed=0;
	
	*Aggressive behavior of deer; 
	if Q28_aggresive_deer=2 then AggressiveDeerExp=0;
	else if Q28_aggresive_deer=1 then AggressiveDeerExp=1;
	else AggressiveDeerExp=.;
	
	*Aggressive towards to pets;
	AggressiveDeerToPets=.;
	if Q29_aggresive_behavior=2 then AggressiveDeerToPets=1;
	else if Q29_aggresive_behavior ^= 2 and AggressiveDeerExp=1 then AggressiveDeerToPets=0;
	else AggressiveDeerToPets=.;
	
	*Aggressive deer to people;
	if Q29_aggresive_behavior=1 then AggressiveDeerToPeople=1; 	
	else if  Q29_aggresive_behavior ^= 1 and AggressiveDeerExp=1 then AggressiveDeerToPeople=0;
	else AggressiveDeerToPeople=.;
	
	*Aggressive deer to pets and people comment response;
	if ResponseID="R_3lCx4IpqRD4vUsN" then AggressiveDeerToPets=1;
	if ResponseID="R_3lCx4IpqRD4vUsN" then AggressiveDeerToPeople=1;
	
	*Combining the deer hunting survey question;
	if Q30_deer_hunting=1 then DeerHunting=1;
	if Q30_deer_hunting=2 then DeerHunting=0;
	
	*Combining variables for amount spent on deer question, ranges: <500, <1000 >499, >999;
	if Q16_deer_damage = 2 then AmountSpentProp = 0; 
    else if Q16_1_TEXT < 500 and Q16_deer_damage = 1 then AmountSpentProp = 1;
    else if 500 <= Q16_1_TEXT < 1000 and Q16_deer_damage = 1 then AmountSpentProp = 2;
    else if Q16_1_TEXT >= 1000 and Q16_deer_damage = 1 then AmountSpentProp = 3; 
    else AmountSpentProp = .;
    
    *Combining variables for whether or not you own a dog (bivariate);
  	if QQ23_own_dog=3 then DogCareBi=0;
  	if QQ23_own_dog=1 then DogCareBi=1;
  	if QQ23_own_dog=2 then DogCareBi=1;

  	*Combining variables for whether or not you own a dog (tri);
  	if QQ23_own_dog = 3 then do;
        DogCareTri = 0;
        DogCareTri_Label = "Don't own or care for dog";
    end;
    else if QQ23_own_dog = 1 then do;
        DogCareTri = 1;
        DogCareTri_Label = "Own dog";
    end;
    else if QQ23_own_dog = 2 then do;
        DogCareTri = 2;
        DogCareTri_Label = "Care for dog don't own";
    end;
    *Create dummy variables for DogCareTri;
    if DogCareTri = 1 then DogCareTri_1 = 1; else DogCareTri_1 = 0;
    if DogCareTri = 2 then DogCareTri_2 = 1; else DogCareTri_2 = 0;
    /* Note: DogCareTri = 0 (Don't own or care for dog) will be the reference category */

    *Variables for concern of exposure to ticks from deer;
    if Q35_ticks_concer = 1 then ConcernTicksExp = 0;
 	if Q35_ticks_concer = 2 then ConcernTicksExp = 0;
    if Q35_ticks_concer = 3 then ConcernTicksExp = 1;
    if Q35_ticks_concer = 4 then ConcernTicksExp = 1;
        
    *Variables for concern of exposure to disease from ticks;
    if Q36_disease = 1 then ConcernDisFromDeer = 0;
 	if Q36_disease = 2 then ConcernDisFromDeer = 0;
    if Q36_disease = 3 then ConcernDisFromDeer = 1;
    if Q36_disease = 4 then ConcernDisFromDeer = 1;
    
    *Variables for both: ConcernDisTicks4, something 4-tiered, we will also treat the original variables
    Q35 and Q36 as continuous variables;
    if ConcernTicksExp=0 and ConcernDisFromDeer=0 then ConcernDisTicks4=0;
    if ConcernTicksExp=1 and ConcernDisFromDeer=0 then ConcernDisTicks4=1;
    if ConcernTicksExp=0 and ConcernDisFromDeer=1 then ConcernDisTicks4=2;
    if ConcernTicksExp=1 and ConcernDisFromDeer=1 then ConcernDisTicks4=3;
    *Create dummy variables for concern for both disease and ticks;
    if ConcernDisTicks4 = 1 then ConcernDisTicks4_1 = 1; else ConcernDisTicks4_1 = 0;
    if ConcernDisTicks4 = 2 then ConcernDisTicks4_2 = 1; else ConcernDisTicks4_2 = 0;
    if ConcernDisTicks4 = 3 then ConcernDisTicks4_3 = 1; else ConcernDisTicks4_3 = 0;
    
   	*Making it binary;
    if ConcernDisFromDeer=0 and ConcernTicksExp=0 then ConcernDisTicksBi=0;
    if ConcernDisFromDeer=1 or ConcernTicksExp=1 then ConcernDisTicksBi=1;
        
run;

    *Showing the demographics of the study population;
proc freq data=dmvdeer2;
	tables AgeCat/missprint;
	tables Race/missprint;
	tables Income1/missprint;
	tables Income2/missprint;
	tables Income3/missprint;
	tables EduCat1/missprint;
	tables EduCat2/missprint;
	tables EduCat3;
run; 
	
	*Frquency tables for each of the survey questions that are 
	not considered screening questions;
proc freq data=dmvdeer2;
	tables Q9_How_many_years;
	tables Q10_commute_car;
	tables Q10_commute_metro_bus_walk;	
	tables Q10_walking_pets;
	tables Q10_children_playing;	
	tables Q10_recreation;	
	tables Q10_ridingbike;	
	tables Q10_other;	
	tables Q11_residence;
	tables Q12_signs_of_deer;	
	tables Q13_freq_of_deer_lastyear;
	tables Q14_nuisance;		
	tables Q15_yes_leavefood;
	tables Q15_yes_feed_outofhands;
	tables Q15_Yes_anotherway;
	tables Q15_no;
	tables Q16_deer_damage;	
	tables Q16_1_TEXT; 	
	tables Q19_enjoy_seeing_deer;
	tables Q20_presence_conflict;	
	tables Q21_conflict_fencing;
	tables Q21_conflict_feeding;
	tables Q21_conflict_whatshouldbedone;
	tables Q21_other;
	tables Q22_early_morning;
	tables Q22_middle_day;
	tables Q22_late_afternoon;
	tables Q22_late_evening;
	tables QQ23_own_dog;
	tables Q24_walk_dogs;
	tables Q25_barks;	
	tables Q25_chases_deer;
	tables Q25_becomes_agitated;
	tables Q25_approachesdeer;
	tables Q25_not_interact;
	tables Q25_not_see_deer;
	tables Q25_other;
	tables Q25_7_TEXT; 
	tables Q26_incident_with_deer_; 
	tables Q27_incident;
	tables Q27_3_TEXT; 	
	tables Q28_aggresive_deer;
	tables Q29_aggresive_behavior; 	
	tables Q29_3_TEXT; 
	tables Q30_deer_hunting;	
	tables Q31_concern_aggresive_deer; 
	tables Q32_health_of_deer; 
	tables Q33_talk_to_neighbors;
	tables Q34_had_ticks;
	tables Q34_family_hadticks;
	tables Q34_dog_hadticks;
	tables Q35_other_petsticks;
	tables Q34_seen_yard;
	tables Q34_seen_parks;
	tables Q34_increase_ticksyard;
	tables Q34_increase_ticksparks;
	tables Q34_other;
	tables Q34_9_TEXT;
	tables Q34_no_ticks;
	tables Q35_ticks_concer;
	tables Q36_disease;
	tables Q37_deer_pop_size;
	tables Q38_comments;
	tables Q39_living_environment;
	tables Q40_current_household;
	tables Q41_political_standing;
run;

	*Frequency tables of new variables from the tick question;
proc freq data=dmvdeer2;
	tables ticksmefamily;
	tables ticksme * ticksfamily;
	tables tickspets * ticksdogs;
	tables ticksdogpets;
	tables ticksyard * tickspark;
	tables ticksyardpark;
	tables ticksincreaseyard * ticksincreasepark;
	tables ticksincreaseparksyard;
	tables Q35_ticks_concer * Q36_disease;
run;

	*Frequency tables of other variables we want to look at in our models;
proc freq data=dmvdeer2;
	tables enjoyseedeer;
	tables ConflictNeighbor; 
	tables ConflictNeighborFeed;
	tables DeerHunting;
	tables AmountSpentProp;
	tables DogCareBi;
	tables DogCareTri;
	tables ConcernDisFromDeer * ConcernTicksExp;
	tables Q36_disease;
	tables Q35_ticks_concer;
	tables AggressiveDeerExp;
	tables AggressiveDeerToPets;
	tables AggressiveDeerToPeople;
	tables ResidenceHasYard;
	tables SeenDeerSignsProperty;
	tables SeenDeerSignsProperty * ResidenceHasYard;
	tables FeedDeer;
	tables FeedDeerHand;
	tables FeedDeerLeaveFood;
	tables ConcernDisFromDeer;
	tables ConcernTicksExp;
	tables ConcernDisTicks4;
	tables ConcernDisTicksBi;
run;

*NOTES from June 7 meeting;
*What you did with the dem. variables, do with the amount spent on deer question (DONE);
*potentially combine variables for amount spent on deer question, ranges: <500, <1000 >499, >999 
--> 121,26,16,19 should be what you get (DONE)
*Make crosstab freq table with zipcode and amount spent on deer variables together;
*Because we are doing logistic regression, we want to make the multiple question variables as 0 and 1
So, do this following the recorded meeting with the experience with tick questions and name 
them just like Dr. Roess did (DONE)
Also do this for the conflict feeding and what is the specific conflict, will be in recorded meeting (DONE);
	
*Assoc to explore
conflict over feeding and if they feed deer

*Models to build if we want outcome to be: 
	1 who enjoys seeing deer then add SES, how much spent, deer hunting
	*Fit a log-risk regression model to find estimates for if you enjoy seeing deer and include race, age, income,
	education, amount spent on deer, and deer hunting;
proc logistic data=dmvdeer2 descending;
    class Race AgeCat Income3 Educate2 AmountSpentProp / param=ref ref=first;
    model enjoyseedeer = Race AgeCat Income3 Educate2 AmountSpentProp DeerHunting / expb;
run;
proc logistic data=dmvdeer2 descending;
    class Race AgeCat Income3 Educate1 AmountSpentProp / param=ref ref=first;
    model enjoyseedeer = Race AgeCat Income3 Educate1 AmountSpentProp DeerHunting / expb;
run;
proc logistic data=dmvdeer2 descending;
    class Race AgeCat Income1 Educate1 / param=ref ref=first;
    model enjoyseedeer = Race AgeCat Income1 Educate1 DeerHunting / expb;
run;

proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model enjoyseedeer = Race AgeCat Income1 EduCat3 DeerHunting / expb;
run; 

*The only thing that stands out for race ethnicity is enjoy seeing deer,  I would think that maybe Hispanic individuals 
have experienced aggressive deer behavior more often in this sample, which is why they don't enjoy seeing deer;
*People who have a yard are more likely to say they enjoy it, hispanics, older people, grad school or higher are less likely;
*This is a pretty good model;
*THIS IS THE MODEL MOST LIKELY TO BE USED --> ADD THE CONCERNDISTICKS4 VARIABLE;
proc logistic data=dmvdeer2 descending;
    model enjoyseedeer = Race_NHBlack Race_Hispanic Race_Other AgeCat_2 AgeCat_3 Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 DeerHunting DogCareTri_1 DogCareTri_2 ResidenceHasYard / expb;
run;
*Seeing the signs of deer does not seem to matter, but the Hispanic variable is still standing out --> we will not be using
model becuase seeing signs of deer variable is too highly correlated anyway;
proc logistic data=dmvdeer2 descending;
    model enjoyseedeer = Race_NHBlack Race_Hispanic Race_Other AgeCat_2 AgeCat_3 Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 DeerHunting DogCareTri_1 DogCareTri_2 ResidenceHasYard SeenDeerSignsProperty / expb;
run;
*Adding less detailed income variable to see if the model improves, this model ends up being the same, 
but for consistency in reporting we might want to be consistent;
proc logistic data=dmvdeer2 descending;
    model enjoyseedeer = Race_NHBlack Race_Hispanic Race_Other AgeCat_2 AgeCat_3 Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareTri_1 DogCareTri_2 ResidenceHasYard / expb;
run;
*For consistency, we are using the continuous variable for age as mentioned above --> this model shows
as they get older, their chances of enjoying seeing deer decreases and people who have a yard enjoy seeing deer, there
could also be something about people being hardwired to be around animals (mental health component);
proc logistic data=dmvdeer2 descending;
    model enjoyseedeer = Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareTri_1 DogCareTri_2 ResidenceHasYard / expb;
run;
*This is the code Dr. Roess is using while we are creating the table to organize the results;
proc logistic data=dmvdeer2 descending;
    model enjoyseedeer = Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;	
	
	*2 conflict with neighbors SES, how much spent, enjoy deer;
proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model ConflictNeighbor = enjoyseedeer Race AgeCat Income1 EduCat3 DeerHunting DogCareTri / expb;
run; 

proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model ConflictNeighbor = enjoyseedeer Race AgeCat Income1 EduCat3 DeerHunting DogCareBi / expb;
run; 

proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model ConflictNeighborFeed = enjoyseedeer Race AgeCat Income1 EduCat3 DeerHunting DogCareTri / expb;
run; 
*If you have a yard, you are not more likely to have conflict with your neighbors, the dog owners are more likely
the only thing that stands out is if you are a dog owner --> this goes the same for the model that used the AgeCat variable,
the model ended up being similar;
proc logistic data=dmvdeer2 descending;
	model ConflictNeighborFeed = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run; 


	
	
	*3 tick outcome as above and also enjoy deer; 
proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model TicksMeFamily = enjoyseedeer Race AgeCat Income1 EduCat3 DeerHunting DogCareBi / expb;
run;

proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model TicksFamily = enjoyseedeer Race AgeCat Income1 EduCat3 DeerHunting DogCareBi / expb;
run;

proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model TicksPets = enjoyseedeer Race AgeCat Income1 EduCat3 DeerHunting DogCareBi / expb;
run;

proc logistic data=dmvdeer2 descending;
	model TicksDogs = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 DeerHunting / expb;
run;

proc logistic data=dmvdeer2 descending;
	where DogCareBi=1;
	model ticksDogs = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 DeerHunting / expb;
run;

*Adding residence having a yard makes a sparce model, but without that variable as you get older
you're more likely to be worried, wealthier people are also more worried
That is telling us we have a small cell somewhere, having such a detailed income variable might not work out;
proc logistic data=dmvdeer2 descending;
	model ticksMe = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run; 
*Adding this lower range income variable made a more usable model compared to the sparce one above;
proc logistic data=dmvdeer2 descending;
	model ticksMe = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi / expb;
run;

*Changing the Income variable to see if it's a better model,;
proc logistic data=dmvdeer2 descending;
	model TicksMe = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*Looking at ticks on family members, high income and owning a dog are significant; 
proc logistic data=dmvdeer2 descending;
	model TicksFamily = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*Looking at ticks on pets, this models shows you are worried about your pet getting ticks if
you own a dog, which is what we observed in the concern for diseases model #5;
proc logistic data=dmvdeer2 descending;
	model TicksPets = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;


	
	
	*4 aggressive deer behavior; 
proc logistic data=dmvdeer2 descending;
	model AggressiveDeerExp = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 DeerHunting DogCareBi / expb;
run;	
	*Checking correlation between deer hunting and observing aggressive deer behavior;
proc freq data=dmvdeer2;
	tables DeerHunting * AggressiveDeerExp / chisq;
run; 

proc logistic data=dmvdeer2 descending;
	model AggressiveDeerExp = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 DogCareBi / expb;
run;
	
proc logistic data=dmvdeer2 descending;
	model AggressiveDeerExp = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income1_2 Income1_3 
    Income1_4 EduCat3_2 EduCat3_3 / expb;
run;
	
	
	
	*5 ticks on themselves;
proc logistic data=dmvdeer2 descending;
	class Race Q42_age Income1 EduCat3 / param=ref ref=first;
	model ConcernDisFromDeer = enjoyseedeer Race Q42_age Income1 EduCat3 DeerHunting DogCareTri / expb;
run;

proc logistic data=dmvdeer2 descending;
	class Race AgeCat Income1 EduCat3 / param=ref ref=first;
	model ConcernTicksExp = enjoyseedeer Race AgeCat Income1 EduCat3 DeerHunting DogCareTri / expb;
run;

*Higher income are borderline less likely to be concerned of diseases from deer. People who care for dogs, have a 
residence with a yard are more concerned;
proc logistic data=dmvdeer2 descending;
	model ConcernDisFromDeer = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*Looking at the model without Residence yard --> not that much better from the model above;
proc logistic data=dmvdeer2 descending;
	model ConcernDisFromDeer = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi / expb;
run;
*People who have a dog are more concerned over exposure to ticks from deer;
proc logistic data=dmvdeer2 descending;
	model ConcernTicksExp = enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
	
	
	
	
	*6 who is feeding deer;
*This is a really good model, who is feeding deer? people who enjoy seeing deer, younger, lower income, and people
who have a yard whether or not they are concered about ticks or having dogs, doesn't matter;
proc logistic data=dmvdeer2 descending;
	model FeedDeer = ConcernTicksExp enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;

*Same thing as above model, in general feeding deer, there is no concern of diseases from deer, but if we look at models below within the 
subgroups of feeding deer there is a difference;
proc logistic data=dmvdeer2 descending;
	model FeedDeer = ConcernDisFromDeer enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;

*Who is feeding deer from their hands? people who are less wealthy. Should we restrict to people who feed deer?,
Why would we do this model? Among those who feed deer, is there a difference among this subgroup?, this is interesting but maybe
the model could just focus on who is feeding deer;
proc logistic data=dmvdeer2 descending;
	where FeedDeer=1;
	model FeedDeerHand = ConcernTicksExp enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;	
*Of the people who feed deer, there is a subset of those who is who is leaving food out for deer (130)? Those are
who enjoy seeing deer, people concerned about ticks, younger people slightly higher income, deer hunters;
*Among those who feed deer, there is a group who are concerned about ticks and will leave food out for deer and then the group
not concerend about ticks that will feed them with their hands;
*This might be an idea, if we want to encourage people to not touch deer, we need to make them concerned about ticks, public health
campaign to increase awareness about ticks and maybe that will have an impact of peoples' behaviors towards deer (add to discussion);
proc logistic data=dmvdeer2 descending;
	where FeedDeer=1;
	model FeedDeerLeaveFood = ConcernTicksExp enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*The ticks drop out, if concerned about disease from deer, they are more likely to leave food out, disease is scarier than ticks
for these people, and they are correlated because when we add one the other drops out;
proc logistic data=dmvdeer2 descending;
	where FeedDeer=1;
	model FeedDeerLeaveFood = ConcernTicksExp ConcernDisFromDeer enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;

*Concern about disease or ticks-- is one more important-- can PH communications impact these feeding behaviors?;
*If we keep the concern disease from deer continuous, it is not associated with the outcome;
proc logistic data=dmvdeer2 descending;
	model FeedDeer = Q36_disease enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*If we do the same for concern over ticks,;
proc logistic data=dmvdeer2 descending;
	model FeedDeer = Q35_ticks_concer enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*If we do the binary ticks--> not correlated with outcome;
proc logistic data=dmvdeer2 descending;
	model FeedDeer = ConcernDisTicksBi enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*Concern about disease and/or ticks is not indicative of whether or not someone is going to feed deer, but among those who decided 
they are going to feed deer is a different story;
proc logistic data=dmvdeer2 descending;
	model FeedDeer = ConcernDisTicks4_1 ConcernDisTicks4_2 ConcernDisTicks4_3 enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;

*If we combine whether they are worried about one or the other it's significant, 
you are more likely to leave food out if you enjoy seeing deer, concerned about disease or ticks and hunt deer, you are less likely
to leave food out if you are older;
*This model is easier to explain compared to the one below, people who are concerned over disease or ticks compared to 
those who are not concerned about either;
proc logistic data=dmvdeer2 descending;
	where FeedDeer=1;
	model FeedDeerLeaveFood = ConcernDisTicksBi ConcernDisFromDeer enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;
*Compared to people who are not at all concerned those who are concerned about both are more likely to leave
food out;
proc logistic data=dmvdeer2 descending;
	where FeedDeer=1;
	model FeedDeerLeaveFood = ConcernDisTicks4_1 ConcernDisTicks4_2 ConcernDisTicks4_3 enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi ResidenceHasYard / expb;
run;

*Now looking at those who feed out of hand;
*those who feed deer, there is a subset who hand feed and those people are not concerned about diseases or ticks;
proc logistic data=dmvdeer2 descending;
	where FeedDeer=1;
	model FeedDeerHand = ConcernDisTicks4_1 ConcernDisTicks4_2 ConcernDisTicks4_3 enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi / expb;
run;

*The ones who are hand feeding are not concerned;
*If we want to pretend there is a decision tree, someone has decided they're going to feed deer and then how are they feeding deer,
there is a group leaving food out and the other hand feeding them, the group leaving food out is concerned about disease or ticks and
the group hand feeding them are not concerened, so among those who make the decision to feed deer, if you can get them concerned then maybe they'll
stop touching deer;
proc logistic data=dmvdeer2 descending;
	where FeedDeer=1;
	model FeedDeerHand = ConcernDisTicksBi enjoyseedeer Race_NHBlack Race_Hispanic Race_Other Q42_age Income2_2 Income2_3 
    EduCat3_2 EduCat3_3 DeerHunting DogCareBi / expb;
run;

*FINAL MODELS FOR PAPER;






	
	






	