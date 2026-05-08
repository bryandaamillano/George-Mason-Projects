*Formats for GCH 824 assignments;
proc format;
        value miss      .="Missing"
                        other="Ok";

        value out       0="Term"
                        1="Preterm"
                        .="Missing";

        value yesno     0="No"
                        1="Yes"
                        .="Missing";

        value yesnoa    0="2 No"
                        1="1 Yes"
                        .="Missing";

        value mraceeth  1="White"
                        2="African American"
                        3="American Indian/Alaska Native"
                        4="Asian"
                        5="Hawaiian/Pacific Islander"
                        6="Hispanic"
                        7="Multi-racial"
                        .="Missing";

        value precare   0="No care"
                        1="1"
                        2="2"
                        3="3"
                        4="4"
                        5="5"
                        6="6"
                        7="7"
                        8="8"
                        9="9"
                        10="10"
                        11="11"
                        .="Missing";

        value uhisp     0="Non-Hispanic"
                        1="Mexican"
                        2="Puerto Rican"
                        3="Cuban"
                        4="Central & South American"
                        5="Other/Unknown Hispanic"
                        .="Unknown";

        value racerec   1="White"
                        2="Black"
                        3="American Indian/Alaska Native"
                        4="Asian/Pacific Islander"
                        .="Missing";

        value hisp      0="Not Hispanic"
                        1="Hispanic"
                        .="Unknown";

        value uhispa    0="6 Non-Hispanic"
                        1="1 Mexican"
                        2="2 Puerto Rican"
                        3="3 Cuban"
                        4="4 Central & South American"
                        5="5 Other/Unknown Hispanic"
                        .="Unknown";

        value age5cat   1-3="Index"
                        4="Reference"
                        5-8="Index"
                        .="Missing";

        value elgga     .="Missing GA"
                        0="GA le 20 weeks"
                        1="Eligible GA";

        value probcare  0="No PNC or PNC le GA"
                        1="PNC later than GA"
                        2="PNC visits gt time";

		value age5cat 	1-3="Index"
						4="Reference"
						5-8="Index"
						.="Missing";

run;
