function [pred_logk] = apply_kmarker(dat1, dat2, dat3)
% applies the "k-marker", a brain signature of individual differences in 
% delay discounting, to fmri_data dat1, dat2, dat3, and provides a brain-
% based predicted log(k) as the output (pred_logk).
% You need to have the k-marker weight maps, SPM, and CablabCore tools (see 
% https://github.com/canlab/CanlabCore) on your path for this code to work.
% To apply the k-marker to your data, you need three contrast images per 
% subject: 1) Choice screen onset, 2) parametric modulation by LL-Amount 
% (or relative LL-Amount), and 3) Delay (similar contrasts might work too 
% but have not been validated yet)
% Brain images will be rescaled prior to pattern expression (to be on the
% same scale as the training data)
%
% by Leonie Koban (2022)
%
% Please cite the following paper when you use this code and the k-marker:
% Leonie Koban, Sangil Lee, Daniela S Schelski, Marie-Christine Simon, 
% Caryn Lerman, Bernd Weber, Joseph W Kable, & Hilke Plassmann. 
% An fMRI-based brain marker of individual differences in delay discounting. 
%

wmap1_filepath = which('wmap1_kmarker_choice.img');
wmap2_filepath = which('wmap2_kmarker_LLamount.img');
wmap3_filepath = which('wmap3_kmarker_delay.img');

if (isempty(wmap1_filepath) || isempty(wmap2_filepath) || isempty(wmap3_filepath))
    error(' k-marker weight maps not found ')
end

dat1 = rescale(dat1, 'zscoreimages');
dat2 = rescale(dat2, 'zscoreimages');
dat3 = rescale(dat3, 'zscoreimages');

pexp1 = apply_mask(dat1, wmap1_filepath, 'pattern_expression', 'ignore_missing'); 
pexp2 = apply_mask(dat2, wmap1_filepath, 'pattern_expression', 'ignore_missing'); 
pexp3 = apply_mask(dat3, wmap1_filepath, 'pattern_expression', 'ignore_missing'); 

pred_logk = pexp1 + pexp2 + pexp3 + -5.9164; % adds all pattern response together, plus intercept 

