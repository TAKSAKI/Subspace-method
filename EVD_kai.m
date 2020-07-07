function [eig_vec,eig_val]=EVD(D)
%%==========================================
%% EigenValue Decomposition %% 
%% D is a d x n data matrix 
%% (d:dimensionality, n: number of samples) 
%% eig_vec: sorted eigenvectors 
%% eig_val: sorted eigenvalues
%%========================================= 
[d,n]=size(D);
if d < n 
    C=D*D'; %行列を作成
    matrank=rank(C); %行列を作成
    [tmp_vec,tmp_val] = eig(C); %固有値tmp_valを値に持つ対角行列とその時の固有ベクトル
    [value,index]=sort(diag(tmp_val),'descend'); %固有値を降順で表した時の値と場所を取得
    eig_vec=tmp_vec(:,index(1:matrank)); %固有ベクトルの1からrankまでの列まで取得
    eig_val=value(1:matrank); %固有値の1からrankまで取得
else
    C=D'*D;  %行列を作成
    matrank=rank(C); %行列を作成
    [tmp_vec,tmp_val] = eig(C); %固有値tmp_valを値に持つ対角行列とその時の固有ベクトル
    [value,index]=sort(diag(tmp_val),'descend'); %固有値を降順で表した時の値と場所を取得
    eig_vec=[]; 
    for i = 1:matrank %n<<dのときは固有ベクトルの変換公式 X*tmp_vec(i)/sqrt(rambda(i))を用いたほうが効率的
        v=(D*tmp_vec(:,index(i)))./sqrt(value(i)); 
        eig_vec=[eig_vec,v]; 
    end
    eig_val=value(1:matrank); %固有値の1からrankまで取得
end
