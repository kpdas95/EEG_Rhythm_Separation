%#########################################################
%####                                                 ####
%####             EEG Rhythm Separation               ####
%####                                                 ####
%#########################################################
%
% Mean frequeny based EEG rhythm separation
% mIMF: contain the modes provided by multivariate iterative filtering.
%       Each cell containg one particular MIMF corresponding to all
%       channel. For example, cell (1,1) contains first or highest
%       frequency MIMF. Each row of mIMF{1,ind_mimf} represent ind_mimf^th MIMF 
%       corresponding to a particular channel. mIMF{1,5}(3,:)
%       contains 5th MIMFs of channel 3.
%
% Fs:   is the smapling frequency.
%
% eeg_rhy: containg the EEG rhythms, namely delta, theta, alpha, beta,
%          and gamma in eeg_rhy{1,1}, eeg_rhy{1,2}, eeg_rhy{1,3},
%          eeg_rhy{1,4}, and eeg_rhy{1,5}, respectively. 
%
%
%% Example:
%       x = rand(5,1000); % Take any multi-channel EEG signal in x 
%       opt=Settings_IF_v1('IF.Xi',2,'IF.alpha','ave','IF.delta',.001,'IF.NIMFs',20);
%       MIMF = IterFiltMulti(x,opt);
%       eeg_rhy = EEGRhythm(MIMF,Fs);
%
%
% Please cite the following paper if are using this code or
% part of the code:
%
% [1] Kritiprasanna Das and Ram Bilas Pachori. "Schizophrenia 
% detection technique using multivariate iterative filtering and
% multichannel EEG signals." Biomedical Signal Processing and 
% Control 67 (2021): 102525.
%
%
%
% For any queries or help plese feel free to write a mail to 
% kpdas95@gmail.com. I will be hapy to help.

function [eeg_rhy]= EEGRhythm(mIMF,Fs)


N=size(mIMF{1,1},2); % Length of the data
N_ch=size(mIMF{1,1},1); % number of channel
N_mimf = size(mIMF,2); % Number of MIMF

for imf_ind = 1: N_mimf
    mf(:,imf_ind)=meanfreq(mIMF{1,imf_ind}', Fs);
end
mf = mean(mf,1);

delta_i=[];theta_i=[];alpha_i=[];
beta_i=[];gamma_i=[];
for i=1:length(mf) % Select IMF belongs to band
    if ((mf(i)>.1) && (mf(i) <4))
        delta_i=[delta_i,i];
    elseif (mf(i)>=4 && mf(i) <8)
        theta_i=[theta_i,i];
    elseif (mf(i)>=8 && mf(i) <14)
        alpha_i=[alpha_i,i];
    elseif (mf(i)>=14 && mf(i) <30)
        beta_i=[theta_i,i];
    elseif (mf(i)>=30 && mf(i) <95)
        gamma_i=[gamma_i,i];
    end
end

eeg_rhy{1,1} = EEG_Rhy(mIMF, delta_i);
eeg_rhy{1,2} = EEG_Rhy(mIMF, theta_i);
eeg_rhy{1,3} = EEG_Rhy(mIMF, alpha_i);
eeg_rhy{1,4} = EEG_Rhy(mIMF, beta_i);
eeg_rhy{1,5} = EEG_Rhy(mIMF, gamma_i);


end


% Axulary functions

function [Rhy] = EEG_Rhy(mIMF, ind)
Rhy = zeros(size(mIMF{1,1}));
for i = 1: length(ind)
    Rhy = Rhy + mIMF{1,ind(i)};
end
end