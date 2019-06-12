
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// 
// Program created by: Ruben Aldabo
// Date: 2019-06-10
// Source: http://www.udesantiagovirtual.cl/moodle2/mod/book/view.php?id=24918&chapterid=295
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

// Variables
O = 0;
Pstart = [0.9, -0.2];

l1 = 0.62;
l2 = 0.57;

g1 = 0.1;
g2 = 0.2;
g3 = 0.3;

function [j1, j2, j3] = caljoints(theta1, theta2)
    j1 = [0; 0];
    j2 = [l1*cos(theta1); l1*sin(theta1)];
    j3 = [l1*cos(theta1)+l2*cos(theta2+theta1); l1*sin(theta1)+l2*sin(theta2+theta1)];
endfunction

function [theta1, theta2, theta3] = calculateThetas(P, sigma)
    x = P(1);
    y = P(2);
    
    D = ( x^2 + y^2 - l1^2 - l2^2 ) / ( 2 * l1 * l2 );
    theta2 = atan(sqrt(1-D^2)/D);
    theta1 = atan(y/x)-atan((l2*sin(theta2))/(l1+(l2*cos(theta2))));

    theta3 = sigma - theta1 - theta2;
endfunction

function [t1, t2, t3] = getTool(P, angle)

    x1 = P(1)+(g1*cos(angle));
    y1 = P(2)+(g1*sin(angle));
    t1 = [x1; y1];

    x2 = x1+(g2*cos(-%pi/2));
    y2 = y1+(g2*sin(-%pi/2));
    t2 = [x2; y2];

    x3 = x2+(g3*cos(0));
    y3 = y2+(g3*sin(0));
    t3 = [x3; y3];
endfunction


// - - - - - - - - - - - - - - - - START PROGRAM - - - - - - - - - - - - - - - -
clc()

for i=0:0.1:5
    
    // Calculate angles and positions
    [theta1, theta2, theta3] = calculateThetas(Pstart, O);
    [j1, j2, j3] = caljoints(theta1, theta2);

    // Get the tool positions
    [t1, t2, t3] = getTool(j3, 0);

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // - - - - - - - - - - - PRINT USER INFO - - - - - - - - - - -
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    disp('');
    disp(i);
    disp('------');    
    disp(strcat(['Theta 1: ', string(theta1), ' radians (', string(theta1*(180/%pi)), ' degrees)']));
    disp(strcat(['Theta 2: ', string(theta2), ' radians (', string(theta2*(180/%pi)), ' degrees)']));
    disp(strcat(['Theta 3: ', string(theta3), ' radians (', string(theta3*(180/%pi)), ' degrees)']));

    disp('---------------------------------------------------');
    
    disp(strcat(['Joint 1 position: X-> ', string(j1(1)), ' Y-> ', string(j1(2))]));
    disp(strcat(['Joint 2 position: X-> ', string(j2(1)), ' Y-> ', string(j2(2))]));
    disp(strcat(['Joint 3 position: X-> ', string(j3(1)), ' Y-> ', string(j3(2))]));

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // - - - - - - - - - - - PRINT THE PLOT - - - - - - - - - - -
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    delete();
    x = [j1(1), j2(1), j3(1), t1(1), t2(1), t3(1)];
    y = [j1(2), j2(2), j3(2), t1(2), t2(2), t3(2)];
    plot(x, y);
    sleep(20);

    // Next step
    Pstart(2) = Pstart(2)-0.01;
end
