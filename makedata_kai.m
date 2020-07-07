clear all; close all; 
nclass=10; % number of classes
load('./usps_resampled.mat'); 
[d,ndata]=size(test_patterns);
test=zeros(d,ndata); 
trai=zeros(d,ndata); 
test_label=zeros(ndata,1);
trai_label=zeros(ndata,1); 
%画素値を0から１の間に正規化、クラスラベルを0から9に分類
for ii = 1 : ndata 
    test_label(ii)=find(test_labels(:,ii)==1)-1; % 0から9までの数字
    tmp=reshape(test_patterns(:,ii),[16 16]); 
    tmp=tmp'; 
    tmp=tmp-min(tmp(:)); 
    tmp=tmp./max(tmp(:)); 
    test(:,ii)=tmp(:); 
    trai_label(ii)=find(train_labels(:,ii)==1)-1; 
    tmp=reshape(train_patterns(:,ii),[16 16]); 
    tmp=tmp'; 
    tmp=tmp-min(tmp(:)); 
    tmp=tmp./max(tmp(:)); 
    trai(:,ii)=tmp(:); 
end
