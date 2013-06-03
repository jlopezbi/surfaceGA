function [ lineWidth ] = mapStrainToLnWidth(strain,stressMax,stressMin,lnMin,lnRange)
%[ lineWidth ] = mapStrainToLnWidth(strain,stressMax,stressMin,lnMin,lnRange)
% 
%
lineWidth = lnMin;
if(~isnan(strain))
    if(strain>0)
        %TENSION 
        sMapped = strain/stressMax;
    else
        %COMPRESSION or no stress
        sMapped = strain/stressMin;
    end
     lineWidth = lnMin + sMapped*lnRange;
end


