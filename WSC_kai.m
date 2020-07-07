% Weighted Subspace Classifier 
%clear all; close all; 

% パラメータの設定
%r=13;      % 部分空間の次元
imgnum=1;  % test sample number for displaying Uc 
nclass=10; % クラスの総数(0から9) 

% loading data-file 
load('./usps_resampled/usps.mat'); 
[d,ndata]=size(trai);%ｄは画素数(行)、ndataはデータの数(列)
for ii = 1 : ndata 
    trai(:,ii)=trai(:,ii)./norm(trai(:,ii)); % 大きさ1のベクトルにして固有値固有ベクトルにもっていく
end

figure(1),clf;
%% forming subspaces
for c = 1 : nclass 
    X=trai(:,find(trai_label==c-1)); %訓練ラベルがc-1の訓練サンプルを見つける
    [C(c).U,C(c).eigval]=EVD(X); %訓練ラベルがc-1の固有値固有ベクトルを1..ndataまで求める
    %% displaying U of each class 
    for ii = 1 : 10 
        IMG=reshape(C(c).U(:,ii),[16 16]); 
        IMG=IMG-min(IMG(:)); 
        IMG=IMG./max(IMG(:)); 
        figure(1),subplot(10,10,(c-1).*10+ii),imshow(IMG); 
    end
end

figure(2),clf;
%% displaying Uc
Q=test(:,imgnum)./norm(test(:,imgnum));%テストパターンの1番目に属する正規直行ベクトル。今回の場合は人が見て一番数字が認識しやすいテストサンプル
IMG=reshape(Q,[16 16]);
IMG=IMG-min(IMG(:));
IMG=IMG./max(IMG(:));
figure(2),subplot(2,10,5),imshow(IMG); 
title('test sample'); 
for c = 1 : nclass 
    a=C(c).U(:,1:r)'*Q;%テストサンプルをそれぞれのクラスcに属する次元数r列までの固有ベクトルに正射影
    IMG=reshape(C(c).U(:,1:r)*a,[16 16]); 
    IMG=IMG-min(IMG(:));
    IMG=IMG./max(IMG(:)); 
    figure(2),subplot(2,10,10+c),imshow(IMG); 
    s=sprintf('class %d',c-1);
    title(s); 
end

%% weighted subspace classifier
w=sqrt([r:-1:1]');  % linear weight for(i=1:r)においてw=(r-i+1)
S=zeros(nclass,1);  % 各クラスの部分空間に射影したベクトルの重み付きノルム
CONF=zeros(nclass); % 混同行列の初期化
tic 
for ii = 1 : ndata 
    test(:,ii)=test(:,ii)./norm(test(:,ii)); %テストを大きさ１に正規化
    for c = 1 : nclass 
        S(c)=norm(w.*(C(c).U(:,1:r)'*test(:,ii))); %testをすべての部分空間における固有ベクトルに正射影
    end
    [value,index]=max(S);%正射影が最大の物の値とindexを表示
    CONF(index,test_label(ii)+1)=CONF(index,test_label(ii)+1)+1; %CONF行列に追加
end
finish=toc;

accuracy=(sum(diag(CONF))./ndata).*100;%混同行列の対角成分の和(認識が当たった)/総データ数 
fprintf(1,'accuracy=%3.2f\n',accuracy);
fprintf(1,'classification time per sample: %f[s]\n',finish./ndata);
CONF
