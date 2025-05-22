m = 0.506 ;
Ix = 8.12e-5 ;
Iy = 8.12e-5 ;
Iz = 6.12e-5  ;
kp = 5.28 ;
ki = 4.65;
kd = 3.4 ;

%% integral control varies proportional control in Kp
p = [0 1/m] ;
q = [1 0 0 0] ;
figure; rlocus(p,q)
%% pd control varies proportional control in K
v = [0 1/m]
r = [1 kd/m 0]
figure; rlocus(v,r)
%% pid control varies proportional control in Ki
s = [0 1/m]
t = [1 kd/m kp/m 0]
figure; rlocus(s,t)


%% 
kp2 = 5.46e-4
ki2 = 8.48e-4
kd2 = 7.47e-4
%% integral control varies proportional control in Kp
p2 = [0 1/Ix]
q2 = [1 0 0 0]
figure; rlocus(p2,q2)
%% pd control varies proportional control in K
v2 = [0 1/Ix]
r2 = [1 kd2/m 0]
figure; rlocus(v2,r2)
%% pid control varies proportional control in Ki
s2 = [0 1/Ix]
t2 = [1 kd2/Ix kp2/Ix 0]
figure; rlocus(s2,t2)

%%
kp3 = 4.11e-4
ki3 = 6.39e-4
kd3 = 5.63e-4
%% integral control varies proportional control in Kp
p3 = [0 1/Iz]
q3 = [1 0 0 0]
figure; rlocus(p3,q3)
%% pd control varies proportional control in K
v3 = [0 1/Iz]
r3 = [1 kd3/m 0]
figure; rlocus(v3,r3)
%% pid control varies proportional control in Ki
s3 = [0 1/Iz]
t3 = [1 kd3/Iz kp3/Iz 0]
figure; rlocus(s3,t3)

