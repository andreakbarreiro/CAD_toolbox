function [spM] = genASp_Type3_fn(nC,freq,T,lags)
% genAsSp_Type3
%
%  "For assembly type II, spikes follow a precise sequential pattern across the set 
%  of assembly neurons on each instance of activation (Lee and Wilson, 2002; 
%   Diba and Buzsa ?ki, 2007). Time lags between spikes
%   were drawn from a uniform distribution [0 0.1] s, and then fixed for
%   each occurrence"
%
%  "For assembly type III, spikes across the set of assembly neurons
%  followed a precise temporal pattern, but did not exhibit a strict 
%  temporal order, i.e. each neuron could contribute one to several 
%  spikes to the assem- bly pattern without strictly leading or following 
%   others (e.g. [Ikegaya et al., 2004]). For the simulations, these patterns 
%  were generated by distributing a few spikes at a Poisson rate of 10 Hz across 
%  a period of 0.2 s for each assembly neuron, but then keeping these patterns
%  fixed on each occasion of assembly activation."
%

% Create lags?
if (nargin<4)
    lags =  unifrnd(0,0.1,[nC-1 1]); 
    % wrt first cell
    lags = [0;cumsum(lags)];
else
    if (length(lags)==1)
        % Interpret this as a STRETCH parameter
        stretch = lags;
        lags =  unifrnd(0,0.1,[nC-1 1]); 
        % WRT first cell
        lags = [0;cumsum(lags)]*stretch;
    end
end

tref = 0.015;  %Refractory period

% Now create "patterns"
%  1) # of spikes: 10Hz, 0.2 s
nSp    = poissrnd(10*0.2, nC,1);
nSp    = max(nSp,1);  % Make sure each has at least one
spAs   = nan(nC,max(nSp));
for j1=1:nC
    spAs(j1,1:nSp(j1))=sort(unifrnd(0,0.2,[nSp(j1),1]));
end
%spAs
% Correct for violations of the refractory period
[I,J]=find(diff(spAs,[],2)<tref);
for j1=1:length(I)
   % I(j1) is the row: the cellID
   % J(j1) is the offending entry of "diff". That means
   %    spAs(I(j1),J(j1)+1)- spAs(I(j1),J(j1)) was too small
   %    Fix this by shifting the J(j1)+1 and later spike times
   spAs(I(j1),(J(j1)+1):end)=spAs(I(j1),(J(j1)+1):end)+tref;
end
%spAs
%find(diff(spAs,[],2)<tref)
% Incorporate lags
spAs = spAs + lags;


%spAs

% Generate times: ISIs are exponentially generated w/ frequency "1/freq"
%isi  = exprnd(1/freq, 1, round(freq*T*1.1));
% OR
% Use a Gamma distribution
nu   = 2;
isi  = gamrnd(nu/freq,1/nu,1,round(freq*T*1.2));

% Ensure above tref
isi  = isi+tref;

% Now sum
Times = cumsum(isi);

% Remove extra
Times(Times>T)=[];

lpat   = size(spAs,2);
lTimes = length(Times);

% Now add to the pattern we created earlier
spM = nan(nC,lpat,lTimes);
for j1=1:lTimes
    spM(:,:,j1)=spAs+Times(j1);
end

% Now sort, remove nan
spM = reshape(spM,[nC,lTimes*lpat]);
spM = sort(spM,2);  % Along 2nd dimension

% Will probably not be any to remove
spM(:,all(isnan(spM)))=[];

