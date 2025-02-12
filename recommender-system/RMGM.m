function [Data,Core,CndI,ItemMem,UserMem] = RMGM_EM(Data,Size,K,L,T)

% D domains
D = size(Size,1);

% M users and N items in all domains
M = sum(Size(:,1));
N = sum(Size(:,2));

% P observed ratings in all domains
P = sum(sum(Data>0));

% R rating scales (1 ... R)
R = max(max(Data));

% represent the data as a sparse matrix
X = zeros(P,3);
i = 0;
for m = 1:M
    for n = 1:N
        if  Data(m,n)>0
            i = i+1;
            X(i,1) = m;
            X(i,2) = n;
            X(i,3) = Data(m,n);
        end
    end
end

%% Initialize model parameters

% randomly initialize latent user/item variables
ZU = ceil(rand(P,1)*K);
ZI = ceil(rand(P,1)*L);

% initialize the posteriors P(user_group,item_group|user,item,rating)
Post = randn(K,L,P);
Post = Post + max(max(Post));
for p = 1:P
    Post(ZU(p),ZI(p),p) = 1;
end

% user group priors
PrrU = randn(K,1);
PrrU = PrrU + max(max(PrrU));
% item group priors
PrrI = randn(L,1);
PrrI = PrrI + max(max(PrrI));
% user probability conditioned on user group 
CndU = randn(M,K);
CndU = CndU + max(max(CndU));
% item probability conditioned on item group
CndI = randn(N,L);
CndI = CndI + max(max(CndI));
% rating probability conditioned on user-item joint group
CndR = randn(K,L,R);
CndR = CndR + max(max(CndR));

%% EM algorithm iterations

for t = 1:T
    % M-step
    PrrU = sum(sum(Post,3),2)/P;
    PrrI = sum(sum(Post,3),1)'/P;
    for r = 1:R
        Idx = (X(:,3)==r);
        CndR(:,:,r) = sum(Post(:,:,Idx),3)./sum(Post,3);
    end
    for m = 1:M
        Idx = (X(:,1)==m);
        CndU(m,:) = sum(sum(Post(:,:,Idx),3),2)'./(P*PrrU');
    end
    for n = 1:N
        Idx = (X(:,2)==n);
        CndI(n,:) = sum(sum(Post(:,:,Idx),3),1)./(P*PrrI');
    end
    % E-step
    for p = 1:P
        m = X(p,1);
        n = X(p,2); 
        r = X(p,3);
        Prr = PrrU*PrrI';
        Cnd = CndU(m,:)'*CndI(n,:);
        Post(:,:,p) = Prr.*Cnd.*CndR(:,:,r);
        Post(:,:,p) = Post(:,:,p)/sum(sum(Post(:,:,p)));
    end
    t
end

%% Compute core matrix and memberships

% compute group-level (compressed) rating matrix
Core = zeros(K,L);
for r = 1:R
    r = double(r);
    Core = Core+r*CndR(:,:,r);
end
disp('Shared group-level rating matrix across domains:')
% compute user and item memberships
UserMem = zeros(M,K);
for m = 1:M
    total = CndU(m,:)*PrrU(:);
    UserMem(m,:) = CndU(m,:).*PrrU'/total;
end
ItemMem = zeros(N,L);
for n = 1:N
    total = CndI(n,:)*PrrI(:);
    ItemMem(n,:) = CndI(n,:).*PrrI'/total;
end 

%% Fill in the missing entries

StartU = ones(1,D+1);
StartI = ones(1,D+1);
for d = 2:D
    StartU(d) = StartU(d-1)+Size(d-1,1);
    StartI(d) = StartI(d-1)+Size(d-1,2);
end
StartU(D+1) = M+1;
StartI(D+1) = N+1;
UserMem;
ItemMem;
for d = 1:D
    for m = StartU(d):StartU(d+1)-1
        for n = StartI(d):StartI(d+1)-1
            if Data(m,n)==0
                Data(m,n) = UserMem(m,:)*Core*ItemMem(n,:)';
            end
        end
    end
end

%% Compute the co-clustering result

IdxU = zeros(1,M);
IdxI = zeros(1,N);
for m = 1:M
    [Tmp,Idx] = sort(-UserMem(m,:));
    IdxU(m) = Idx(1);
end
for n = 1:N
    [Tmp,Idx] = sort(-ItemMem(n,:));
    IdxI(n) = Idx(1);
end

disp('Co-clustering results and filled rating matrices:')
for d = 1:D
    [B,SortU] = sort(IdxU(StartU(d):StartU(d+1)-1));
    [B,SortI] = sort(IdxI(StartI(d):StartI(d+1)-1));
%    disp(Data(SortU+StartU(d)-1,SortI+StartI(d)-1));
end

