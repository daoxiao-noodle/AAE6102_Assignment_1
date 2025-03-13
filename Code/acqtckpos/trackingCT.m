function  TckResultCT = trackingCT(file,signal,track,Acquired)
%Purpose:
%   Perform signal tracking using conventional DLL and PLL 
%Inputs:
%	file        - parameters related to the data file to be processed
%	signal      - parameters related to signals,a structure
%	track       - parameters related to signal tracking 
%	Acquired    - acquisition results
%Outputs:
%	TckResultCT	- conventional tracking results, e.g. correlation values in 
%                   inphase prompt (P_i) channel and in qudrature prompt 
%                   channel (P_q), etc.
%--------------------------------------------------------------------------
%                           GPSSDR_vt v1.0
% 
% Written by B. XU and L. T. HSU


%%

Spacing = [-track.CorrelatorSpacing 0 track.CorrelatorSpacing];
Spacing_corr = -0.5:0.1:0.5; % Compute multiple correlation points
numCorr = length(Spacing_corr);
CorrelationResults = zeros(1, numCorr); % Store correlation values
[tau1code, tau2code] = calcLoopCoef(track.DLLBW,track.DLLDamp,track.DLLGain);
[tau1carr, tau2carr] = calcLoopCoef(track.PLLBW,track.PLLDamp,track.PLLGain);

datalength = track.msEph;
delayValue = zeros(length(Acquired.sv),datalength);

% Parameters required for pseudorange calculation
%chip_length = 299792458 / 1.023e6; % Length of each chip (meters)

for svindex = 1:length(Acquired.sv) % Iterate over all acquired satellites
    %fig_handles(svindex) = figure('Name', sprintf('PRN %d', Acquired.sv(svindex))); 
    hold on; % Allow multiple curves to be overlaid
    grid on;
    %colors = lines(length(Acquired.sv)); 
    xlabel('Code Phase Offset (Chips)');
    ylabel('Correlation Value');
    title('GPS Signal Correlation Function for OpenSky Dataset');
    %title(sprintf('GPS Signal Correlation Function for PRN %d', Acquired.sv(svindex)));
    remChip = 0;
    remPhase=0;
    remSample = 0;
    carrier_output=0;
    carrier_outputLast=0;
    PLLdiscriLast=0;
    code_output=0;
    code_outputLast=0;
    DLLdiscriLast=0;
    Index = 0;
    AcqDoppler = Acquired.fineFreq(svindex)-signal.IF;
    AcqCodeDelay = Acquired.codedelay(svindex);
    
    Codedelay = AcqCodeDelay;
    codeFreq = signal.codeFreqBasis;
    carrierFreqBasis = Acquired.fineFreq(svindex);
    carrierFreq = Acquired.fineFreq(svindex);
    
    % set the file position indicator according to the acquired code delay
    fseek(file.fid,(signal.Sample-AcqCodeDelay-1+file.skip*signal.Sample)*file.dataPrecision*file.dataType,'bof');  % 
    
    Code = generateCAcode(Acquired.sv(svindex));
    Code = [Code(end) Code Code(1)];
    
    h = waitbar(0,['Channel:',num2str(svindex),'  Tracking, please wait...']);
    
    for IndexSmall = 1: datalength        
        waitbar(IndexSmall/datalength)
        Index = Index + 1;
        
        remSample = ((signal.codelength-remChip) / (codeFreq/signal.Fs));
        numSample = round((signal.codelength-remChip)/(codeFreq/signal.Fs)); 
        delayValue(svindex,IndexSmall) = numSample - signal.Sample;
        
        if file.dataPrecision == 2 %int 16
            rawsignal = fread(file.fid,numSample*file.dataType,'int16')'; 
            sin_rawsignal = rawsignal(1:2:length(rawsignal));
            cos_rawsignal = rawsignal(2:2:length(rawsignal));
            rawsignal0DC = sin_rawsignal - mean(sin_rawsignal) + 1i*(cos_rawsignal-mean(cos_rawsignal));
        else  % int 8
            %rawsignal0DC = fread(file.fid,numSample*file.dataType,'int8')';
            rawdata = fread(file.fid, numSample * file.dataType, 'int8')';
            if file.dataType == 2  % I/Q 
                I_signal = rawdata(1:2:end);  % Extract I channel
                Q_signal = rawdata(2:2:end);  %  Extract Q channel
                rawsignal0DC = I_signal + 1i * Q_signal;  %  % Form complex signal
            else  % % Only I data
                rawsignal0DC = rawdata;
            end
        end
        t_CodeEarly    = (0 + Spacing(1) + remChip) : codeFreq/signal.Fs : ((numSample -1) * (codeFreq/signal.Fs) + Spacing(1) + remChip);
        t_CodePrompt   = (0 + Spacing(2) + remChip) : codeFreq/signal.Fs : ((numSample -1) * (codeFreq/signal.Fs) + Spacing(2) + remChip);
        t_CodeLate     = (0 + Spacing(3) + remChip) : codeFreq/signal.Fs : ((numSample -1) * (codeFreq/signal.Fs) + Spacing(3) + remChip);
        CodeEarly      = Code(ceil(t_CodeEarly) + 1);
        CodePrompt     = Code(ceil(t_CodePrompt) + 1);
        CodeLate       = Code(ceil(t_CodeLate) + 1);
        remChip   = (t_CodePrompt(numSample) + codeFreq/signal.Fs) - signal.codeFreqBasis*signal.ms;
        
        CarrTime = (0 : numSample)./signal.Fs;
        Wave     = (2*pi*(carrierFreq .* CarrTime)) + remPhase ;  
        remPhase =  rem( Wave(numSample+1), 2*pi); 
        carrsig = exp(1i.* Wave(1:numSample));
        InphaseSignal    = imag(rawsignal0DC .* carrsig);
        QuadratureSignal = real(rawsignal0DC .* carrsig);
        for i = 1:numCorr
            t_Code = (0 + Spacing_corr(i) + remChip) : codeFreq/signal.Fs : ((numSample -1) * (codeFreq/signal.Fs) + Spacing_corr(i) + remChip);
            CodeCorr = Code(ceil(t_Code) + 1); 
            Corr_i=sum(CodeCorr.*InphaseSignal);
            Corr_q=sum(CodeCorr.*QuadratureSignal);
            CorrelationResults(i) = sqrt(Corr_i^2+Corr_q^2);
        end

        E_i  = sum(CodeEarly    .*InphaseSignal);  E_q = sum(CodeEarly    .*QuadratureSignal);
        P_i  = sum(CodePrompt   .*InphaseSignal);  P_q = sum(CodePrompt   .*QuadratureSignal);
        L_i  = sum(CodeLate     .*InphaseSignal);  L_q = sum(CodeLate     .*QuadratureSignal);
        
        % DLL
        E               = sqrt(E_i^2+E_q^2);
        L               = sqrt(L_i^2+L_q^2);
        DLLdiscri       = 0.5 * (E-L)/(E+L);
        code_output     = code_outputLast + (tau2code/tau1code)*(DLLdiscri - DLLdiscriLast) + DLLdiscri* (0.001/tau1code);
        DLLdiscriLast   = DLLdiscri;
        code_outputLast = code_output;
        codeFreq        = signal.codeFreqBasis - code_output;
        
        % PLL
        PLLdiscri           = atan(P_q/P_i) / (2*pi);
        carrier_output      = carrier_outputLast + (tau2carr/tau1carr)*(PLLdiscri - PLLdiscriLast) + PLLdiscri * (0.001/tau1carr);
        carrier_outputLast  = carrier_output;  
        PLLdiscriLast       = PLLdiscri;
        carrierFreq         = carrierFreqBasis + carrier_output;  % Modify carrier freq based on NCO command
        
        % Data Record
        TckResultCT(Acquired.sv(svindex)).P_i(Index)            = P_i;
        TckResultCT(Acquired.sv(svindex)).P_q(Index)            = P_q;
        TckResultCT(Acquired.sv(svindex)).E_i(Index)            = E_i;
        TckResultCT(Acquired.sv(svindex)).E_q(Index)            = E_q;
        TckResultCT(Acquired.sv(svindex)).L_i(Index)            = L_i;
        TckResultCT(Acquired.sv(svindex)).L_q(Index)            = L_q;
        TckResultCT(Acquired.sv(svindex)).PLLdiscri(Index)      = PLLdiscri;
        TckResultCT(Acquired.sv(svindex)).DLLdiscri(Index)      = DLLdiscri;
        TckResultCT(Acquired.sv(svindex)).codedelay(Index)      = Codedelay + sum(delayValue(1:Index));
        TckResultCT(Acquired.sv(svindex)).remChip(Index)        = remChip;
        TckResultCT(Acquired.sv(svindex)).codeFreq(Index)       = codeFreq;  
        TckResultCT(Acquired.sv(svindex)).carrierFreq(Index)    = carrierFreq;  
        TckResultCT(Acquired.sv(svindex)).remPhase(Index)       = remPhase;
        TckResultCT(Acquired.sv(svindex)).remSample(Index)      = remSample;
        TckResultCT(Acquired.sv(svindex)).numSample(Index)      = numSample;
        TckResultCT(Acquired.sv(svindex)).delayValue(Index)     = delayValue(svindex,IndexSmall);
        TckResultCT(Acquired.sv(svindex)).absoluteSample(Index)  = ftell(file.fid); 
        %if Index == 1
        %    initial_codedelay = TckResultCT(Acquired.sv(svindex)).delayValue(Index);
        %end
        %delta_chips = TckResultCT(Acquired.sv(svindex)).delayValue(Index) - initial_codedelay;
        %pseudo_range = delta_chips * chip_length;
        %TckResultCT(Acquired.sv(svindex)).CorrelationResults(Index)     = CorrelationResults;
        %TckResultCT(Acquired.sv(svindex)).pseudo_range(Index) = pseudo_range;
        if mod(IndexSmall, 5000) == 0
       % if mod(IndexSmall, 1000) == 0
            plot(Spacing_corr, CorrelationResults, '.-', 'LineWidth', 1);
            hold on;
        end
        %legend(arrayfun(@(x) sprintf('SV %d', x), Acquired.sv, 'UniformOutput', false));
        %hold off;
    end
    hold on;
     %hold off;
     %
     % plot(Spacing_corr, CorrelationResults, '.-', 'LineWidth', 1);
     % xlabel('Code Phase Offset (Chips)');
     % ylabel('Correlation Value');
     % title('GPS Signal Correlation Function for PRN %d',Acquired.sv(svindex));
     %  legend(arrayfun(@(x) sprintf('SV %d', x), Acquired.sv(svindex), 'UniformOutput', false)); 
  %hold off;
  close(h);
end % end for
hold off;
% for svindex = 1:length(Acquired.sv) 
%     CorrelationResults=TckResultCT(Acquired.sv(svindex)).CorrelationResults(datalength/2);
%       plot(Spacing_corr, CorrelationResults, '.-', 'LineWidth', 1);
%       legend(arrayfun(@(x) sprintf('SV %d', x), Acquired.sv(svindex), 'UniformOutput', false)); 
% end
