data = [2, 0.0615; 2, 0.0527; 0.667, 0.0334; 0.667, 0.0334; 0.4, 0.0138; 0.4, 0.0258; 0.286, 0.0183; 0.222, 0.0083;0.222, 0.0083; 0.22, 0.0169; 0.2, 0.0129; 0.2, 0.0087];
x = 1./data(:,1);
y = 1./data(:,2);
J = [x, ones(length(x),1)];
k = J\y;
vmax = 1/k(2);
km = k(1)*vmax;
lse = (vmax.*data(:,1))./(km+data(:,1));
plot(data(:,1),data(:,2),'o','color','red','linewidth',1)
line(data(:,1),lse,'linewidth',2)