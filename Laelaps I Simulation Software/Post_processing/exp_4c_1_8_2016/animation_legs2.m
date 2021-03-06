%-------------------------------------------------------------------------%
% Animation Script
%-------------------------------------------------------------------------%

f1 = figure(1);
clf(f1);


% Size of data (find the vector with the minimum length)
n = min([size(FR_knee_encoder,2),size(FR_hip_encoder,2),...
    size(BR_knee_encoder,2),size(BR_hip_encoder,2),...
    size(FL_knee_encoder,2),size(FL_hip_encoder,2),...
    size(BL_knee_encoder,2),size(BL_hip_encoder,2),...
    size(FR_knee_setpoint,2),size(FR_hip_setpoint,2),...
    size(BR_knee_setpoint,2),size(BR_hip_setpoint,2),...
    size(FL_knee_setpoint,2),size(FL_hip_setpoint,2),...
    size(BL_knee_setpoint,2),size(BL_hip_setpoint,2)]);

nstart = round(2*n/3);

% Body parameters
db = 0.3;

% Leg parameters
d1 = 0.285; 
d2 = 0.035;
d3 = 0.04;
d4 = 0.03;
d5 = 0.25;
d6 = 0.05;
% Virtual leg parameters
l1 = 0.25;
l2 = 0.31694;
dF1 = l1/2;
dF2 = 0.1;
dF3 = 0.1;
dH1 = l1/2;
dH2 = 0.1;
dH3 = 0.1;
th2_offset = atan2(d2,d4+d1);
% Encoder and transmission parameters
count_no = 2000;
gear_ratio_hip = 637/12;
gear_ratio_knee = 343/8;
belt_ratio = 1.846153846;

% Motor angles (encoders data)
encFR1 = FR_hip_encoder(1:n);
encFR2 = FR_knee_encoder(1:n);
encHR1 = BR_hip_encoder(1:n);
encHR2 = BR_knee_encoder(1:n);
encFL1 = -FL_hip_encoder(1:n);
encFL2 = -FL_knee_encoder(1:n);
encHL1 = -BL_hip_encoder(1:n);
encHL2 = -BL_knee_encoder(1:n);

% Angles after transmission
thFR1 = encFR1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thFR2 = encFR2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;
thHR1 = encHR1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thHR2 = encHR2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;
thFL1 = encFL1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thFL2 = encFL2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;
thHL1 = encHL1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thHL2 = encHL2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;

% Desired motor angles
setpntFR1 = FR_hip_setpoint(1:n);
setpntFR2 = FR_knee_setpoint(1:n);
setpntHR1 = BR_hip_setpoint(1:n);
setpntHR2 = BR_knee_setpoint(1:n);
setpntFL1 = -FL_hip_setpoint(1:n);
setpntFL2 = -FL_knee_setpoint(1:n);
setpntHL1 = -BL_hip_setpoint(1:n);
setpntHL2 = -BL_knee_setpoint(1:n);

% Angles after transmission
thFR1_des = setpntFR1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thFR2_des = setpntFR2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;
thHR1_des = setpntHR1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thHR2_des = setpntHR2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;
thFL1_des = setpntFL1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thFL2_des = setpntFL2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;
thHL1_des = setpntHL1 *2*pi / (count_no*gear_ratio_hip * belt_ratio);
thHL2_des = setpntHL2 *2*pi / (count_no*gear_ratio_knee * belt_ratio)+th2_offset;

% Body coordinates (fixed)
xb = zeros(1,n);
yb = zeros(1,n);
thb = zeros(1,n);
% Springs length (fixed)
lFR = ones(1,n)*(l2-dF1-dF2);
lHR = ones(1,n)*(l2-dH1-dH2);
lFL = ones(1,n)*(l2-dF1-dF2);
lHL = ones(1,n)*(l2-dH1-dH2);


%-------------------------------------------------------------------------%
% Fore Right Leg Coordinates
%-------------------------------------------------------------------------%
% leg parameters
lFR1 = l1; 
lFR2 = l2; 
dFR2 = d2;
dFR3 = d3;
dFR4 = d4;
dFR6 = d6;
dFR1 = d1;
dFR10 = 0.4;
th2_offsetFR = th2_offset;
% Coords in robot's CS
x_knee1 = lFR1 * cos(thFR1);
y_knee1 = lFR1 * sin(thFR1);
x_foot1 = lFR1 * cos(thFR1) + lFR2 .* cos(thFR2);
y_foot1 = lFR1 * sin(thFR1) + lFR2 .* sin(thFR2);
x_1_temp = x_knee1 + dFR4 .* cos(thFR2-th2_offsetFR);
y_1_temp = y_knee1 + dFR4 .* sin(thFR2-th2_offsetFR);
x_2_temp = x_1_temp + dFR2 .* cos(thFR2-th2_offsetFR + pi/2);
y_2_temp = y_1_temp + dFR2 .* sin(thFR2-th2_offsetFR + pi/2);
x_3_temp = x_1_temp + dFR3 .* cos(thFR2-th2_offsetFR - pi/2);
y_3_temp = y_1_temp + dFR3 .* sin(thFR2-th2_offsetFR - pi/2);
x_4_temp = x_foot1 + dFR10 .* cos(thFR2-th2_offsetFR + pi);
y_4_temp = y_foot1 + dFR10 .* sin(thFR2-th2_offsetFR + pi);
x_5_temp = dFR6 * cos(thFR2-th2_offsetFR-atan2(dFR3,dFR4));
y_5_temp = dFR6 * sin(thFR2-th2_offsetFR-atan2(dFR3,dFR4));
% Convert to the classic CS
xForeRightHip=xb+db.*cos(thb);
yForeRightHip=yb+db.*sin(thb);
x_FR1 = xForeRightHip + y_1_temp;
y_FR1 = yForeRightHip  -x_1_temp;
x_FR2 = xForeRightHip + y_2_temp;
y_FR2 = yForeRightHip  -x_2_temp;
x_FR3 = xForeRightHip + y_3_temp;
y_FR3 = yForeRightHip  -x_3_temp;
x_FR4 = xForeRightHip + y_4_temp;
y_FR4 = yForeRightHip  -x_4_temp;
x_FR5 = xForeRightHip + y_5_temp;
y_FR5 = yForeRightHip  -x_5_temp;
x_FRknee = xForeRightHip + y_knee1;
y_FRknee = yForeRightHip  -x_knee1;
x_FRfoot = xForeRightHip + y_foot1;
y_FRfoot = yForeRightHip  -x_foot1;

%-------------------------------------------------------------------------%
% Desired Fore Right Foot Trajectory
%-------------------------------------------------------------------------%
% Coords in robot's CS
x_FRfoot1_des = lFR1 * cos(thFR1_des) + lFR2 .* cos(thFR2_des);
y_FRfoot1_des = lFR1 * sin(thFR1_des) + lFR2 .* sin(thFR2_des);
% Convert to the classic CS
x_FRfoot_des = xForeRightHip + y_FRfoot1_des;
y_FRfoot_des = yForeRightHip  -x_FRfoot1_des;


%-------------------------------------------------------------------------%
% Hind Right Leg Coordinates
%-------------------------------------------------------------------------%
% leg parameters
lHR1 = l1; 
lHR2 = l2; 
dHR2 = d2;
dHR3 = d3;
dHR4 = d4;
dHR6 = d6;
dHR1 = d1;
dHR10 = 0.4;
th2_offsetHR = th2_offset;
% Coords in robot's CS
x_knee1 = lHR1 * cos(thHR1);
y_knee1 = lHR1 * sin(thHR1);
x_foot1 = lHR1 * cos(thHR1) + lHR2 .* cos(thHR2);
y_foot1 = lHR1 * sin(thHR1) + lHR2 .* sin(thHR2);
x_1_temp = x_knee1 + dHR4 .* cos(thHR2-th2_offsetHR);
y_1_temp = y_knee1 + dHR4 .* sin(thHR2-th2_offsetHR);
x_2_temp = x_1_temp + dHR2 .* cos(thHR2-th2_offsetHR + pi/2);
y_2_temp = y_1_temp + dHR2 .* sin(thHR2-th2_offsetHR + pi/2);
x_3_temp = x_1_temp + dHR3 .* cos(thHR2-th2_offsetHR - pi/2);
y_3_temp = y_1_temp + dHR3 .* sin(thHR2-th2_offsetHR - pi/2);
x_4_temp = x_foot1 + dHR10 .* cos(thHR2-th2_offsetHR + pi);
y_4_temp = y_foot1 + dHR10 .* sin(thHR2-th2_offsetHR + pi);
x_5_temp = dHR6 * cos(thHR2-th2_offsetHR-atan2(dHR3,dHR4));
y_5_temp = dHR6 * sin(thHR2-th2_offsetHR-atan2(dHR3,dHR4));
% Convert to the classic CS
xHindRightHip=xb+(-1).*db.*cos(thb);
yHindRightHip=yb+(-1).*db.*sin(thb);
x_HR1 = xHindRightHip + y_1_temp;
y_HR1 = yHindRightHip  -x_1_temp;
x_HR2 = xHindRightHip + y_2_temp;
y_HR2 = yHindRightHip  -x_2_temp;
x_HR3 = xHindRightHip + y_3_temp;
y_HR3 = yHindRightHip  -x_3_temp;
x_HR4 = xHindRightHip + y_4_temp;
y_HR4 = yHindRightHip  -x_4_temp;
x_HR5 = xHindRightHip + y_5_temp;
y_HR5 = yHindRightHip  -x_5_temp;
x_HRknee = xHindRightHip + y_knee1;
y_HRknee = yHindRightHip  -x_knee1;
x_HRfoot = xHindRightHip + y_foot1;
y_HRfoot = yHindRightHip  -x_foot1;

%-------------------------------------------------------------------------%
% Desired Hind Right Foot Trajectory
%-------------------------------------------------------------------------%
% Coords in robot's CS
x_HRfoot1_des = lHR1 * cos(thHR1_des) + lHR2 .* cos(thHR2_des);
y_HRfoot1_des = lHR1 * sin(thHR1_des) + lHR2 .* sin(thHR2_des);
% Convert to the classic CS
x_HRfoot_des = xHindRightHip + y_HRfoot1_des;
y_HRfoot_des = yHindRightHip - x_HRfoot1_des;


%-------------------------------------------------------------------------%
% Fore Left Leg Coordinates
%-------------------------------------------------------------------------%
% leg parameters
lFL1 = l1; 
lFL2 = l2; 
dFL2 = d2;
dFL3 = d3;
dFL4 = d4;
dFL6 = d6;
dFL1 = d1;
dFL10 = 0.4;
th2_offsetFL = th2_offset;
% Coords in robot's CS
x_knee1 = lFL1 * cos(thFL1);
y_knee1 = lFL1 * sin(thFL1);
x_foot1 = lFL1 * cos(thFL1) + lFL2 .* cos(thFL2);
y_foot1 = lFL1 * sin(thFL1) + lFL2 .* sin(thFL2);
x_1_temp = x_knee1 + dFL4 .* cos(thFL2-th2_offsetFL);
y_1_temp = y_knee1 + dFL4 .* sin(thFL2-th2_offsetFL);
x_2_temp = x_1_temp + dFL2 .* cos(thFL2-th2_offsetFL + pi/2);
y_2_temp = y_1_temp + dFL2 .* sin(thFL2-th2_offsetFL + pi/2);
x_3_temp = x_1_temp + dFL3 .* cos(thFL2-th2_offsetFL - pi/2);
y_3_temp = y_1_temp + dFL3 .* sin(thFL2-th2_offsetFL - pi/2);
x_4_temp = x_foot1 + dFL10 .* cos(thFL2-th2_offsetFL + pi);
y_4_temp = y_foot1 + dFL10 .* sin(thFL2-th2_offsetFL + pi);
x_5_temp = dFL6 * cos(thFL2-th2_offsetFL-atan2(dFL3,dFL4));
y_5_temp = dFL6 * sin(thFL2-th2_offsetFL-atan2(dFL3,dFL4));
% Convert to the classic CS
xForeLeftHip=xb+db.*cos(thb);
yForeLeftHip=yb+db.*sin(thb);
x_FL1 = xForeLeftHip + y_1_temp;
y_FL1 = yForeLeftHip  -x_1_temp;
x_FL2 = xForeLeftHip + y_2_temp;
y_FL2 = yForeLeftHip  -x_2_temp;
x_FL3 = xForeLeftHip + y_3_temp;
y_FL3 = yForeLeftHip  -x_3_temp;
x_FL4 = xForeLeftHip + y_4_temp;
y_FL4 = yForeLeftHip  -x_4_temp;
x_FL5 = xForeLeftHip + y_5_temp;
y_FL5 = yForeLeftHip  -x_5_temp;
x_FLknee = xForeLeftHip + y_knee1;
y_FLknee = yForeLeftHip  -x_knee1;
x_FLfoot = xForeLeftHip + y_foot1;
y_FLfoot = yForeLeftHip  -x_foot1;

%-------------------------------------------------------------------------%
% Desired Fore Left Foot Trajectory
%-------------------------------------------------------------------------%
% Coords in robot's CS
x_FLfoot1_des = lFL1 * cos(thFL1_des) + lFL2 .* cos(thFL2_des);
y_FLfoot1_des = lFL1 * sin(thFL1_des) + lFL2 .* sin(thFL2_des);
% Convert to the classic CS
x_FLfoot_des = xForeLeftHip + y_FLfoot1_des;
y_FLfoot_des = yForeLeftHip - x_FLfoot1_des;


%-------------------------------------------------------------------------%
% Hind Left Leg Coordinates
%-------------------------------------------------------------------------%
% leg parameters
lHL1 = l1; 
lHL2 = l2; 
dHL2 = d2;
dHL3 = d3;
dHL4 = d4;
dHL6 = d6;
dHL1 = d1;
dHL10 = 0.4;
th2_offsetHL = th2_offset;
% Coords in robot's CS
x_knee1 = lHL1 * cos(thHL1);
y_knee1 = lHL1 * sin(thHL1);
x_foot1 = lHL1 * cos(thHL1) + lHL2 .* cos(thHL2);
y_foot1 = lHL1 * sin(thHL1) + lHL2 .* sin(thHL2);
x_1_temp = x_knee1 + dHL4 .* cos(thHL2-th2_offsetHL);
y_1_temp = y_knee1 + dHL4 .* sin(thHL2-th2_offsetHL);
x_2_temp = x_1_temp + dHL2 .* cos(thHL2-th2_offsetHL + pi/2);
y_2_temp = y_1_temp + dHL2 .* sin(thHL2-th2_offsetHL + pi/2);
x_3_temp = x_1_temp + dHL3 .* cos(thHL2-th2_offsetHL - pi/2);
y_3_temp = y_1_temp + dHL3 .* sin(thHL2-th2_offsetHL - pi/2);
x_4_temp = x_foot1 + dHL10 .* cos(thHL2-th2_offsetHL + pi);
y_4_temp = y_foot1 + dHL10 .* sin(thHL2-th2_offsetHL + pi);
x_5_temp = dHL6 * cos(thHL2-th2_offsetHL-atan2(dHL3,dHL4));
y_5_temp = dHL6 * sin(thHL2-th2_offsetHL-atan2(dHL3,dHL4));
% Convert to the classic CS
xHindLeftHip=xb+(-1).*db.*cos(thb);
yHindLeftHip=yb+(-1).*db.*sin(thb);
x_HL1 = xHindLeftHip + y_1_temp;
y_HL1 = yHindLeftHip  -x_1_temp;
x_HL2 = xHindLeftHip + y_2_temp;
y_HL2 = yHindLeftHip  -x_2_temp;
x_HL3 = xHindLeftHip + y_3_temp;
y_HL3 = yHindLeftHip  -x_3_temp;
x_HL4 = xHindLeftHip + y_4_temp;
y_HL4 = yHindLeftHip  -x_4_temp;
x_HL5 = xHindLeftHip + y_5_temp;
y_HL5 = yHindLeftHip  -x_5_temp;
x_HLknee = xHindLeftHip + y_knee1;
y_HLknee = yHindLeftHip  -x_knee1;
x_HLfoot = xHindLeftHip + y_foot1;
y_HLfoot = yHindLeftHip  -x_foot1;

%-------------------------------------------------------------------------%
% Desired Hind Left Foot Trajectory
%-------------------------------------------------------------------------%
% Coords in robot's CS
x_HLfoot1_des = lHL1 * cos(thHL1_des) + lHL2 .* cos(thHL2_des);
y_HLfoot1_des = lHL1 * sin(thHL1_des) + lHL2 .* sin(thHL2_des);
% Convert to the classic CS
x_HLfoot_des = xHindLeftHip + y_HLfoot1_des;
y_HLfoot_des = yHindLeftHip - x_HLfoot1_des;


%-------------------------------------------------------------------------%
% Animation Speed
%-------------------------------------------------------------------------%
step = 2000;


set(gcf, 'Position', [100 50 1000 400],'color','w');

%-------------------------------------------------------------------------%
% Animation Loop
%-------------------------------------------------------------------------%
for i = 1:step:n-1


    
%-------------------------------------------------------------------------%    
% FR Leg
%-------------------------------------------------------------------------%
subplot(2,2,1)    


% Plot desired foot trajectory
plot(x_FRfoot_des(1:n), y_FRfoot_des(1:n),'r')
hold on

% Plot actual foot trajectory
gray_tone = 0.6;
plot(x_FRfoot(nstart:n), y_FRfoot(nstart:n),'k', 'LineWidth',0.1)


% Plot Axis
axis equal
%axis([xForeRightHip(i)-0.6 xForeRightHip(i)+0.6 -0.8 0.4])
%axis([xForeRightHip(i)-0.3 xForeRightHip(i)+0.3 -0.65 0.10])
axis([xForeRightHip(i)-0.25 xForeRightHip(i)+0.25 -0.6 -0.4])
% grid on
title('FR Leg')
hold off
drawnow




%-------------------------------------------------------------------------%
% HR Leg
%-------------------------------------------------------------------------%
subplot(2,2,2)    
set(gcf,'color','w');

% Plot desired foot trajectory
plot(x_HRfoot_des(1:n), y_HRfoot_des(1:n),'r')
hold on

% Plot actual foot trajectory
plot(x_HRfoot(nstart:n), y_HRfoot(nstart:n),'k', 'LineWidth',0.1)


% Plot Axis
axis equal
%axis([xHindRightHip(i)-0.6 xHindRightHip(i)+0.6 -0.8 0.4])
%axis([xHindRightHip(i)-0.3 xHindRightHip(i)+0.3 -0.65 0.10])
axis([xHindRightHip(i)-0.25 xHindRightHip(i)+0.25 -0.6 -0.4])

% grid on
title('HR Leg')
hold off
drawnow



%-------------------------------------------------------------------------%
% FL Leg
%-------------------------------------------------------------------------%
subplot(2,2,3)    
set(gcf,'color','w');

% Plot desired foot trajectory
plot(x_FLfoot_des(1:n), y_FLfoot_des(1:n),'r')
hold on

% Plot actual foot trajectory
plot(x_FLfoot(nstart:n), y_FLfoot(nstart:n),'k', 'LineWidth',0.1)


% Plot Axis
axis equal
axis([xForeLeftHip(i)-0.25 xForeLeftHip(i)+0.25 -0.6 -0.4])

% grid on
title('FL Leg')
hold off
drawnow




%-------------------------------------------------------------------------%
% HL Leg
%-------------------------------------------------------------------------%
subplot(2,2,4)    
set(gcf,'color','w');

% Plot desired foot trajectory
plot(x_HLfoot_des(1:n), y_HLfoot_des(1:n),'r')
hold on

% Plot actual foot trajectory
plot(x_HLfoot(nstart:n), y_HLfoot(nstart:n),'k', 'LineWidth',0.1)


% Plot Axis
axis equal
%axis([xHindLeftHip(i)-0.6 xHindLeftHip(i)+0.6 -0.8 0.4])
%axis([xHindLeftHip(i)-0.3 xHindLeftHip(i)+0.3 -0.65 0.1])
axis([xHindLeftHip(i)-0.25 xHindLeftHip(i)+0.25 -0.6 -0.4])

% grid on
title('HL Leg')
hold off

drawnow
%pause()



end
tightfig;
