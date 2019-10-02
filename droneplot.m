%% Load data files
addpath('/Users/darshanjain/Desktop/power_profile/outdoor')
data=FLY214;
%data1= FLY192;
%data=rmmissing(data);
%% Plot Time,Height,Power
figure()
yyaxis left
scatter(data.offsetTime(4000:end),data.GeneralrelativeHeightmeters(4000:end),5,'x')
xlabel('Time (s)')
ylabel('Height (m)')
yyaxis right
scatter(data.offsetTime(4000:end),data.Battery0wattsWatts(4000:end),5,'o')
ylabel('Power (W)')
title('Time v/s Power and Height')

%%
data2.offsetTime = data1.offsetTime(end) + data2.offsetTime;
data = [data1; data2];
%% Static case
addpath('/Users/darshanjain/Desktop/power_profile/static')
data = load('FLY214.mat');
data = data.FLY214;
figure()
hold on
scatter(data.offsetTime(1:1485)   ,data.Battery0wattsWatts(1:1485),5,'o')
scatter(data.offsetTime(1485:3294),data.Battery0wattsWatts(1485:3294),5,'o')
scatter(data.offsetTime(3294:5213),data.Battery0wattsWatts(3294:5213),5,'o')
scatter(data.offsetTime(5213:6598),data.Battery0wattsWatts(5213:6598),5,'o')
scatter(data.offsetTime(6598:8354),data.Battery0wattsWatts(6598:8354),5,'o')
scatter(data.offsetTime(8354:end) ,data.Battery0wattsWatts(8354:end),5,'o')
legend('Standard UAV','Guidance added','TX2 added','Camera added','IR Camera added','SDR added','Location','northwest')
xlabel('Time (s)')
ylabel('Power (W)')
title('Power Profile for Static Case')
grid on
%% LidaR v/s GPS-BAROMETER
addpath('/Users/darshanjain/Desktop/power_profile/outdoor/mat')
addpath('/Users/darshanjain/Desktop/power_profile/outdoor/rosbag')
data = load('FLY184.mat');
data = data.FLY184;
lidardata = load('0g-pw.mat');
lidar = lidardata.lidar_range_uas4;
figure()
subplot(2,1,1)
plot(lidar.msg_time - lidardata.start_time,lidar.range)
xlabel('Time (s)')
ylabel('Height (m)')
title('Lidar Data')
subplot(2,1,2)
plot(data.offsetTime(1:4000),data.GeneralrelativeHeightmeters(1:4000))
xlabel('Time (s)')
ylabel('Height (m)')
title('GPS/Barometer Data')


%% Plot x-y movements
addpath('/Users/darshanjain/Desktop/power_profile')
[x,y]=deg2utm(data.IMU_ATTI0Latitudedegrees180180,data.IMU_ATTI0Longitudedegrees180180);
x=x-min(x);
y=y-min(y);
figure()
hold on
scatter3(x(1:5000),y(1:5000),data.GeneralrelativeHeightmeters(1:5000))
xlabel('x-axis (m)')
ylabel('y-axis (m)')
scatter3(x(1),y(1),data.GeneralrelativeHeightmeters(1),'x')
scatter3(x(5000),y(5000),data.GeneralrelativeHeightmeters(5000),'o')
legend('Flight Path','Start Position','End Position')
title('x-y movements')
%% Plot x-y-z movements
figure()
z=data.GeneralrelativeHeightmeters;
hold on
plot3(x,y,z,'o')
plot3(x(1),y(1),z(1),'rx')
plot3(x(end),y(end),z(end),'bx')
hold off
title('x-y-z movements')
%% Outdoor Power v/s Weight
addpath('/Users/darshanjain/Desktop/power_profile/outdoor/mat')
data1 = load('FLY184.mat');
data1 = data1.FLY184;
data2 = load('FLY185.mat');
data2 = data2.FLY185;

%concatenate two mat files
data2.offsetTime = data1.offsetTime(end) + data2.offsetTime;
data = [data1; data2];

d1 = data.Battery0wattsWatts(1:4750); d2 = data.Battery0wattsWatts(15200:22000); 
d3 = data.Battery0wattsWatts(24400:30300); d4 = data.Battery0wattsWatts(32800:37600); 
d5 = data.Battery0wattsWatts(39000:44000); d6 = data.Battery0wattsWatts(44700:48900); 
d7 = data.Battery0wattsWatts(63400:70000);

%plot
figure()
hold on
scatter(data.offsetTime(1:4750)+150     ,d1,5,'o')
scatter(data.offsetTime(15200:22000)    ,d2,5,'o')
scatter(data.offsetTime(24400:30300)-20 ,d3,5,'o')
scatter(data.offsetTime(32800:37600)+20 ,d4,5,'o')
scatter(data.offsetTime(39000:44000)+50 ,d5,5,'o')
scatter(data.offsetTime(44700:48900)+50 ,d6,5,'o')
scatter(data.offsetTime(63400:70000)-150,d7,5,'o')
legend('Original','50gm','100gm','200gm','300gm','400gm','500gm','Location','northeast')
xlabel('Time (s)')
ylabel('Power (W)')
ylim([400,600])
xlim([0,1499])
title('Outdoor: Power Profile for different Payloads')
grid on

% Error Plot

a = d1(d1 > 420 & d1 < 480 );
b = d2(d2 > 430 & d2 < 500 );
c = d3(d3 > 440 & d3 < 500 );
d = d4(d4 > 460 & d4 < 520 );
e = d5(d5 > 470 & d5 < 550 );
f = d6(d6 > 490 & d6 < 560 );
g = d7(d7 > 510 & d7 < 580 );

weight = [0,50,100,200,300,400,500]+ 3753;
y = [mean(a), mean(b), mean(c), mean(d), mean(e), mean(f), mean(g)] ;
error = [std(a), std(b), std(c), std(d), std(e), std(f), std(g)];
err1 = mean(error);
c1 = polyfit(weight,y,1);
y_est = polyval(c1,weight);

figure(3);
hold on
errorbar(weight,y,error,'*','Color','r','MarkerFaceColor','r','HandleVisibility','off')
plot(weight, y_est,'r')
xlabel('Weight (g)')
ylabel('Power (W)')
grid on
xlim([3700,4300])
ylim([400,600])
hold off



%% Outdoor Power v/s Height
addpath('/Users/darshanjain/Desktop/power_profile/outdoor')
data = load('FLY184.mat');
data = data.FLY184;
figure()
yyaxis left
scatter(data.offsetTime(1:4000),data.GeneralrelativeHeightmeters(1:4000),5,'x')
xlabel('Time (s)')
ylabel('Height (m)')
yyaxis right
scatter(data.offsetTime(1:4000),data.Battery0wattsWatts(1:4000),5,'o')
ylabel('Power (W)')
grid on
title('Outdoor: Power Profile for hovering at different height')
legend('Height - GPS','Power consumed')
ylim([400,500])

%% Outdoor Ascend - Descend
addpath('/Users/darshanjain/Desktop/power_profile/outdoor')
data = load('FLY187.mat');
data = data.FLY187;
figure()
hold on
yyaxis right
scatter(data.offsetTime(1:2500),data.Battery0wattsWatts(1:2500),5,'go')
scatter(data.offsetTime(17500:20000)-290,data.Battery0wattsWatts(17500:20000),5,'ro')
scatter(data.offsetTime(38000:40500)-650,data.Battery0wattsWatts(38000:40500),5,'ko')
xlabel('Time (s)')
ylabel('Power (W)')
ylim([400,530])

yyaxis left
scatter(data.offsetTime(1:2500),data.GeneralrelativeHeightmeters(1:2500),5,'x','HandleVisibility','off')
scatter(data.offsetTime(17500:20000)-290,data.GeneralrelativeHeightmeters(17500:20000),5,'x','HandleVisibility','off')
scatter(data.offsetTime(38000:40500)-650,data.GeneralrelativeHeightmeters(38000:40500),5,'x','HandleVisibility','off')
xlabel('Time (s)')
ylabel('Height (m)')
ylim([0.5,15])

grid on
legend('Max Velocity - 3m/s','Max Velocity - 2 m/s', 'Max Velocity 1 m/s')
title('Outdoor: Power profile for Ascend/Descend')

%% Indoor Power v/s Weight
%load
addpath('/Users/darshanjain/Desktop/power_profile/indoor/mat')
data1 = load('FLY192.mat');
data1 = data1.FLY192;
data2 = load('FLY193.mat');
data2 = data2.FLY193;

%concatenate two mat files
data2.offsetTime = data1.offsetTime(end) + data2.offsetTime;
data = [data1; data2];

d1 = data.Battery0wattsWatts(1:8100); d2 = data.Battery0wattsWatts(27500:34400); 
d3 = data.Battery0wattsWatts(36300:42891); d4 = data.Battery0wattsWatts(42891:49000); 
d5 = data.Battery0wattsWatts(51500:58800); d6 = data.Battery0wattsWatts(63600:68700); 
d7 = data.Battery0wattsWatts(73500:78500);



%plot
figure(2)
hold on
scatter(data.offsetTime(1:8100)+150,d1,5,'o')
scatter(data.offsetTime(27500:34400)-100,d2,5,'o')
scatter(data.offsetTime(36300:42891)-120,d3,5,'o')
scatter(data.offsetTime(42891:49000)-80,d4,5,'o')
scatter(data.offsetTime(51500:58800)-100,d5,5,'o')
scatter(data.offsetTime(63600:68700)-150,d6,5,'o')
scatter(data.offsetTime(73500:78500)-150,d7,5,'o')
legend('Original','50gm','100gm','200gm','300gm','400gm','500gm','Location','northeast')
xlabel('Time (s)')
ylabel('Power (W)')
ylim([400,600])
xlim([0,1800])
title('Indoor: Power Profile with different Payloads')
grid on


% Error Plot
d1 = data.Battery0wattsWatts(1:8100); d2 = data.Battery0wattsWatts(27500:34400); 
d3 = data.Battery0wattsWatts(36300:42891); d4 = data.Battery0wattsWatts(42891:49000); 
d5 = data.Battery0wattsWatts(51500:58800); d6 = data.Battery0wattsWatts(63600:68700); 
d7 = data.Battery0wattsWatts(73500:78500);

a = d1(d1 > 440 & d1 < 500 );
b = d2(d2 > 440 & d2 < 500 );
c = d3(d3 > 440 & d3 < 500 );
d = d4(d4 > 470 & d4 < 520 );
e = d5(d5 > 490 & d5 < 530 );
f = d6(d6 > 500 & d6 < 550 );
g = d7(d7 > 520 & d7 < 570 );

weight = [0,50,100,200,300,400,500] + 3753;
y = [mean(a), mean(b), mean(c), mean(d), mean(e), mean(f), mean(g)] ;
error = [std(a), std(b), std(c), std(d), std(e), std(f), std(g)];

c2 = polyfit(weight,y,1);
y_est = polyval(c2,weight);
figure(3)
hold on
errorbar(weight,y,error,'o','Color','k','MarkerFaceColor','k','HandleVisibility','off')
plot(weight, y_est,'k')
xlabel('Weight (g)')
ylabel('Power (W)')
err2 = mean(error);
grid on
xlim([3700,4300])
ylim([400,600])
text = ['Outdoor Std. = ' , num2str(err1) , ' Indoor Std. = ', num2str(err2),'      Base Weight = ', num2str(3753) , 'gm']; 
annotation('textbox', [0.15, 0.8, 0.25, 0.1], 'String', text)
title('Error Plot for Power Profile with Additional loads')
legend('Outdoor','Indoor')

%% Indoor Power v/s Height
addpath('/Users/darshanjain/Desktop/power_profile/indoor/mat')
data = load('FLY192.mat');
data = data.FLY192;
figure()
yyaxis left
scatter(data.offsetTime(1:7500),data.GeneralrelativeHeightmeters(1:7500),5,'x')
xlabel('Time (s)')
ylabel('Height (m)')
yyaxis right
scatter(data.offsetTime(1:7500),data.Battery0wattsWatts(1:7500),5,'o')
ylabel('Power (W)')
grid on
ylim([400,500])
title('Indoor: Power Profile for hovering at different height')
legend('Height - GPS','Power consumed')

%% Indoor Ascend/Descend
addpath('/Users/darshanjain/Desktop/power_profile/outdoor')
data = load('FLY193.mat');
data = data.FLY193;
figure()
hold on
yyaxis right
scatter(data.offsetTime(52500:60000)-1060,data.Battery0wattsWatts(52500:60000),5,'go')
scatter(data.offsetTime(60000:65000)-1110,data.Battery0wattsWatts(60000:65000),5,'ro')
xlabel('Time (s)')
ylabel('Power (W)')
ylim([400,500])

yyaxis left
scatter(data.offsetTime(52500:60000)-1060,data.GeneralrelativeHeightmeters(52500:60000),5,'x','HandleVisibility','off')
scatter(data.offsetTime(60000:65000)-1100,data.GeneralrelativeHeightmeters(60000:65000),5,'x','HandleVisibility','off')
xlabel('Time (s)')
ylabel('Height (m)')
ylim([0.5,15])

grid on
legend('Low velocity','High velocity')
title('Indoor: Power profile for Ascend/Descend')
%% Yaw Rate Plot
addpath('/Users/darshanjain/Desktop/power_profile/indoor/mat')
data1 = load('FLY197.mat');
data1 = data1.FLY197;
figure()
hold on
scatter(data1.offsetTime(20000:22000),data1.Battery0wattsWatts(20000:22000),5,'o')
scatter(data1.offsetTime(22000:23500),data1.Battery0wattsWatts(22000:23500),5,'o')
scatter(data1.offsetTime(23500:25000),data1.Battery0wattsWatts(23500:25000),5,'o')
scatter(data1.offsetTime(25000:26500),data1.Battery0wattsWatts(25000:26500),5,'o')
scatter(data1.offsetTime(26500:28000),data1.Battery0wattsWatts(26500:28000),5,'o')
scatter(data1.offsetTime(28000:29500),data1.Battery0wattsWatts(28000:29500),5,'o')
scatter(data1.offsetTime(29500:31500),data1.Battery0wattsWatts(29500:31500),5,'o')
scatter(data1.offsetTime(31500:33500),data1.Battery0wattsWatts(31500:33500),5,'o')
scatter(data1.offsetTime(33500:35500),data1.Battery0wattsWatts(33500:35500),5,'o')
scatter(data1.offsetTime(35500:37000),data1.Battery0wattsWatts(35500:37000),5,'o')
ylim([420,500])
legend('CW 0.1 rad/s','CW 0.5 rad/s','CW 1.0 rad/s','CW 1.5 rad/s','CW 2.0 rad/s',...
       'CCW 2.0 rad/s ','CCW 1.5 rad/s','CCW 1.0 rad/s','CCW 0.5 rad/s','CCW 0.1 rad/s')
title('Power profile with different Yaw Rate')
xlabel('Time (s)')
ylabel('Power (W)')
grid on

%%
comp = [2446,337,463,144,124,36,203,3753];
comp1 = [2466,2783,3248,3392,3436,3516,3756];
est1 = polyval(c1,comp1)
est2 = polyval(c2,comp1)

