*********************************************************;
*                                                       *;
* Purpose:  This program performs the analyses required *;
* for assignment 5.                                     *;
*                                                       *;
*This code can be used to perform a sensitivity analysis*;
*of the influence of an unmeasured confounder using a   *;
*trapezoid distribution and Monte Carlo simulation.     *;
*********************************************************;

*Create a dataset with estiamted RRs adjusted for the
unmeasured confounder;
data adj_rr;


        *Enter observed unadjusted RR for the main exposure and the outcome;
        rr_obs= 0.8521;

        *Enter values related to the trapezoid distribution for
        the RR for the unmeasured confounder and the outcome;

        seed_rr=268;     *Seed for random draw from the distribution;

        bl_rr=0.9;      *Lower bound of trapezoid distribution;
        bu_rr=1.8;      *Upper bound of trapezoid distribution;
        ml_rr=1.1;      *Lower mode of trapezoid distribution;
        mu_rr=1.7;      *Upper mode of trapezoid distribution;

        *Enter values related to the trapezoid distribution for
        the prevalence of exposure to the confounder among the unexposed;

        seed_p0=425;    *Seed for random draw from the distribution;

        bl_p0=0.55;     *Lower bound of trapezoid distribution;
        bu_p0=0.65;     *Upper bound of trapezoid distribution;
        ml_p0=0.58;     *Lower mode of trapezoid distribution;
        mu_p0=0.62;     *Upper mode of trapezoid distribution;

        *Enter values related to the trapezoid distribution for
        the prevalence of exposure to the confounder among the exposed;

        seed_p1=3454;   *Seed for random draw from the distribution;

        bl_p1=0.25;     *Lower bound of trapezoid distribution;
        bu_p1=0.35;     *Upper bound of trapezoid distribution;
        ml_p1=0.28;     *Lower mode of trapezoid distribution;
        mu_p1=0.32;     *Upper mode of trapezoid distribution;

        *Create sample - you can change the number of observations here;
        do i=1 to 100000;

                *Output random sample of RRs for the unmeasured
                confoudner and the outcome based on a trapezoidal
                distribution;

                *Random draw from a univaraite distribution;
                call ranuni(seed_rr, u_rr);

                *Convert a random draw from a univariate distribution to
                a random draw from a trapezoidal distribution based on
                formula on page 738 in Modern Epidemiology IV;
                v_rr=(bl_rr+ml_rr+u_rr*(bu_rr+mu_rr-bl_rr-ml_rr))/2;

                if v_rr ge ml_rr and v_rr le mu_rr then rr_conf=v_rr;
                else if v_rr lt ml_rr then rr_conf=bl_rr+sqrt((ml_rr-bl_rr)*(2*v_rr-ml_rr-bl_rr));
                else if v_rr gt mu_rr then rr_conf=bu_rr-sqrt(2*(bu_rr-mu_rr)*(v_rr-mu_rr));


                *Output random sample of prevalences of exposure to the
                confoudner among the unexposed based on a trapezoidal
                distribution;

                *Random draw from univariate distribution;
                call ranuni(seed_p0, u_p0);

                *Convert a random draw from a univariate distribution to
                a random draw from a trapezoidal distribution based on
                formula on page 738 in Modern Epidemiology IV;
                v_p0=(bl_p0+ml_p0+u_p0*(bu_p0+mu_p0-bl_p0-ml_p0))/2;

                if v_p0 ge ml_p0 and v_p0 le mu_p0 then p0=v_p0;
                else if v_p0 lt ml_p0 then p0=bl_p0+sqrt((ml_p0-bl_p0)*(2*v_p0-ml_p0-bl_p0));
                else if v_p0 gt mu_p0 then p0=bu_p0-sqrt(2*(bu_p0-mu_p0)*(v_p0-mu_p0));


                *Output random sample of prevalences of exposure to the
                confoudner among the exposed based on a trapezoidal
                distribution;

                *Random draw from univariate distribution;
                call ranuni(seed_p1, u_p1);

                *Convert a random draw from a univariate distribution to
                a random draw from a trapezoidal distribution based on
                formula on page 738 in Modern Epidemiology IV;
                v_p1=(bl_p1+ml_p1+u_p1*(bu_p1+mu_p1-bl_p1-ml_p1))/2;

                if v_p1 ge ml_p1 and v_p1 le mu_p1 then p1=v_p1;
                else if v_p1 lt ml_p1 then p1=bl_p1+sqrt((ml_p1-bl_p1)*(2*v_p1-ml_p1-bl_p1));
                else if v_p1 gt mu_p1 then p1=bu_p1-sqrt(2*(bu_p1-mu_p1)*(v_p1-mu_p1));

                *Calculate RR for main exposure and the outcome adjusted for the
                unmeasured confounder;
                rr_adj=rr_obs/((p1*(rr_conf-1)+1)/(p0*(rr_conf-1)+1));

                *Output the results;
                output;

        end;

        *Keep the variables you want here;
        keep rr_conf p0 p1 rr_adj;

        label   rr_adj="RR adjusted for unmeasured confounder"
                rr_conf="RR for unmeasured confounder and outcome"
                p0="Prevalence of unmeasured confounder among the unexposed"
                p1="Prevalence of unmeasured confounder among the exposed";
run;


*Create histogram of RR for confounder and outcome to see if it looks trapezoidal;
*You may want to change the endpoints depending on your expected trapezodial shape;
proc univariate data=adj_rr normal plots noprint;
        var rr_conf;
        histogram / endpoints=0.88 to 1.82 by .02;
        inset n="n" (comma6.0) mean="mean" (5.1) std="s.d." (5.1) / pos=ne;
        title justify=left "Figure 1 - Distribution of RR for Confounder and Outcome";
run;

*Create histogram of RR for prevalence of confounder among unexposed to see if it looks trapezodial;
*You may want to change the endpoints depending on your expected trapezodial shape;
proc univariate data=adj_rr normal plots noprint;
        var p0;
        histogram / endpoints=0.54 to 0.66 by .002;
        inset n="n" (comma6.0) mean="mean" (5.1) std="s.d." (5.1) / pos=ne;
        title justify=left "Figure 2 - Distribution of Prevelance of Confounder among Unexposed";
run;

*Create histogram of RR for prevalence of confounder among exposed to see if it looks trapezodial;
*You may want to change the endpoints depending on your expected trapezodial shape;
proc univariate data=adj_rr normal plots noprint;
        var p1;
        histogram / endpoints=0.24 to 0.36 by .002;
        inset n="n" (comma6.0) mean="mean" (5.1) std="s.d." (5.1) / pos=ne;
        title justify=left "Figure 3 - Distribution of Prevalence of Confounder among Exposed";
run;


*Determine median, range, and 95% bias correction interval for adjusted RR;
proc univariate data=adj_rr normal plots noprint;
        var rr_adj;
        output out=sumry pctlpre=p pctlpts= 0 2.5 50 97.5 100;
run;

proc print data=sumry noobs;
        title "Median, range, & 95% bias correction interval for adjusted RR";
run;
