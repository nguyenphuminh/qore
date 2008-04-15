#!/usr/bin/env qore

/**
 * (c) Copyright 1993, 1994, Silicon Graphics, Inc.
 * ALL RIGHTS RESERVED
 * Permission to use, copy, modify, and distribute this software for
 * any purpose and without fee is hereby granted, provided that the above
 * copyright notice appear in all copies and that both the copyright notice
 * and this permission notice appear in supporting documentation, and that
 * the name of Silicon Graphics, Inc. not be used in advertising
 * or publicity pertaining to distribution of the software without specific,
 * written prior permission.
 *
 * THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"
 * AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR
 * FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL SILICON
 * GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,
 * SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY
 * KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,
 * LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF
 * THIRD PARTIES, WHETHER OR NOT SILICON GRAPHICS, INC.  HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE
 * POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * US Government Users Restricted Rights
 * Use, duplication, or disclosure by the Government is subject to
 * restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
 * (c)(1)(ii) of the Rights in Technical Data and Computer Software
 * clause at DFARS 252.227-7013 and/or in similar or successor
 * clauses in the FAR or the DOD or NASA FAR Supplement.
 * Unpublished-- rights reserved under the copyright laws of the
 * United States.  Contractor/manufacturer is Silicon Graphics,
 * Inc., 2011 N.  Shoreline Blvd., Mountain View, CA 94039-7311.
 *
 * OpenGL(TM) is a trademark of Silicon Graphics, Inc.
 */

# ported to Qore by David Nichols, copyrights belong to original holders

%require-our

%requires opengl
%requires glut

const RAD = 57.295;
const RRAD = 0.01745;

const NUM_SHARKS = 4;
const SHARKSIZE = 6000;
const SHARKSPEED = 100.0;

const WHALESPEED = 250.0;

const N001 = (-0.005937 ,-0.101998 ,-0.994767);
const N002 = (0.936780 ,-0.200803 ,0.286569);
const N003 = (-0.233062 ,0.972058 ,0.028007);
const N005 = (0.898117 ,0.360171 ,0.252315);
const N006 = (-0.915437 ,0.348456 ,0.201378);
const N007 = (0.602263 ,-0.777527 ,0.180920);
const N008 = (-0.906912 ,-0.412015 ,0.088061);
const N012 = (0.884408 ,-0.429417 ,-0.182821);
const N013 = (0.921121 ,0.311084 ,-0.234016);
const N014 = (0.382635 ,0.877882 ,-0.287948);
const N015 = (-0.380046 ,0.888166 ,-0.258316);
const N016 = (-0.891515 ,0.392238 ,-0.226607);
const N017 = (-0.901419 ,-0.382002 ,-0.203763);
const N018 = (-0.367225 ,-0.911091 ,-0.187243);
const N019 = (0.339539 ,-0.924846 ,-0.171388);
const N020 = (0.914706 ,-0.378617 ,-0.141290);
const N021 = (0.950662 ,0.262713 ,-0.164994);
const N022 = (0.546359 ,0.801460 ,-0.243218);
const N023 = (-0.315796 ,0.917068 ,-0.243431);
const N024 = (-0.825687 ,0.532277 ,-0.186875);
const N025 = (-0.974763 ,-0.155232 ,-0.160435);
const N026 = (-0.560596 ,-0.816658 ,-0.137119);
const N027 = (0.380210 ,-0.910817 ,-0.160786);
const N028 = (0.923772 ,-0.358322 ,-0.135093);
const N029 = (0.951202 ,0.275053 ,-0.139859);
const N030 = (0.686099 ,0.702548 ,-0.188932);
const N031 = (-0.521865 ,0.826719 ,-0.210220);
const N032 = (-0.923820 ,0.346739 ,-0.162258);
const N033 = (-0.902095 ,-0.409995 ,-0.134646);
const N034 = (-0.509115 ,-0.848498 ,-0.144404);
const N035 = (0.456469 ,-0.880293 ,-0.129305);
const N036 = (0.873401 ,-0.475489 ,-0.105266);
const N037 = (0.970825 ,0.179861 ,-0.158584);
const N038 = (0.675609 ,0.714187 ,-0.183004);
const N039 = (-0.523574 ,0.830212 ,-0.191360);
const N040 = (-0.958895 ,0.230808 ,-0.165071);
const N041 = (-0.918285 ,-0.376803 ,-0.121542);
const N042 = (-0.622467 ,-0.774167 ,-0.114888);
const N043 = (0.404497 ,-0.908807 ,-0.102231);
const N044 = (0.930538 ,-0.365155 ,-0.027588);
const N045 = (0.921920 ,0.374157 ,-0.100345);
const N046 = (0.507346 ,0.860739 ,0.041562);
const N047 = (-0.394646 ,0.918815 ,-0.005730);
const N048 = (-0.925411 ,0.373024 ,-0.066837);
const N049 = (-0.945337 ,-0.322309 ,-0.049551);
const N050 = (-0.660437 ,-0.750557 ,-0.022072);
const N051 = (0.488835 ,-0.871950 ,-0.027261);
const N052 = (0.902599 ,-0.421397 ,0.087969);
const N053 = (0.938636 ,0.322606 ,0.122020);
const N054 = (0.484605 ,0.871078 ,0.079878);
const N055 = (-0.353607 ,0.931559 ,0.084619);
const N056 = (-0.867759 ,0.478564 ,0.134054);
const N057 = (-0.951583 ,-0.296030 ,0.082794);
const N058 = (-0.672355 ,-0.730209 ,0.121384);
const N059 = (0.528336 ,-0.842452 ,0.105525);
const N060 = (0.786913 ,-0.564760 ,0.248627);
const N062 = (0.622098 ,0.765230 ,0.165584);
const N063 = (-0.631711 ,0.767816 ,0.106773);
const N064 = (-0.687886 ,0.606351 ,0.398938);
const N065 = (-0.946327 ,-0.281623 ,0.158598);
const N066 = (-0.509549 ,-0.860437 ,0.002776);
const N067 = (0.462594 ,-0.876692 ,0.131977);
const N071 = (0.000000 ,1.000000 ,0.000000);
const N077 = (-0.880770 ,0.461448 ,0.106351);
const N078 = (-0.880770 ,0.461448 ,0.106351);
const N079 = (-0.880770 ,0.461448 ,0.106351);
const N080 = (-0.880770 ,0.461448 ,0.106351);
const N081 = (-0.571197 ,0.816173 ,0.087152);
const N082 = (-0.880770 ,0.461448 ,0.106351);
const N083 = (-0.571197 ,0.816173 ,0.087152);
const N084 = (-0.571197 ,0.816173 ,0.087152);
const N085 = (-0.880770 ,0.461448 ,0.106351);
const N086 = (-0.571197 ,0.816173 ,0.087152);
const N087 = (-0.880770 ,0.461448 ,0.106351);
const N088 = (-0.880770 ,0.461448 ,0.106351);
const N089 = (-0.880770 ,0.461448 ,0.106351);
const N090 = (-0.880770 ,0.461448 ,0.106351);
const N091 = (0.000000 ,1.000000 ,0.000000);
const N092 = (0.000000 ,1.000000 ,0.000000);
const N093 = (0.000000 ,1.000000 ,0.000000);
const N094 = (1.000000 ,0.000000 ,0.000000);
const N095 = (-1.000000 ,0.000000 ,0.000000);
const N097 = (-0.697296 ,0.702881 ,0.140491);
const N098 = (0.918864 ,0.340821 ,0.198819);
const N099 = (-0.932737 ,0.201195 ,0.299202);
const N100 = (0.029517 ,0.981679 ,0.188244);
const N102 = (0.813521 ,-0.204936 ,0.544229);
const N110 = (-0.781480 ,-0.384779 ,0.491155);
const N111 = (-0.722243 ,0.384927 ,0.574627);
const N112 = (-0.752278 ,0.502679 ,0.425901);
const N113 = (0.547257 ,0.367910 ,0.751766);
const N114 = (0.725949 ,-0.232568 ,0.647233);
const N115 = (-0.747182 ,-0.660786 ,0.071280);
const N116 = (0.931519 ,0.200748 ,0.303270);
const N117 = (-0.828928 ,0.313757 ,0.463071);
const N118 = (0.902554 ,-0.370967 ,0.218587);
const N119 = (-0.879257 ,-0.441851 ,0.177973);
const N120 = (0.642327 ,0.611901 ,0.461512);
const N121 = (0.964817 ,-0.202322 ,0.167910);
const N122 = (0.000000 ,1.000000 ,0.000000);

our $P001 = (5.68, -300.95, 1324.70);
our $P002 = (338.69, -219.63, 9677.03);
our $P003 = (12.18, 474.59, 9138.14);
our $P005 = (487.51, 198.05, 9350.78);
our $P006 = (-457.61, 68.74, 9427.85);
our $P007 = (156.52, -266.72, 10311.68);
our $P008 = (-185.56, -266.51, 10310.47);
our $P009 = (124.39, -261.46, 1942.34);
our $P010 = (-130.05, -261.46, 1946.03);
our $P011 = (141.07, -320.11, 1239.38);
our $P012 = (156.48, -360.12, 2073.41);
our $P013 = (162.00, -175.88, 2064.44);
our $P014 = (88.16, -87.72, 2064.02);
our $P015 = (-65.21, -96.13, 2064.02);
our $P016 = (-156.48, -180.96, 2064.44);
our $P017 = (-162.00, -368.93, 2082.39);
our $P018 = (-88.16, -439.22, 2082.39);
our $P019 = (65.21, -440.32, 2083.39);
our $P020 = (246.87, -356.02, 2576.95);
our $P021 = (253.17, -111.15, 2567.15);
our $P022 = (132.34, 51.41, 2559.84);
our $P023 = (-97.88, 40.44, 2567.15);
our $P024 = (-222.97, -117.49, 2567.15);
our $P025 = (-252.22, -371.53, 2569.92);
our $P026 = (-108.44, -518.19, 2586.75);
our $P027 = (97.88, -524.79, 2586.75);
our $P028 = (370.03, -421.19, 3419.70);
our $P029 = (351.15, -16.98, 3423.17);
our $P030 = (200.66, 248.46, 3430.37);
our $P031 = (-148.42, 235.02, 3417.91);
our $P032 = (-360.21, -30.27, 3416.84);
our $P033 = (-357.90, -414.89, 3407.04);
our $P034 = (-148.88, -631.35, 3409.90);
our $P035 = (156.38, -632.59, 3419.70);
our $P036 = (462.61, -469.21, 4431.51);
our $P037 = (466.60, 102.25, 4434.98);
our $P038 = (243.05, 474.34, 4562.02);
our $P039 = (-191.23, 474.40, 4554.42);
our $P040 = (-476.12, 111.05, 4451.11);
our $P041 = (-473.36, -470.74, 4444.78);
our $P042 = (-266.95, -748.41, 4447.78);
our $P043 = (211.14, -749.91, 4429.73);
our $P044 = (680.57, -370.27, 5943.46);
our $P045 = (834.01, 363.09, 6360.63);
our $P046 = (371.29, 804.51, 6486.26);
our $P047 = (-291.43, 797.22, 6494.28);
our $P048 = (-784.13, 370.75, 6378.01);
our $P049 = (-743.29, -325.82, 5943.46);
our $P050 = (-383.24, -804.77, 5943.46);
our $P051 = (283.47, -846.09, 5943.46);
const iP001 = (5.68, -300.95, 1324.70);
const iP009 = (124.39, -261.46, 1942.34);
const iP010 = (-130.05, -261.46, 1946.03);
const iP011 = (141.07, -320.11, 1239.38);
const iP012 = (156.48, -360.12, 2073.41);
const iP013 = (162.00, -175.88, 2064.44);
const iP014 = (88.16, -87.72, 2064.02);
const iP015 = (-65.21, -96.13, 2064.02);
const iP016 = (-156.48, -180.96, 2064.44);
const iP017 = (-162.00, -368.93, 2082.39);
const iP018 = (-88.16, -439.22, 2082.39);
const iP019 = (65.21, -440.32, 2083.39);
const iP020 = (246.87, -356.02, 2576.95);
const iP021 = (253.17, -111.15, 2567.15);
const iP022 = (132.34, 51.41, 2559.84);
const iP023 = (-97.88, 40.44, 2567.15);
const iP024 = (-222.97, -117.49, 2567.15);
const iP025 = (-252.22, -371.53, 2569.92);
const iP026 = (-108.44, -518.19, 2586.75);
const iP027 = (97.88, -524.79, 2586.75);
const iP028 = (370.03, -421.19, 3419.70);
const iP029 = (351.15, -16.98, 3423.17);
const iP030 = (200.66, 248.46, 3430.37);
const iP031 = (-148.42, 235.02, 3417.91);
const iP032 = (-360.21, -30.27, 3416.84);
const iP033 = (-357.90, -414.89, 3407.04);
const iP034 = (-148.88, -631.35, 3409.90);
const iP035 = (156.38, -632.59, 3419.70);
const iP036 = (462.61, -469.21, 4431.51);
const iP037 = (466.60, 102.25, 4434.98);
const iP038 = (243.05, 474.34, 4562.02);
const iP039 = (-191.23, 474.40, 4554.42);
const iP040 = (-476.12, 111.05, 4451.11);
const iP041 = (-473.36, -470.74, 4444.78);
const iP042 = (-266.95, -748.41, 4447.78);
const iP043 = (211.14, -749.91, 4429.73);
const iP044 = (680.57, -370.27, 5943.46);
const iP045 = (834.01, 363.09, 6360.63);
const iP046 = (371.29, 804.51, 6486.26);
const iP047 = (-291.43, 797.22, 6494.28);
const iP048 = (-784.13, 370.75, 6378.01);
const iP049 = (-743.29, -325.82, 5943.46);
const iP050 = (-383.24, -804.77, 5943.46);
const iP051 = (283.47, -846.09, 5943.46);
our $P052 = (599.09, -300.15, 7894.03);
our $P053 = (735.48, 306.26, 7911.92);
our $P054 = (246.22, 558.53, 8460.50);
our $P055 = (-230.41, 559.84, 8473.23);
our $P056 = (-698.66, 320.83, 7902.59);
our $P057 = (-643.29, -299.16, 7902.59);
our $P058 = (-341.47, -719.30, 7902.59);
our $P059 = (252.57, -756.12, 7902.59);
our $P060 = (458.39, -265.31, 9355.44);
our $P062 = (224.04, 338.75, 9450.30);
our $P063 = (-165.71, 341.04, 9462.35);
our $P064 = (-298.11, 110.13, 10180.37);
our $P065 = (-473.99, -219.71, 9355.44);
our $P066 = (-211.97, -479.87, 9355.44);
our $P067 = (192.86, -491.45, 9348.73);
our $P068 = (-136.29, -319.84, 1228.73);
our $P069 = (1111.17, -314.14, 1314.19);
our $P070 = (-1167.34, -321.61, 1319.45);
our $P071 = (1404.86, -306.66, 1235.45);
our $P072 = (-1409.73, -314.14, 1247.66);
our $P073 = (1254.01, -296.87, 1544.58);
our $P074 = (-1262.09, -291.70, 1504.26);
our $P075 = (965.71, -269.26, 1742.65);
our $P076 = (-900.97, -276.74, 1726.07);
const iP068 = (-136.29, -319.84, 1228.73);
const iP069 = (1111.17, -314.14, 1314.19);
const iP070 = (-1167.34, -321.61, 1319.45);
const iP071 = (1404.86, -306.66, 1235.45);
const iP072 = (-1409.73, -314.14, 1247.66);
const iP073 = (1254.01, -296.87, 1544.58);
const iP074 = (-1262.09, -291.70, 1504.26);
const iP075 = (965.71, -269.26, 1742.65);
const iP076 = (-900.97, -276.74, 1726.07);
our $P077 = (1058.00, -448.81, 8194.66);
our $P078 = (-1016.51, -456.43, 8190.62);
our $P079 = (-1515.96, -676.45, 7754.93);
our $P080 = (1856.75, -830.34, 7296.56);
our $P081 = (1472.16, -497.38, 7399.68);
our $P082 = (-1775.26, -829.51, 7298.46);
our $P083 = (911.09, -252.51, 7510.99);
our $P084 = (-1451.94, -495.62, 7384.30);
our $P085 = (1598.75, -669.26, 7769.90);
our $P086 = (-836.53, -250.08, 7463.25);
our $P087 = (722.87, -158.18, 8006.41);
our $P088 = (-688.86, -162.28, 7993.89);
our $P089 = (-626.92, -185.30, 8364.98);
our $P090 = (647.72, -189.46, 8354.99);
our $P091 = (0.00, 835.01, 5555.62);
our $P092 = (0.00, 1350.18, 5220.86);
our $P093 = (0.00, 1422.94, 5285.27);
our $P094 = (0.00, 1296.75, 5650.19);
our $P095 = (0.00, 795.63, 6493.88);
const iP091 = (0.00, 835.01, 5555.62);
const iP092 = (0.00, 1350.18, 5220.86);
const iP093 = (0.00, 1422.94, 5285.27);
const iP094 = (0.00, 1296.75, 5650.19);
const iP095 = (0.00, 795.63, 6493.88);
our $P097 = (-194.91, -357.14, 10313.32);
our $P098 = (135.35, -357.66, 10307.94);
const iP097 = (-194.91, -357.14, 10313.32);
const iP098 = (135.35, -357.66, 10307.94);
our $P099 = (-380.53, -221.14, 9677.98);
our $P100 = (0.00, 412.99, 9629.33);
our $P102 = (59.51, -412.55, 10677.58);
const iP102 = (59.51, -412.55, 10677.58);
our $P103 = (6.50, 484.74, 9009.94);
our $P105 = (-41.86, 476.51, 9078.17);
our $P108 = (49.20, 476.83, 9078.24);
our $P110 = (-187.62, -410.04, 10674.12);
const iP110 = (-187.62, -410.04, 10674.12);
our $P111 = (-184.25, -318.70, 10723.88);
const iP111 = (-184.25, -318.70, 10723.88);
our $P112 = (-179.61, -142.81, 10670.26);
our $P113 = (57.43, -147.94, 10675.26);
our $P114 = (54.06, -218.90, 10712.44);
our $P115 = (-186.35, -212.09, 10713.76);
our $P116 = (205.90, -84.61, 10275.97);
our $P117 = (-230.96, -83.26, 10280.09);
const iP118 = (216.78, -509.17, 10098.94);
const iP119 = (-313.21, -510.79, 10102.62);
our $P118 = (216.78, -509.17, 10098.94);
our $P119 = (-313.21, -510.79, 10102.62);
our $P120 = (217.95, 96.34, 10161.62);
our $P121 = (71.99, -319.74, 10717.70);
const iP121 = (71.99, -319.74, 10717.70);
our $P122 = (0.00, 602.74, 5375.84);
const iP122 = (0.00, 602.74, 5375.84);
our $P123 = (-448.94, -203.14, 9499.60);
our $P124 = (-442.64, -185.20, 9528.07);
our $P125 = (-441.07, -148.05, 9528.07);
our $P126 = (-443.43, -128.84, 9499.60);
our $P127 = (-456.87, -146.78, 9466.67);
our $P128 = (-453.68, -183.93, 9466.67);
our $P129 = (428.43, -124.08, 9503.03);
our $P130 = (419.73, -142.14, 9534.56);
our $P131 = (419.92, -179.96, 9534.56);
our $P132 = (431.20, -199.73, 9505.26);
our $P133 = (442.28, -181.67, 9475.96);
our $P134 = (442.08, -143.84, 9475.96);

sub 
Dolphin001()
{
    glNormal3fv(N071);
    glBegin(GL_POLYGON);
    glVertex3fv($P001);
    glVertex3fv($P068);
    glVertex3fv($P010);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P068);
    glVertex3fv($P076);
    glVertex3fv($P010);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P068);
    glVertex3fv($P070);
    glVertex3fv($P076);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P076);
    glVertex3fv($P070);
    glVertex3fv($P074);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P070);
    glVertex3fv($P072);
    glVertex3fv($P074);
    glEnd();
    glNormal3fv(N119);
    glBegin(GL_POLYGON);
    glVertex3fv($P072);
    glVertex3fv($P070);
    glVertex3fv($P074);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P074);
    glVertex3fv($P070);
    glVertex3fv($P076);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P070);
    glVertex3fv($P068);
    glVertex3fv($P076);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P076);
    glVertex3fv($P068);
    glVertex3fv($P010);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P068);
    glVertex3fv($P001);
    glVertex3fv($P010);
    glEnd();
}

sub 
Dolphin002()
{
    glNormal3fv(N071);
    glBegin(GL_POLYGON);
    glVertex3fv($P011);
    glVertex3fv($P001);
    glVertex3fv($P009);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P075);
    glVertex3fv($P011);
    glVertex3fv($P009);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P069);
    glVertex3fv($P011);
    glVertex3fv($P075);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P069);
    glVertex3fv($P075);
    glVertex3fv($P073);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P071);
    glVertex3fv($P069);
    glVertex3fv($P073);
    glEnd();
    glNormal3fv(N119);
    glBegin(GL_POLYGON);
    glVertex3fv($P001);
    glVertex3fv($P011);
    glVertex3fv($P009);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P009);
    glVertex3fv($P011);
    glVertex3fv($P075);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P011);
    glVertex3fv($P069);
    glVertex3fv($P075);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P069);
    glVertex3fv($P073);
    glVertex3fv($P075);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P069);
    glVertex3fv($P071);
    glVertex3fv($P073);
    glEnd();
}

sub 
Dolphin003()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N018);
    glVertex3fv($P018);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N019);
    glVertex3fv($P019);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N019);
    glVertex3fv($P019);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N012);
    glVertex3fv($P012);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N017);
    glVertex3fv($P017);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N018);
    glVertex3fv($P018);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N017);
    glVertex3fv($P017);
    glNormal3fv(N016);
    glVertex3fv($P016);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N013);
    glVertex3fv($P013);
    glNormal3fv(N012);
    glVertex3fv($P012);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N016);
    glVertex3fv($P016);
    glNormal3fv(N015);
    glVertex3fv($P015);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N014);
    glVertex3fv($P014);
    glNormal3fv(N013);
    glVertex3fv($P013);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N001);
    glVertex3fv($P001);
    glNormal3fv(N015);
    glVertex3fv($P015);
    glNormal3fv(N014);
    glVertex3fv($P014);
    glEnd();
}

sub 
Dolphin004()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N014);
    glVertex3fv($P014);
    glNormal3fv(N015);
    glVertex3fv($P015);
    glNormal3fv(N023);
    glVertex3fv($P023);
    glNormal3fv(N022);
    glVertex3fv($P022);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N015);
    glVertex3fv($P015);
    glNormal3fv(N016);
    glVertex3fv($P016);
    glNormal3fv(N024);
    glVertex3fv($P024);
    glNormal3fv(N023);
    glVertex3fv($P023);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N016);
    glVertex3fv($P016);
    glNormal3fv(N017);
    glVertex3fv($P017);
    glNormal3fv(N025);
    glVertex3fv($P025);
    glNormal3fv(N024);
    glVertex3fv($P024);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N017);
    glVertex3fv($P017);
    glNormal3fv(N018);
    glVertex3fv($P018);
    glNormal3fv(N026);
    glVertex3fv($P026);
    glNormal3fv(N025);
    glVertex3fv($P025);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N013);
    glVertex3fv($P013);
    glNormal3fv(N014);
    glVertex3fv($P014);
    glNormal3fv(N022);
    glVertex3fv($P022);
    glNormal3fv(N021);
    glVertex3fv($P021);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N012);
    glVertex3fv($P012);
    glNormal3fv(N013);
    glVertex3fv($P013);
    glNormal3fv(N021);
    glVertex3fv($P021);
    glNormal3fv(N020);
    glVertex3fv($P020);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N018);
    glVertex3fv($P018);
    glNormal3fv(N019);
    glVertex3fv($P019);
    glNormal3fv(N027);
    glVertex3fv($P027);
    glNormal3fv(N026);
    glVertex3fv($P026);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N019);
    glVertex3fv($P019);
    glNormal3fv(N012);
    glVertex3fv($P012);
    glNormal3fv(N020);
    glVertex3fv($P020);
    glNormal3fv(N027);
    glVertex3fv($P027);
    glEnd();
}

sub 
Dolphin005()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N022);
    glVertex3fv($P022);
    glNormal3fv(N023);
    glVertex3fv($P023);
    glNormal3fv(N031);
    glVertex3fv($P031);
    glNormal3fv(N030);
    glVertex3fv($P030);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N021);
    glVertex3fv($P021);
    glNormal3fv(N022);
    glVertex3fv($P022);
    glNormal3fv(N030);
    glVertex3fv($P030);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N021);
    glVertex3fv($P021);
    glNormal3fv(N030);
    glVertex3fv($P030);
    glNormal3fv(N029);
    glVertex3fv($P029);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N023);
    glVertex3fv($P023);
    glNormal3fv(N024);
    glVertex3fv($P024);
    glNormal3fv(N031);
    glVertex3fv($P031);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N024);
    glVertex3fv($P024);
    glNormal3fv(N032);
    glVertex3fv($P032);
    glNormal3fv(N031);
    glVertex3fv($P031);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N024);
    glVertex3fv($P024);
    glNormal3fv(N025);
    glVertex3fv($P025);
    glNormal3fv(N032);
    glVertex3fv($P032);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N025);
    glVertex3fv($P025);
    glNormal3fv(N033);
    glVertex3fv($P033);
    glNormal3fv(N032);
    glVertex3fv($P032);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N020);
    glVertex3fv($P020);
    glNormal3fv(N021);
    glVertex3fv($P021);
    glNormal3fv(N029);
    glVertex3fv($P029);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N020);
    glVertex3fv($P020);
    glNormal3fv(N029);
    glVertex3fv($P029);
    glNormal3fv(N028);
    glVertex3fv($P028);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N027);
    glVertex3fv($P027);
    glNormal3fv(N020);
    glVertex3fv($P020);
    glNormal3fv(N028);
    glVertex3fv($P028);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N027);
    glVertex3fv($P027);
    glNormal3fv(N028);
    glVertex3fv($P028);
    glNormal3fv(N035);
    glVertex3fv($P035);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N025);
    glVertex3fv($P025);
    glNormal3fv(N026);
    glVertex3fv($P026);
    glNormal3fv(N033);
    glVertex3fv($P033);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N033);
    glVertex3fv($P033);
    glNormal3fv(N026);
    glVertex3fv($P026);
    glNormal3fv(N034);
    glVertex3fv($P034);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N026);
    glVertex3fv($P026);
    glNormal3fv(N027);
    glVertex3fv($P027);
    glNormal3fv(N035);
    glVertex3fv($P035);
    glNormal3fv(N034);
    glVertex3fv($P034);
    glEnd();
}

sub 
Dolphin006()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N092);
    glVertex3fv($P092);
    glNormal3fv(N093);
    glVertex3fv($P093);
    glNormal3fv(N094);
    glVertex3fv($P094);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N093);
    glVertex3fv($P093);
    glNormal3fv(N092);
    glVertex3fv($P092);
    glNormal3fv(N094);
    glVertex3fv($P094);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N092);
    glVertex3fv($P092);
    glNormal3fv(N091);
    glVertex3fv($P091);
    glNormal3fv(N095);
    glVertex3fv($P095);
    glNormal3fv(N094);
    glVertex3fv($P094);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N091);
    glVertex3fv($P091);
    glNormal3fv(N092);
    glVertex3fv($P092);
    glNormal3fv(N094);
    glVertex3fv($P094);
    glNormal3fv(N095);
    glVertex3fv($P095);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N122);
    glVertex3fv($P122);
    glNormal3fv(N095);
    glVertex3fv($P095);
    glNormal3fv(N091);
    glVertex3fv($P091);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N122);
    glVertex3fv($P122);
    glNormal3fv(N091);
    glVertex3fv($P091);
    glNormal3fv(N095);
    glVertex3fv($P095);
    glEnd();
}

sub 
Dolphin007()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N030);
    glVertex3fv($P030);
    glNormal3fv(N031);
    glVertex3fv($P031);
    glNormal3fv(N039);
    glVertex3fv($P039);
    glNormal3fv(N038);
    glVertex3fv($P038);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N029);
    glVertex3fv($P029);
    glNormal3fv(N030);
    glVertex3fv($P030);
    glNormal3fv(N038);
    glVertex3fv($P038);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N029);
    glVertex3fv($P029);
    glNormal3fv(N038);
    glVertex3fv($P038);
    glNormal3fv(N037);
    glVertex3fv($P037);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N028);
    glVertex3fv($P028);
    glNormal3fv(N029);
    glVertex3fv($P029);
    glNormal3fv(N037);
    glVertex3fv($P037);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N028);
    glVertex3fv($P028);
    glNormal3fv(N037);
    glVertex3fv($P037);
    glNormal3fv(N036);
    glVertex3fv($P036);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N035);
    glVertex3fv($P035);
    glNormal3fv(N028);
    glVertex3fv($P028);
    glNormal3fv(N036);
    glVertex3fv($P036);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N035);
    glVertex3fv($P035);
    glNormal3fv(N036);
    glVertex3fv($P036);
    glNormal3fv(N043);
    glVertex3fv($P043);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N034);
    glVertex3fv($P034);
    glNormal3fv(N035);
    glVertex3fv($P035);
    glNormal3fv(N043);
    glVertex3fv($P043);
    glNormal3fv(N042);
    glVertex3fv($P042);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N033);
    glVertex3fv($P033);
    glNormal3fv(N034);
    glVertex3fv($P034);
    glNormal3fv(N042);
    glVertex3fv($P042);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N033);
    glVertex3fv($P033);
    glNormal3fv(N042);
    glVertex3fv($P042);
    glNormal3fv(N041);
    glVertex3fv($P041);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N031);
    glVertex3fv($P031);
    glNormal3fv(N032);
    glVertex3fv($P032);
    glNormal3fv(N039);
    glVertex3fv($P039);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N039);
    glVertex3fv($P039);
    glNormal3fv(N032);
    glVertex3fv($P032);
    glNormal3fv(N040);
    glVertex3fv($P040);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N032);
    glVertex3fv($P032);
    glNormal3fv(N033);
    glVertex3fv($P033);
    glNormal3fv(N040);
    glVertex3fv($P040);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N040);
    glVertex3fv($P040);
    glNormal3fv(N033);
    glVertex3fv($P033);
    glNormal3fv(N041);
    glVertex3fv($P041);
    glEnd();
}

sub 
Dolphin008()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N042);
    glVertex3fv($P042);
    glNormal3fv(N043);
    glVertex3fv($P043);
    glNormal3fv(N051);
    glVertex3fv($P051);
    glNormal3fv(N050);
    glVertex3fv($P050);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N043);
    glVertex3fv($P043);
    glNormal3fv(N036);
    glVertex3fv($P036);
    glNormal3fv(N051);
    glVertex3fv($P051);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N051);
    glVertex3fv($P051);
    glNormal3fv(N036);
    glVertex3fv($P036);
    glNormal3fv(N044);
    glVertex3fv($P044);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N041);
    glVertex3fv($P041);
    glNormal3fv(N042);
    glVertex3fv($P042);
    glNormal3fv(N050);
    glVertex3fv($P050);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N041);
    glVertex3fv($P041);
    glNormal3fv(N050);
    glVertex3fv($P050);
    glNormal3fv(N049);
    glVertex3fv($P049);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N036);
    glVertex3fv($P036);
    glNormal3fv(N037);
    glVertex3fv($P037);
    glNormal3fv(N044);
    glVertex3fv($P044);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N044);
    glVertex3fv($P044);
    glNormal3fv(N037);
    glVertex3fv($P037);
    glNormal3fv(N045);
    glVertex3fv($P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N040);
    glVertex3fv($P040);
    glNormal3fv(N041);
    glVertex3fv($P041);
    glNormal3fv(N049);
    glVertex3fv($P049);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N040);
    glVertex3fv($P040);
    glNormal3fv(N049);
    glVertex3fv($P049);
    glNormal3fv(N048);
    glVertex3fv($P048);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N039);
    glVertex3fv($P039);
    glNormal3fv(N040);
    glVertex3fv($P040);
    glNormal3fv(N048);
    glVertex3fv($P048);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N039);
    glVertex3fv($P039);
    glNormal3fv(N048);
    glVertex3fv($P048);
    glNormal3fv(N047);
    glVertex3fv($P047);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N037);
    glVertex3fv($P037);
    glNormal3fv(N038);
    glVertex3fv($P038);
    glNormal3fv(N045);
    glVertex3fv($P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N038);
    glVertex3fv($P038);
    glNormal3fv(N046);
    glVertex3fv($P046);
    glNormal3fv(N045);
    glVertex3fv($P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N038);
    glVertex3fv($P038);
    glNormal3fv(N039);
    glVertex3fv($P039);
    glNormal3fv(N047);
    glVertex3fv($P047);
    glNormal3fv(N046);
    glVertex3fv($P046);
    glEnd();
}

sub 
Dolphin009()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N050);
    glVertex3fv($P050);
    glNormal3fv(N051);
    glVertex3fv($P051);
    glNormal3fv(N059);
    glVertex3fv($P059);
    glNormal3fv(N058);
    glVertex3fv($P058);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N051);
    glVertex3fv($P051);
    glNormal3fv(N044);
    glVertex3fv($P044);
    glNormal3fv(N059);
    glVertex3fv($P059);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N059);
    glVertex3fv($P059);
    glNormal3fv(N044);
    glVertex3fv($P044);
    glNormal3fv(N052);
    glVertex3fv($P052);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N044);
    glVertex3fv($P044);
    glNormal3fv(N045);
    glVertex3fv($P045);
    glNormal3fv(N053);
    glVertex3fv($P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N044);
    glVertex3fv($P044);
    glNormal3fv(N053);
    glVertex3fv($P053);
    glNormal3fv(N052);
    glVertex3fv($P052);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N049);
    glVertex3fv($P049);
    glNormal3fv(N050);
    glVertex3fv($P050);
    glNormal3fv(N058);
    glVertex3fv($P058);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N049);
    glVertex3fv($P049);
    glNormal3fv(N058);
    glVertex3fv($P058);
    glNormal3fv(N057);
    glVertex3fv($P057);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N048);
    glVertex3fv($P048);
    glNormal3fv(N049);
    glVertex3fv($P049);
    glNormal3fv(N057);
    glVertex3fv($P057);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N048);
    glVertex3fv($P048);
    glNormal3fv(N057);
    glVertex3fv($P057);
    glNormal3fv(N056);
    glVertex3fv($P056);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N047);
    glVertex3fv($P047);
    glNormal3fv(N048);
    glVertex3fv($P048);
    glNormal3fv(N056);
    glVertex3fv($P056);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N047);
    glVertex3fv($P047);
    glNormal3fv(N056);
    glVertex3fv($P056);
    glNormal3fv(N055);
    glVertex3fv($P055);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N045);
    glVertex3fv($P045);
    glNormal3fv(N046);
    glVertex3fv($P046);
    glNormal3fv(N053);
    glVertex3fv($P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N046);
    glVertex3fv($P046);
    glNormal3fv(N054);
    glVertex3fv($P054);
    glNormal3fv(N053);
    glVertex3fv($P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N046);
    glVertex3fv($P046);
    glNormal3fv(N047);
    glVertex3fv($P047);
    glNormal3fv(N055);
    glVertex3fv($P055);
    glNormal3fv(N054);
    glVertex3fv($P054);
    glEnd();
}

sub 
Dolphin010()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N080);
    glVertex3fv($P080);
    glNormal3fv(N081);
    glVertex3fv($P081);
    glNormal3fv(N085);
    glVertex3fv($P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N081);
    glVertex3fv($P081);
    glNormal3fv(N083);
    glVertex3fv($P083);
    glNormal3fv(N085);
    glVertex3fv($P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N085);
    glVertex3fv($P085);
    glNormal3fv(N083);
    glVertex3fv($P083);
    glNormal3fv(N077);
    glVertex3fv($P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N083);
    glVertex3fv($P083);
    glNormal3fv(N087);
    glVertex3fv($P087);
    glNormal3fv(N077);
    glVertex3fv($P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N077);
    glVertex3fv($P077);
    glNormal3fv(N087);
    glVertex3fv($P087);
    glNormal3fv(N090);
    glVertex3fv($P090);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N081);
    glVertex3fv($P081);
    glNormal3fv(N080);
    glVertex3fv($P080);
    glNormal3fv(N085);
    glVertex3fv($P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N083);
    glVertex3fv($P083);
    glNormal3fv(N081);
    glVertex3fv($P081);
    glNormal3fv(N085);
    glVertex3fv($P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N083);
    glVertex3fv($P083);
    glNormal3fv(N085);
    glVertex3fv($P085);
    glNormal3fv(N077);
    glVertex3fv($P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N087);
    glVertex3fv($P087);
    glNormal3fv(N083);
    glVertex3fv($P083);
    glNormal3fv(N077);
    glVertex3fv($P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N087);
    glVertex3fv($P087);
    glNormal3fv(N077);
    glVertex3fv($P077);
    glNormal3fv(N090);
    glVertex3fv($P090);
    glEnd();
}

sub 
Dolphin011()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N082);
    glVertex3fv($P082);
    glNormal3fv(N084);
    glVertex3fv($P084);
    glNormal3fv(N079);
    glVertex3fv($P079);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N084);
    glVertex3fv($P084);
    glNormal3fv(N086);
    glVertex3fv($P086);
    glNormal3fv(N079);
    glVertex3fv($P079);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N079);
    glVertex3fv($P079);
    glNormal3fv(N086);
    glVertex3fv($P086);
    glNormal3fv(N078);
    glVertex3fv($P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N086);
    glVertex3fv($P086);
    glNormal3fv(N088);
    glVertex3fv($P088);
    glNormal3fv(N078);
    glVertex3fv($P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N078);
    glVertex3fv($P078);
    glNormal3fv(N088);
    glVertex3fv($P088);
    glNormal3fv(N089);
    glVertex3fv($P089);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N088);
    glVertex3fv($P088);
    glNormal3fv(N086);
    glVertex3fv($P086);
    glNormal3fv(N089);
    glVertex3fv($P089);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N089);
    glVertex3fv($P089);
    glNormal3fv(N086);
    glVertex3fv($P086);
    glNormal3fv(N078);
    glVertex3fv($P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N086);
    glVertex3fv($P086);
    glNormal3fv(N084);
    glVertex3fv($P084);
    glNormal3fv(N078);
    glVertex3fv($P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N078);
    glVertex3fv($P078);
    glNormal3fv(N084);
    glVertex3fv($P084);
    glNormal3fv(N079);
    glVertex3fv($P079);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N084);
    glVertex3fv($P084);
    glNormal3fv(N082);
    glVertex3fv($P082);
    glNormal3fv(N079);
    glVertex3fv($P079);
    glEnd();
}

sub 
Dolphin012()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N058);
    glVertex3fv($P058);
    glNormal3fv(N059);
    glVertex3fv($P059);
    glNormal3fv(N067);
    glVertex3fv($P067);
    glNormal3fv(N066);
    glVertex3fv($P066);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N059);
    glVertex3fv($P059);
    glNormal3fv(N052);
    glVertex3fv($P052);
    glNormal3fv(N060);
    glVertex3fv($P060);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N059);
    glVertex3fv($P059);
    glNormal3fv(N060);
    glVertex3fv($P060);
    glNormal3fv(N067);
    glVertex3fv($P067);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N058);
    glVertex3fv($P058);
    glNormal3fv(N066);
    glVertex3fv($P066);
    glNormal3fv(N065);
    glVertex3fv($P065);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N058);
    glVertex3fv($P058);
    glNormal3fv(N065);
    glVertex3fv($P065);
    glNormal3fv(N057);
    glVertex3fv($P057);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N056);
    glVertex3fv($P056);
    glNormal3fv(N057);
    glVertex3fv($P057);
    glNormal3fv(N065);
    glVertex3fv($P065);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N056);
    glVertex3fv($P056);
    glNormal3fv(N065);
    glVertex3fv($P065);
    glNormal3fv(N006);
    glVertex3fv($P006);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N056);
    glVertex3fv($P056);
    glNormal3fv(N006);
    glVertex3fv($P006);
    glNormal3fv(N063);
    glVertex3fv($P063);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N056);
    glVertex3fv($P056);
    glNormal3fv(N063);
    glVertex3fv($P063);
    glNormal3fv(N055);
    glVertex3fv($P055);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N054);
    glVertex3fv($P054);
    glNormal3fv(N062);
    glVertex3fv($P062);
    glNormal3fv(N005);
    glVertex3fv($P005);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N054);
    glVertex3fv($P054);
    glNormal3fv(N005);
    glVertex3fv($P005);
    glNormal3fv(N053);
    glVertex3fv($P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N052);
    glVertex3fv($P052);
    glNormal3fv(N053);
    glVertex3fv($P053);
    glNormal3fv(N005);
    glVertex3fv($P005);
    glNormal3fv(N060);
    glVertex3fv($P060);
    glEnd();
}

sub 
Dolphin013()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N116);
    glVertex3fv($P116);
    glNormal3fv(N117);
    glVertex3fv($P117);
    glNormal3fv(N112);
    glVertex3fv($P112);
    glNormal3fv(N113);
    glVertex3fv($P113);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N114);
    glVertex3fv($P114);
    glNormal3fv(N113);
    glVertex3fv($P113);
    glNormal3fv(N112);
    glVertex3fv($P112);
    glNormal3fv(N115);
    glVertex3fv($P115);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N114);
    glVertex3fv($P114);
    glNormal3fv(N116);
    glVertex3fv($P116);
    glNormal3fv(N113);
    glVertex3fv($P113);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N114);
    glVertex3fv($P114);
    glNormal3fv(N007);
    glVertex3fv($P007);
    glNormal3fv(N116);
    glVertex3fv($P116);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N007);
    glVertex3fv($P007);
    glNormal3fv(N002);
    glVertex3fv($P002);
    glNormal3fv(N116);
    glVertex3fv($P116);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P002);
    glVertex3fv($P007);
    glVertex3fv($P008);
    glVertex3fv($P099);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P007);
    glVertex3fv($P114);
    glVertex3fv($P115);
    glVertex3fv($P008);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N117);
    glVertex3fv($P117);
    glNormal3fv(N099);
    glVertex3fv($P099);
    glNormal3fv(N008);
    glVertex3fv($P008);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N117);
    glVertex3fv($P117);
    glNormal3fv(N008);
    glVertex3fv($P008);
    glNormal3fv(N112);
    glVertex3fv($P112);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N112);
    glVertex3fv($P112);
    glNormal3fv(N008);
    glVertex3fv($P008);
    glNormal3fv(N115);
    glVertex3fv($P115);
    glEnd();
}

sub 
Dolphin014()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N111);
    glVertex3fv($P111);
    glNormal3fv(N110);
    glVertex3fv($P110);
    glNormal3fv(N102);
    glVertex3fv($P102);
    glNormal3fv(N121);
    glVertex3fv($P121);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N111);
    glVertex3fv($P111);
    glNormal3fv(N097);
    glVertex3fv($P097);
    glNormal3fv(N110);
    glVertex3fv($P110);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N097);
    glVertex3fv($P097);
    glNormal3fv(N119);
    glVertex3fv($P119);
    glNormal3fv(N110);
    glVertex3fv($P110);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N097);
    glVertex3fv($P097);
    glNormal3fv(N099);
    glVertex3fv($P099);
    glNormal3fv(N119);
    glVertex3fv($P119);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N099);
    glVertex3fv($P099);
    glNormal3fv(N065);
    glVertex3fv($P065);
    glNormal3fv(N119);
    glVertex3fv($P119);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N065);
    glVertex3fv($P065);
    glNormal3fv(N066);
    glVertex3fv($P066);
    glNormal3fv(N119);
    glVertex3fv($P119);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P098);
    glVertex3fv($P097);
    glVertex3fv($P111);
    glVertex3fv($P121);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P002);
    glVertex3fv($P099);
    glVertex3fv($P097);
    glVertex3fv($P098);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N110);
    glVertex3fv($P110);
    glNormal3fv(N119);
    glVertex3fv($P119);
    glNormal3fv(N118);
    glVertex3fv($P118);
    glNormal3fv(N102);
    glVertex3fv($P102);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N119);
    glVertex3fv($P119);
    glNormal3fv(N066);
    glVertex3fv($P066);
    glNormal3fv(N067);
    glVertex3fv($P067);
    glNormal3fv(N118);
    glVertex3fv($P118);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N067);
    glVertex3fv($P067);
    glNormal3fv(N060);
    glVertex3fv($P060);
    glNormal3fv(N002);
    glVertex3fv($P002);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N067);
    glVertex3fv($P067);
    glNormal3fv(N002);
    glVertex3fv($P002);
    glNormal3fv(N118);
    glVertex3fv($P118);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N118);
    glVertex3fv($P118);
    glNormal3fv(N002);
    glVertex3fv($P002);
    glNormal3fv(N098);
    glVertex3fv($P098);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N118);
    glVertex3fv($P118);
    glNormal3fv(N098);
    glVertex3fv($P098);
    glNormal3fv(N102);
    glVertex3fv($P102);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N102);
    glVertex3fv($P102);
    glNormal3fv(N098);
    glVertex3fv($P098);
    glNormal3fv(N121);
    glVertex3fv($P121);
    glEnd();
}

sub 
Dolphin015()
{
    glBegin(GL_POLYGON);
    glNormal3fv(N055);
    glVertex3fv($P055);
    glNormal3fv(N003);
    glVertex3fv($P003);
    glNormal3fv(N054);
    glVertex3fv($P054);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N003);
    glVertex3fv($P003);
    glNormal3fv(N055);
    glVertex3fv($P055);
    glNormal3fv(N063);
    glVertex3fv($P063);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N003);
    glVertex3fv($P003);
    glNormal3fv(N063);
    glVertex3fv($P063);
    glNormal3fv(N100);
    glVertex3fv($P100);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N003);
    glVertex3fv($P003);
    glNormal3fv(N100);
    glVertex3fv($P100);
    glNormal3fv(N054);
    glVertex3fv($P054);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N054);
    glVertex3fv($P054);
    glNormal3fv(N100);
    glVertex3fv($P100);
    glNormal3fv(N062);
    glVertex3fv($P062);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N100);
    glVertex3fv($P100);
    glNormal3fv(N064);
    glVertex3fv($P064);
    glNormal3fv(N120);
    glVertex3fv($P120);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N100);
    glVertex3fv($P100);
    glNormal3fv(N063);
    glVertex3fv($P063);
    glNormal3fv(N064);
    glVertex3fv($P064);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N063);
    glVertex3fv($P063);
    glNormal3fv(N006);
    glVertex3fv($P006);
    glNormal3fv(N064);
    glVertex3fv($P064);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N064);
    glVertex3fv($P064);
    glNormal3fv(N006);
    glVertex3fv($P006);
    glNormal3fv(N099);
    glVertex3fv($P099);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N064);
    glVertex3fv($P064);
    glNormal3fv(N099);
    glVertex3fv($P099);
    glNormal3fv(N117);
    glVertex3fv($P117);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N120);
    glVertex3fv($P120);
    glNormal3fv(N064);
    glVertex3fv($P064);
    glNormal3fv(N117);
    glVertex3fv($P117);
    glNormal3fv(N116);
    glVertex3fv($P116);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N006);
    glVertex3fv($P006);
    glNormal3fv(N065);
    glVertex3fv($P065);
    glNormal3fv(N099);
    glVertex3fv($P099);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N062);
    glVertex3fv($P062);
    glNormal3fv(N100);
    glVertex3fv($P100);
    glNormal3fv(N120);
    glVertex3fv($P120);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N005);
    glVertex3fv($P005);
    glNormal3fv(N062);
    glVertex3fv($P062);
    glNormal3fv(N120);
    glVertex3fv($P120);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N005);
    glVertex3fv($P005);
    glNormal3fv(N120);
    glVertex3fv($P120);
    glNormal3fv(N002);
    glVertex3fv($P002);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N002);
    glVertex3fv($P002);
    glNormal3fv(N120);
    glVertex3fv($P120);
    glNormal3fv(N116);
    glVertex3fv($P116);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(N060);
    glVertex3fv($P060);
    glNormal3fv(N005);
    glVertex3fv($P005);
    glNormal3fv(N002);
    glVertex3fv($P002);
    glEnd();
}

sub 
Dolphin016()
{
    glDisable(GL_DEPTH_TEST);
    glBegin(GL_POLYGON);
    glVertex3fv($P123);
    glVertex3fv($P124);
    glVertex3fv($P125);
    glVertex3fv($P126);
    glVertex3fv($P127);
    glVertex3fv($P128);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P129);
    glVertex3fv($P130);
    glVertex3fv($P131);
    glVertex3fv($P132);
    glVertex3fv($P133);
    glVertex3fv($P134);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($P103);
    glVertex3fv($P105);
    glVertex3fv($P108);
    glEnd();
    glEnable(GL_DEPTH_TEST);
}

sub DrawDolphin($fish)
{
    my ($seg0, $seg1, $seg2, $seg3, $seg4, $seg5, $seg6, $seg7);
    my ($pitch, $thrash, $chomp);

    $fish.htail = int($fish.htail - int(10.0 * $fish.v)) % 360;

    $thrash = 70.0 * $fish.v;

    $seg0 = 1.0 * $thrash * sin(($fish.htail) * RRAD);
    $seg3 = 1.0 * $thrash * sin(($fish.htail) * RRAD);
    $seg1 = 2.0 * $thrash * sin(($fish.htail + 4.0) * RRAD);
    $seg2 = 3.0 * $thrash * sin(($fish.htail + 6.0) * RRAD);
    $seg4 = 4.0 * $thrash * sin(($fish.htail + 10.0) * RRAD);
    $seg5 = 4.5 * $thrash * sin(($fish.htail + 15.0) * RRAD);
    $seg6 = 5.0 * $thrash * sin(($fish.htail + 20.0) * RRAD);
    $seg7 = 6.0 * $thrash * sin(($fish.htail + 30.0) * RRAD);

    $pitch = $fish.v * sin(($fish.htail + 180.0) * RRAD);

    if ($fish.v > 2.0) {
        $chomp = -($fish.v - 2.0) * 200.0;
    }
    $chomp = 100.0;

    $P012[1] = iP012[1] + $seg5;
    $P013[1] = iP013[1] + $seg5;
    $P014[1] = iP014[1] + $seg5;
    $P015[1] = iP015[1] + $seg5;
    $P016[1] = iP016[1] + $seg5;
    $P017[1] = iP017[1] + $seg5;
    $P018[1] = iP018[1] + $seg5;
    $P019[1] = iP019[1] + $seg5;

    $P020[1] = iP020[1] + $seg4;
    $P021[1] = iP021[1] + $seg4;
    $P022[1] = iP022[1] + $seg4;
    $P023[1] = iP023[1] + $seg4;
    $P024[1] = iP024[1] + $seg4;
    $P025[1] = iP025[1] + $seg4;
    $P026[1] = iP026[1] + $seg4;
    $P027[1] = iP027[1] + $seg4;

    $P028[1] = iP028[1] + $seg2;
    $P029[1] = iP029[1] + $seg2;
    $P030[1] = iP030[1] + $seg2;
    $P031[1] = iP031[1] + $seg2;
    $P032[1] = iP032[1] + $seg2;
    $P033[1] = iP033[1] + $seg2;
    $P034[1] = iP034[1] + $seg2;
    $P035[1] = iP035[1] + $seg2;

    $P036[1] = iP036[1] + $seg1;
    $P037[1] = iP037[1] + $seg1;
    $P038[1] = iP038[1] + $seg1;
    $P039[1] = iP039[1] + $seg1;
    $P040[1] = iP040[1] + $seg1;
    $P041[1] = iP041[1] + $seg1;
    $P042[1] = iP042[1] + $seg1;
    $P043[1] = iP043[1] + $seg1;

    $P044[1] = iP044[1] + $seg0;
    $P045[1] = iP045[1] + $seg0;
    $P046[1] = iP046[1] + $seg0;
    $P047[1] = iP047[1] + $seg0;
    $P048[1] = iP048[1] + $seg0;
    $P049[1] = iP049[1] + $seg0;
    $P050[1] = iP050[1] + $seg0;
    $P051[1] = iP051[1] + $seg0;

    $P009[1] = iP009[1] + $seg6;
    $P010[1] = iP010[1] + $seg6;
    $P075[1] = iP075[1] + $seg6;
    $P076[1] = iP076[1] + $seg6;

    $P001[1] = iP001[1] + $seg7;
    $P011[1] = iP011[1] + $seg7;
    $P068[1] = iP068[1] + $seg7;
    $P069[1] = iP069[1] + $seg7;
    $P070[1] = iP070[1] + $seg7;
    $P071[1] = iP071[1] + $seg7;
    $P072[1] = iP072[1] + $seg7;
    $P073[1] = iP073[1] + $seg7;
    $P074[1] = iP074[1] + $seg7;

    $P091[1] = iP091[1] + $seg3;
    $P092[1] = iP092[1] + $seg3;
    $P093[1] = iP093[1] + $seg3;
    $P094[1] = iP094[1] + $seg3;
    $P095[1] = iP095[1] + $seg3;
    $P122[1] = iP122[1] + $seg3 * 1.5;

    $P097[1] = iP097[1] + $chomp;
    $P098[1] = iP098[1] + $chomp;
    $P102[1] = iP102[1] + $chomp;
    $P110[1] = iP110[1] + $chomp;
    $P111[1] = iP111[1] + $chomp;
    $P121[1] = iP121[1] + $chomp;
    $P118[1] = iP118[1] + $chomp;
    $P119[1] = iP119[1] + $chomp;

    glPushMatrix();

    glRotatef($pitch, 1.0, 0.0, 0.0);

    glTranslatef(0.0, 0.0, 7000.0);

    glRotatef(180.0, 0.0, 1.0, 0.0);

    glEnable(GL_CULL_FACE);
    Dolphin014();
    Dolphin010();
    Dolphin009();
    Dolphin012();
    Dolphin013();
    Dolphin006();
    Dolphin002();
    Dolphin001();
    Dolphin003();
    Dolphin015();
    Dolphin004();
    Dolphin005();
    Dolphin007();
    Dolphin008();
    Dolphin011();
    Dolphin016();
    glDisable(GL_CULL_FACE);

    glPopMatrix();
}

const SHARK_N002 = (0.000077 ,-0.020611 ,0.999788);
const SHARK_N003 = (0.961425 ,0.258729 ,-0.093390);
const SHARK_N004 = (0.510811 ,-0.769633 ,-0.383063);
const SHARK_N005 = (0.400123 ,0.855734 ,-0.328055);
const SHARK_N006 = (-0.770715 ,0.610204 ,-0.183440);
const SHARK_N007 = (-0.915597 ,-0.373345 ,-0.149316);
const SHARK_N008 = (-0.972788 ,0.208921 ,-0.100179);
const SHARK_N009 = (-0.939713 ,-0.312268 ,-0.139383);
const SHARK_N010 = (-0.624138 ,-0.741047 ,-0.247589);
const SHARK_N011 = (0.591434 ,-0.768401 ,-0.244471);
const SHARK_N012 = (0.935152 ,-0.328495 ,-0.132598);
const SHARK_N013 = (0.997102 ,0.074243 ,-0.016593);
const SHARK_N014 = (0.969995 ,0.241712 ,-0.026186);
const SHARK_N015 = (0.844539 ,0.502628 ,-0.184714);
const SHARK_N016 = (-0.906608 ,0.386308 ,-0.169787);
const SHARK_N017 = (-0.970016 ,0.241698 ,-0.025516);
const SHARK_N018 = (-0.998652 ,0.050493 ,-0.012045);
const SHARK_N019 = (-0.942685 ,-0.333051 ,-0.020556);
const SHARK_N020 = (-0.660944 ,-0.750276 ,0.015480);
const SHARK_N021 = (0.503549 ,-0.862908 ,-0.042749);
const SHARK_N022 = (0.953202 ,-0.302092 ,-0.012089);
const SHARK_N023 = (0.998738 ,0.023574 ,0.044344);
const SHARK_N024 = (0.979297 ,0.193272 ,0.060202);
const SHARK_N025 = (0.798300 ,0.464885 ,0.382883);
const SHARK_N026 = (-0.756590 ,0.452403 ,0.472126);
const SHARK_N027 = (-0.953855 ,0.293003 ,0.065651);
const SHARK_N028 = (-0.998033 ,0.040292 ,0.048028);
const SHARK_N029 = (-0.977079 ,-0.204288 ,0.059858);
const SHARK_N030 = (-0.729117 ,-0.675304 ,0.111140);
const SHARK_N031 = (0.598361 ,-0.792753 ,0.116221);
const SHARK_N032 = (0.965192 ,-0.252991 ,0.066332);
const SHARK_N033 = (0.998201 ,-0.002790 ,0.059892);
const SHARK_N034 = (0.978657 ,0.193135 ,0.070207);
const SHARK_N035 = (0.718815 ,0.680392 ,0.142733);
const SHARK_N036 = (-0.383096 ,0.906212 ,0.178936);
const SHARK_N037 = (-0.952831 ,0.292590 ,0.080647);
const SHARK_N038 = (-0.997680 ,0.032417 ,0.059861);
const SHARK_N039 = (-0.982629 ,-0.169881 ,0.074700);
const SHARK_N040 = (-0.695424 ,-0.703466 ,0.146700);
const SHARK_N041 = (0.359323 ,-0.915531 ,0.180805);
const SHARK_N042 = (0.943356 ,-0.319387 ,0.089842);
const SHARK_N043 = (0.998272 ,-0.032435 ,0.048993);
const SHARK_N044 = (0.978997 ,0.193205 ,0.065084);
const SHARK_N045 = (0.872144 ,0.470094 ,-0.135565);
const SHARK_N046 = (-0.664282 ,0.737945 ,-0.119027);
const SHARK_N047 = (-0.954508 ,0.288570 ,0.075107);
const SHARK_N048 = (-0.998273 ,0.032406 ,0.048993);
const SHARK_N049 = (-0.979908 ,-0.193579 ,0.048038);
const SHARK_N050 = (-0.858736 ,-0.507202 ,-0.072938);
const SHARK_N051 = (0.643545 ,-0.763887 ,-0.048237);
const SHARK_N052 = (0.955580 ,-0.288954 ,0.058068);
const SHARK_N058 = (0.000050 ,0.793007 ,-0.609213);
const SHARK_N059 = (0.913510 ,0.235418 ,-0.331779);
const SHARK_N060 = (-0.807970 ,0.495000 ,-0.319625);
const SHARK_N061 = (0.000000 ,0.784687 ,-0.619892);
const SHARK_N062 = (0.000000 ,-1.000000 ,0.000000);
const SHARK_N063 = (0.000000 ,1.000000 ,0.000000);
const SHARK_N064 = (0.000000 ,1.000000 ,0.000000);
const SHARK_N065 = (0.000000 ,1.000000 ,0.000000);
const SHARK_N066 = (-0.055784 ,0.257059 ,0.964784);
const SHARK_N069 = (-0.000505 ,-0.929775 ,-0.368127);
const SHARK_N070 = (0.000000 ,1.000000 ,0.000000);
our $SHARK_P002 = (0.00, -36.59, 5687.72);
our $SHARK_P003 = (90.00, 114.73, 724.38);
our $SHARK_P004 = (58.24, -146.84, 262.35);
our $SHARK_P005 = (27.81, 231.52, 510.43);
our $SHARK_P006 = (-27.81, 230.43, 509.76);
our $SHARK_P007 = (-46.09, -146.83, 265.84);
our $SHARK_P008 = (-90.00, 103.84, 718.53);
our $SHARK_P009 = (-131.10, -165.92, 834.85);
our $SHARK_P010 = (-27.81, -285.31, 500.00);
our $SHARK_P011 = (27.81, -285.32, 500.00);
our $SHARK_P012 = (147.96, -170.89, 845.50);
our $SHARK_P013 = (180.00, 0.00, 2000.00);
our $SHARK_P014 = (145.62, 352.67, 2000.00);
our $SHARK_P015 = (55.62, 570.63, 2000.00);
our $SHARK_P016 = (-55.62, 570.64, 2000.00);
our $SHARK_P017 = (-145.62, 352.68, 2000.00);
our $SHARK_P018 = (-180.00, 0.01, 2000.00);
our $SHARK_P019 = (-178.20, -352.66, 2001.61);
our $SHARK_P020 = (-55.63, -570.63, 2000.00);
our $SHARK_P021 = (55.62, -570.64, 2000.00);
our $SHARK_P022 = (179.91, -352.69, 1998.39);
our $SHARK_P023 = (150.00, 0.00, 3000.00);
our $SHARK_P024 = (121.35, 293.89, 3000.00);
our $SHARK_P025 = (46.35, 502.93, 2883.09);
our $SHARK_P026 = (-46.35, 497.45, 2877.24);
our $SHARK_P027 = (-121.35, 293.90, 3000.00);
our $SHARK_P028 = (-150.00, 0.00, 3000.00);
our $SHARK_P029 = (-152.21, -304.84, 2858.68);
our $SHARK_P030 = (-46.36, -475.52, 3000.00);
our $SHARK_P031 = (46.35, -475.53, 3000.00);
our $SHARK_P032 = (155.64, -304.87, 2863.50);
our $SHARK_P033 = (90.00, 0.00, 4000.00);
our $SHARK_P034 = (72.81, 176.33, 4000.00);
our $SHARK_P035 = (27.81, 285.32, 4000.00);
our $SHARK_P036 = (-27.81, 285.32, 4000.00);
our $SHARK_P037 = (-72.81, 176.34, 4000.00);
our $SHARK_P038 = (-90.00, 0.00, 4000.00);
our $SHARK_P039 = (-72.81, -176.33, 4000.00);
our $SHARK_P040 = (-27.81, -285.31, 4000.00);
our $SHARK_P041 = (27.81, -285.32, 4000.00);
our $SHARK_P042 = (72.81, -176.34, 4000.00);
our $SHARK_P043 = (30.00, 0.00, 5000.00);
our $SHARK_P044 = (24.27, 58.78, 5000.00);
our $SHARK_P045 = (9.27, 95.11, 5000.00);
our $SHARK_P046 = (-9.27, 95.11, 5000.00);
our $SHARK_P047 = (-24.27, 58.78, 5000.00);
our $SHARK_P048 = (-30.00, 0.00, 5000.00);
our $SHARK_P049 = (-24.27, -58.78, 5000.00);
our $SHARK_P050 = (-9.27, -95.10, 5000.00);
our $SHARK_P051 = (9.27, -95.11, 5000.00);
our $SHARK_P052 = (24.27, -58.78, 5000.00);
our $SHARK_P058 = (0.00, 1212.72, 2703.08);
our $SHARK_P059 = (50.36, 0.00, 108.14);
our $SHARK_P060 = (-22.18, 0.00, 108.14);
our $SHARK_P061 = (0.00, 1181.61, 6344.65);
our $SHARK_P062 = (516.45, -887.08, 2535.45);
our $SHARK_P063 = (-545.69, -879.31, 2555.63);
our $SHARK_P064 = (618.89, -1005.64, 2988.32);
our $SHARK_P065 = (-635.37, -1014.79, 2938.68);
our $SHARK_P066 = (0.00, 1374.43, 3064.18);
our $SHARK_P069 = (0.00, -418.25, 5765.04);
our $SHARK_P070 = (0.00, 1266.91, 6629.60);
our $SHARK_P071 = (-139.12, -124.96, 997.98);
our $SHARK_P072 = (-139.24, -110.18, 1020.68);
our $SHARK_P073 = (-137.33, -94.52, 1022.63);
our $SHARK_P074 = (-137.03, -79.91, 996.89);
our $SHARK_P075 = (-135.21, -91.48, 969.14);
our $SHARK_P076 = (-135.39, -110.87, 968.76);
our $SHARK_P077 = (150.23, -78.44, 995.53);
our $SHARK_P078 = (152.79, -92.76, 1018.46);
our $SHARK_P079 = (154.19, -110.20, 1020.55);
our $SHARK_P080 = (151.33, -124.15, 993.77);
our $SHARK_P081 = (150.49, -111.19, 969.86);
our $SHARK_P082 = (150.79, -92.41, 969.70);
const SHARK_iP002 = (0.00, -36.59, 5687.72);
const SHARK_iP004 = (58.24, -146.84, 262.35);
const SHARK_iP007 = (-46.09, -146.83, 265.84);
const SHARK_iP010 = (-27.81, -285.31, 500.00);
const SHARK_iP011 = (27.81, -285.32, 500.00);
const SHARK_iP023 = (150.00, 0.00, 3000.00);
const SHARK_iP024 = (121.35, 293.89, 3000.00);
const SHARK_iP025 = (46.35, 502.93, 2883.09);
const SHARK_iP026 = (-46.35, 497.45, 2877.24);
const SHARK_iP027 = (-121.35, 293.90, 3000.00);
const SHARK_iP028 = (-150.00, 0.00, 3000.00);
const SHARK_iP029 = (-121.35, -304.84, 2853.86);
const SHARK_iP030 = (-46.36, -475.52, 3000.00);
const SHARK_iP031 = (46.35, -475.53, 3000.00);
const SHARK_iP032 = (121.35, -304.87, 2853.86);
const SHARK_iP033 = (90.00, 0.00, 4000.00);
const SHARK_iP034 = (72.81, 176.33, 4000.00);
const SHARK_iP035 = (27.81, 285.32, 4000.00);
const SHARK_iP036 = (-27.81, 285.32, 4000.00);
const SHARK_iP037 = (-72.81, 176.34, 4000.00);
const SHARK_iP038 = (-90.00, 0.00, 4000.00);
const SHARK_iP039 = (-72.81, -176.33, 4000.00);
const SHARK_iP040 = (-27.81, -285.31, 4000.00);
const SHARK_iP041 = (27.81, -285.32, 4000.00);
const SHARK_iP042 = (72.81, -176.34, 4000.00);
const SHARK_iP043 = (30.00, 0.00, 5000.00);
const SHARK_iP044 = (24.27, 58.78, 5000.00);
const SHARK_iP045 = (9.27, 95.11, 5000.00);
const SHARK_iP046 = (-9.27, 95.11, 5000.00);
const SHARK_iP047 = (-24.27, 58.78, 5000.00);
const SHARK_iP048 = (-30.00, 0.00, 5000.00);
const SHARK_iP049 = (-24.27, -58.78, 5000.00);
const SHARK_iP050 = (-9.27, -95.10, 5000.00);
const SHARK_iP051 = (9.27, -95.11, 5000.00);
const SHARK_iP052 = (24.27, -58.78, 5000.00);
const SHARK_iP061 = (0.00, 1181.61, 6344.65);
const SHARK_iP069 = (0.00, -418.25, 5765.04);
const SHARK_iP070 = (0.00, 1266.91, 6629.60);

sub Fish001()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N005);
    glVertex3fv($SHARK_P005);
    glNormal3fv(SHARK_N059);
    glVertex3fv($SHARK_P059);
    glNormal3fv(SHARK_N060);
    glVertex3fv($SHARK_P060);
    glNormal3fv(SHARK_N006);
    glVertex3fv($SHARK_P006);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glNormal3fv(SHARK_N005);
    glVertex3fv($SHARK_P005);
    glNormal3fv(SHARK_N006);
    glVertex3fv($SHARK_P006);
    glNormal3fv(SHARK_N016);
    glVertex3fv($SHARK_P016);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N006);
    glVertex3fv($SHARK_P006);
    glNormal3fv(SHARK_N060);
    glVertex3fv($SHARK_P060);
    glNormal3fv(SHARK_N008);
    glVertex3fv($SHARK_P008);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N016);
    glVertex3fv($SHARK_P016);
    glNormal3fv(SHARK_N006);
    glVertex3fv($SHARK_P006);
    glNormal3fv(SHARK_N008);
    glVertex3fv($SHARK_P008);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N016);
    glVertex3fv($SHARK_P016);
    glNormal3fv(SHARK_N008);
    glVertex3fv($SHARK_P008);
    glNormal3fv(SHARK_N017);
    glVertex3fv($SHARK_P017);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N017);
    glVertex3fv($SHARK_P017);
    glNormal3fv(SHARK_N008);
    glVertex3fv($SHARK_P008);
    glNormal3fv(SHARK_N018);
    glVertex3fv($SHARK_P018);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N008);
    glVertex3fv($SHARK_P008);
    glNormal3fv(SHARK_N009);
    glVertex3fv($SHARK_P009);
    glNormal3fv(SHARK_N018);
    glVertex3fv($SHARK_P018);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N008);
    glVertex3fv($SHARK_P008);
    glNormal3fv(SHARK_N060);
    glVertex3fv($SHARK_P060);
    glNormal3fv(SHARK_N009);
    glVertex3fv($SHARK_P009);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N007);
    glVertex3fv($SHARK_P007);
    glNormal3fv(SHARK_N010);
    glVertex3fv($SHARK_P010);
    glNormal3fv(SHARK_N009);
    glVertex3fv($SHARK_P009);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N009);
    glVertex3fv($SHARK_P009);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glNormal3fv(SHARK_N018);
    glVertex3fv($SHARK_P018);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N009);
    glVertex3fv($SHARK_P009);
    glNormal3fv(SHARK_N010);
    glVertex3fv($SHARK_P010);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N010);
    glVertex3fv($SHARK_P010);
    glNormal3fv(SHARK_N020);
    glVertex3fv($SHARK_P020);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N010);
    glVertex3fv($SHARK_P010);
    glNormal3fv(SHARK_N011);
    glVertex3fv($SHARK_P011);
    glNormal3fv(SHARK_N021);
    glVertex3fv($SHARK_P021);
    glNormal3fv(SHARK_N020);
    glVertex3fv($SHARK_P020);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N004);
    glVertex3fv($SHARK_P004);
    glNormal3fv(SHARK_N011);
    glVertex3fv($SHARK_P011);
    glNormal3fv(SHARK_N010);
    glVertex3fv($SHARK_P010);
    glNormal3fv(SHARK_N007);
    glVertex3fv($SHARK_P007);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N004);
    glVertex3fv($SHARK_P004);
    glNormal3fv(SHARK_N012);
    glVertex3fv($SHARK_P012);
    glNormal3fv(SHARK_N011);
    glVertex3fv($SHARK_P011);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N012);
    glVertex3fv($SHARK_P012);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N011);
    glVertex3fv($SHARK_P011);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N011);
    glVertex3fv($SHARK_P011);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N021);
    glVertex3fv($SHARK_P021);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N059);
    glVertex3fv($SHARK_P059);
    glNormal3fv(SHARK_N005);
    glVertex3fv($SHARK_P005);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glNormal3fv(SHARK_N014);
    glVertex3fv($SHARK_P014);
    glNormal3fv(SHARK_N003);
    glVertex3fv($SHARK_P003);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glNormal3fv(SHARK_N003);
    glVertex3fv($SHARK_P003);
    glNormal3fv(SHARK_N059);
    glVertex3fv($SHARK_P059);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N014);
    glVertex3fv($SHARK_P014);
    glNormal3fv(SHARK_N013);
    glVertex3fv($SHARK_P013);
    glNormal3fv(SHARK_N003);
    glVertex3fv($SHARK_P003);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N003);
    glVertex3fv($SHARK_P003);
    glNormal3fv(SHARK_N012);
    glVertex3fv($SHARK_P012);
    glNormal3fv(SHARK_N059);
    glVertex3fv($SHARK_P059);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N013);
    glVertex3fv($SHARK_P013);
    glNormal3fv(SHARK_N012);
    glVertex3fv($SHARK_P012);
    glNormal3fv(SHARK_N003);
    glVertex3fv($SHARK_P003);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N013);
    glVertex3fv($SHARK_P013);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N012);
    glVertex3fv($SHARK_P012);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($SHARK_P071);
    glVertex3fv($SHARK_P072);
    glVertex3fv($SHARK_P073);
    glVertex3fv($SHARK_P074);
    glVertex3fv($SHARK_P075);
    glVertex3fv($SHARK_P076);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($SHARK_P077);
    glVertex3fv($SHARK_P078);
    glVertex3fv($SHARK_P079);
    glVertex3fv($SHARK_P080);
    glVertex3fv($SHARK_P081);
    glVertex3fv($SHARK_P082);
    glEnd();
}

sub Fish002()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N013);
    glVertex3fv($SHARK_P013);
    glNormal3fv(SHARK_N014);
    glVertex3fv($SHARK_P014);
    glNormal3fv(SHARK_N024);
    glVertex3fv($SHARK_P024);
    glNormal3fv(SHARK_N023);
    glVertex3fv($SHARK_P023);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N014);
    glVertex3fv($SHARK_P014);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glNormal3fv(SHARK_N025);
    glVertex3fv($SHARK_P025);
    glNormal3fv(SHARK_N024);
    glVertex3fv($SHARK_P024);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N016);
    glVertex3fv($SHARK_P016);
    glNormal3fv(SHARK_N017);
    glVertex3fv($SHARK_P017);
    glNormal3fv(SHARK_N027);
    glVertex3fv($SHARK_P027);
    glNormal3fv(SHARK_N026);
    glVertex3fv($SHARK_P026);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N017);
    glVertex3fv($SHARK_P017);
    glNormal3fv(SHARK_N018);
    glVertex3fv($SHARK_P018);
    glNormal3fv(SHARK_N028);
    glVertex3fv($SHARK_P028);
    glNormal3fv(SHARK_N027);
    glVertex3fv($SHARK_P027);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N020);
    glVertex3fv($SHARK_P020);
    glNormal3fv(SHARK_N021);
    glVertex3fv($SHARK_P021);
    glNormal3fv(SHARK_N031);
    glVertex3fv($SHARK_P031);
    glNormal3fv(SHARK_N030);
    glVertex3fv($SHARK_P030);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N013);
    glVertex3fv($SHARK_P013);
    glNormal3fv(SHARK_N023);
    glVertex3fv($SHARK_P023);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N023);
    glVertex3fv($SHARK_P023);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glNormal3fv(SHARK_N031);
    glVertex3fv($SHARK_P031);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N031);
    glVertex3fv($SHARK_P031);
    glNormal3fv(SHARK_N021);
    glVertex3fv($SHARK_P021);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N018);
    glVertex3fv($SHARK_P018);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N018);
    glVertex3fv($SHARK_P018);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glNormal3fv(SHARK_N028);
    glVertex3fv($SHARK_P028);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glNormal3fv(SHARK_N020);
    glVertex3fv($SHARK_P020);
    glNormal3fv(SHARK_N030);
    glVertex3fv($SHARK_P030);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glNormal3fv(SHARK_N030);
    glVertex3fv($SHARK_P030);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glEnd();
}

sub Fish003()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glNormal3fv(SHARK_N023);
    glVertex3fv($SHARK_P023);
    glNormal3fv(SHARK_N033);
    glVertex3fv($SHARK_P033);
    glNormal3fv(SHARK_N042);
    glVertex3fv($SHARK_P042);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N031);
    glVertex3fv($SHARK_P031);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glNormal3fv(SHARK_N042);
    glVertex3fv($SHARK_P042);
    glNormal3fv(SHARK_N041);
    glVertex3fv($SHARK_P041);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N023);
    glVertex3fv($SHARK_P023);
    glNormal3fv(SHARK_N024);
    glVertex3fv($SHARK_P024);
    glNormal3fv(SHARK_N034);
    glVertex3fv($SHARK_P034);
    glNormal3fv(SHARK_N033);
    glVertex3fv($SHARK_P033);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N024);
    glVertex3fv($SHARK_P024);
    glNormal3fv(SHARK_N025);
    glVertex3fv($SHARK_P025);
    glNormal3fv(SHARK_N035);
    glVertex3fv($SHARK_P035);
    glNormal3fv(SHARK_N034);
    glVertex3fv($SHARK_P034);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N030);
    glVertex3fv($SHARK_P030);
    glNormal3fv(SHARK_N031);
    glVertex3fv($SHARK_P031);
    glNormal3fv(SHARK_N041);
    glVertex3fv($SHARK_P041);
    glNormal3fv(SHARK_N040);
    glVertex3fv($SHARK_P040);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N025);
    glVertex3fv($SHARK_P025);
    glNormal3fv(SHARK_N026);
    glVertex3fv($SHARK_P026);
    glNormal3fv(SHARK_N036);
    glVertex3fv($SHARK_P036);
    glNormal3fv(SHARK_N035);
    glVertex3fv($SHARK_P035);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N026);
    glVertex3fv($SHARK_P026);
    glNormal3fv(SHARK_N027);
    glVertex3fv($SHARK_P027);
    glNormal3fv(SHARK_N037);
    glVertex3fv($SHARK_P037);
    glNormal3fv(SHARK_N036);
    glVertex3fv($SHARK_P036);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N027);
    glVertex3fv($SHARK_P027);
    glNormal3fv(SHARK_N028);
    glVertex3fv($SHARK_P028);
    glNormal3fv(SHARK_N038);
    glVertex3fv($SHARK_P038);
    glNormal3fv(SHARK_N037);
    glVertex3fv($SHARK_P037);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N028);
    glVertex3fv($SHARK_P028);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glNormal3fv(SHARK_N039);
    glVertex3fv($SHARK_P039);
    glNormal3fv(SHARK_N038);
    glVertex3fv($SHARK_P038);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glNormal3fv(SHARK_N030);
    glVertex3fv($SHARK_P030);
    glNormal3fv(SHARK_N040);
    glVertex3fv($SHARK_P040);
    glNormal3fv(SHARK_N039);
    glVertex3fv($SHARK_P039);
    glEnd();
}

sub Fish004()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N040);
    glVertex3fv($SHARK_P040);
    glNormal3fv(SHARK_N041);
    glVertex3fv($SHARK_P041);
    glNormal3fv(SHARK_N051);
    glVertex3fv($SHARK_P051);
    glNormal3fv(SHARK_N050);
    glVertex3fv($SHARK_P050);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N041);
    glVertex3fv($SHARK_P041);
    glNormal3fv(SHARK_N042);
    glVertex3fv($SHARK_P042);
    glNormal3fv(SHARK_N052);
    glVertex3fv($SHARK_P052);
    glNormal3fv(SHARK_N051);
    glVertex3fv($SHARK_P051);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N042);
    glVertex3fv($SHARK_P042);
    glNormal3fv(SHARK_N033);
    glVertex3fv($SHARK_P033);
    glNormal3fv(SHARK_N043);
    glVertex3fv($SHARK_P043);
    glNormal3fv(SHARK_N052);
    glVertex3fv($SHARK_P052);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N033);
    glVertex3fv($SHARK_P033);
    glNormal3fv(SHARK_N034);
    glVertex3fv($SHARK_P034);
    glNormal3fv(SHARK_N044);
    glVertex3fv($SHARK_P044);
    glNormal3fv(SHARK_N043);
    glVertex3fv($SHARK_P043);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N034);
    glVertex3fv($SHARK_P034);
    glNormal3fv(SHARK_N035);
    glVertex3fv($SHARK_P035);
    glNormal3fv(SHARK_N045);
    glVertex3fv($SHARK_P045);
    glNormal3fv(SHARK_N044);
    glVertex3fv($SHARK_P044);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N035);
    glVertex3fv($SHARK_P035);
    glNormal3fv(SHARK_N036);
    glVertex3fv($SHARK_P036);
    glNormal3fv(SHARK_N046);
    glVertex3fv($SHARK_P046);
    glNormal3fv(SHARK_N045);
    glVertex3fv($SHARK_P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N036);
    glVertex3fv($SHARK_P036);
    glNormal3fv(SHARK_N037);
    glVertex3fv($SHARK_P037);
    glNormal3fv(SHARK_N047);
    glVertex3fv($SHARK_P047);
    glNormal3fv(SHARK_N046);
    glVertex3fv($SHARK_P046);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N037);
    glVertex3fv($SHARK_P037);
    glNormal3fv(SHARK_N038);
    glVertex3fv($SHARK_P038);
    glNormal3fv(SHARK_N048);
    glVertex3fv($SHARK_P048);
    glNormal3fv(SHARK_N047);
    glVertex3fv($SHARK_P047);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N038);
    glVertex3fv($SHARK_P038);
    glNormal3fv(SHARK_N039);
    glVertex3fv($SHARK_P039);
    glNormal3fv(SHARK_N049);
    glVertex3fv($SHARK_P049);
    glNormal3fv(SHARK_N048);
    glVertex3fv($SHARK_P048);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N039);
    glVertex3fv($SHARK_P039);
    glNormal3fv(SHARK_N040);
    glVertex3fv($SHARK_P040);
    glNormal3fv(SHARK_N050);
    glVertex3fv($SHARK_P050);
    glNormal3fv(SHARK_N049);
    glVertex3fv($SHARK_P049);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N070);
    glVertex3fv($SHARK_P070);
    glNormal3fv(SHARK_N061);
    glVertex3fv($SHARK_P061);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N061);
    glVertex3fv($SHARK_P061);
    glNormal3fv(SHARK_N046);
    glVertex3fv($SHARK_P046);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N045);
    glVertex3fv($SHARK_P045);
    glNormal3fv(SHARK_N046);
    glVertex3fv($SHARK_P046);
    glNormal3fv(SHARK_N061);
    glVertex3fv($SHARK_P061);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N061);
    glVertex3fv($SHARK_P061);
    glNormal3fv(SHARK_N070);
    glVertex3fv($SHARK_P070);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N045);
    glVertex3fv($SHARK_P045);
    glNormal3fv(SHARK_N061);
    glVertex3fv($SHARK_P061);
    glEnd();
}

sub Fish005()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N044);
    glVertex3fv($SHARK_P044);
    glNormal3fv(SHARK_N045);
    glVertex3fv($SHARK_P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N043);
    glVertex3fv($SHARK_P043);
    glNormal3fv(SHARK_N044);
    glVertex3fv($SHARK_P044);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N052);
    glVertex3fv($SHARK_P052);
    glNormal3fv(SHARK_N043);
    glVertex3fv($SHARK_P043);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N051);
    glVertex3fv($SHARK_P051);
    glNormal3fv(SHARK_N052);
    glVertex3fv($SHARK_P052);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N046);
    glVertex3fv($SHARK_P046);
    glNormal3fv(SHARK_N047);
    glVertex3fv($SHARK_P047);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N047);
    glVertex3fv($SHARK_P047);
    glNormal3fv(SHARK_N048);
    glVertex3fv($SHARK_P048);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N048);
    glVertex3fv($SHARK_P048);
    glNormal3fv(SHARK_N049);
    glVertex3fv($SHARK_P049);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N049);
    glVertex3fv($SHARK_P049);
    glNormal3fv(SHARK_N050);
    glVertex3fv($SHARK_P050);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N050);
    glVertex3fv($SHARK_P050);
    glNormal3fv(SHARK_N051);
    glVertex3fv($SHARK_P051);
    glNormal3fv(SHARK_N069);
    glVertex3fv($SHARK_P069);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N051);
    glVertex3fv($SHARK_P051);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glNormal3fv(SHARK_N069);
    glVertex3fv($SHARK_P069);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N050);
    glVertex3fv($SHARK_P050);
    glNormal3fv(SHARK_N069);
    glVertex3fv($SHARK_P069);
    glNormal3fv(SHARK_N002);
    glVertex3fv($SHARK_P002);
    glEnd();
}

sub Fish006()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N066);
    glVertex3fv($SHARK_P066);
    glNormal3fv(SHARK_N016);
    glVertex3fv($SHARK_P016);
    glNormal3fv(SHARK_N026);
    glVertex3fv($SHARK_P026);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glNormal3fv(SHARK_N066);
    glVertex3fv($SHARK_P066);
    glNormal3fv(SHARK_N025);
    glVertex3fv($SHARK_P025);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N025);
    glVertex3fv($SHARK_P025);
    glNormal3fv(SHARK_N066);
    glVertex3fv($SHARK_P066);
    glNormal3fv(SHARK_N026);
    glVertex3fv($SHARK_P026);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N066);
    glVertex3fv($SHARK_P066);
    glNormal3fv(SHARK_N058);
    glVertex3fv($SHARK_P058);
    glNormal3fv(SHARK_N016);
    glVertex3fv($SHARK_P016);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glNormal3fv(SHARK_N058);
    glVertex3fv($SHARK_P058);
    glNormal3fv(SHARK_N066);
    glVertex3fv($SHARK_P066);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N058);
    glVertex3fv($SHARK_P058);
    glNormal3fv(SHARK_N015);
    glVertex3fv($SHARK_P015);
    glNormal3fv(SHARK_N016);
    glVertex3fv($SHARK_P016);
    glEnd();
}

sub Fish007()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N062);
    glVertex3fv($SHARK_P062);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N062);
    glVertex3fv($SHARK_P062);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glNormal3fv(SHARK_N064);
    glVertex3fv($SHARK_P064);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N022);
    glVertex3fv($SHARK_P022);
    glNormal3fv(SHARK_N062);
    glVertex3fv($SHARK_P062);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N062);
    glVertex3fv($SHARK_P062);
    glNormal3fv(SHARK_N064);
    glVertex3fv($SHARK_P064);
    glNormal3fv(SHARK_N032);
    glVertex3fv($SHARK_P032);
    glEnd();
}

sub Fish008()
{
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N063);
    glVertex3fv($SHARK_P063);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N019);
    glVertex3fv($SHARK_P019);
    glNormal3fv(SHARK_N063);
    glVertex3fv($SHARK_P063);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N063);
    glVertex3fv($SHARK_P063);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glNormal3fv(SHARK_N065);
    glVertex3fv($SHARK_P065);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(SHARK_N063);
    glVertex3fv($SHARK_P063);
    glNormal3fv(SHARK_N065);
    glVertex3fv($SHARK_P065);
    glNormal3fv(SHARK_N029);
    glVertex3fv($SHARK_P029);
    glEnd();
}

sub Fish009()
{
    glBegin(GL_POLYGON);
    glVertex3fv($SHARK_P059);
    glVertex3fv($SHARK_P012);
    glVertex3fv($SHARK_P009);
    glVertex3fv($SHARK_P060);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($SHARK_P012);
    glVertex3fv($SHARK_P004);
    glVertex3fv($SHARK_P007);
    glVertex3fv($SHARK_P009);
    glEnd();
}

sub Fish_1()
{
    Fish004();
    Fish005();
    Fish003();
    Fish007();
    Fish006();
    Fish002();
    Fish008();
    Fish009();
    Fish001();
}

sub Fish_2()
{
    Fish005();
    Fish004();
    Fish003();
    Fish008();
    Fish006();
    Fish002();
    Fish007();
    Fish009();
    Fish001();
}

sub Fish_3()
{
    Fish005();
    Fish004();
    Fish007();
    Fish003();
    Fish002();
    Fish008();
    Fish009();
    Fish001();
    Fish006();
}

sub Fish_4()
{
    Fish005();
    Fish004();
    Fish008();
    Fish003();
    Fish002();
    Fish007();
    Fish009();
    Fish001();
    Fish006();
}

sub Fish_5()
{
    Fish009();
    Fish006();
    Fish007();
    Fish001();
    Fish002();
    Fish003();
    Fish008();
    Fish004();
    Fish005();
}

sub Fish_6()
{
    Fish009();
    Fish006();
    Fish008();
    Fish001();
    Fish002();
    Fish007();
    Fish003();
    Fish004();
    Fish005();
}

sub Fish_7()
{
    Fish009();
    Fish001();
    Fish007();
    Fish005();
    Fish002();
    Fish008();
    Fish003();
    Fish004();
    Fish006();
}

sub Fish_8()
{
    Fish009();
    Fish008();
    Fish001();
    Fish002();
    Fish007();
    Fish003();
    Fish005();
    Fish004();
    Fish006();
}

sub DrawShark($fish)
{
    my $mat;
    my $n;
    my ($seg1, $seg2, $seg3, $seg4, $segup);
    my ($thrash, $chomp);

    $fish.htail = int($fish.htail - (5.0 * $fish.v)) % 360;

    $thrash = 50.0 * $fish.v;

    $seg1 = 0.6 * $thrash * sin($fish.htail * RRAD);
    $seg2 = 1.8 * $thrash * sin(($fish.htail + 45.0) * RRAD);
    $seg3 = 3.0 * $thrash * sin(($fish.htail + 90.0) * RRAD);
    $seg4 = 4.0 * $thrash * sin(($fish.htail + 110.0) * RRAD);

    $chomp = 0.0;
    if ($fish.v > 2.0) {
        $chomp = -($fish.v - 2.0) * 200.0;
    }
    $SHARK_P004[1] = SHARK_iP004[1] + $chomp;
    $SHARK_P007[1] = SHARK_iP007[1] + $chomp;
    $SHARK_P010[1] = SHARK_iP010[1] + $chomp;
    $SHARK_P011[1] = SHARK_iP011[1] + $chomp;

    $SHARK_P023[0] = SHARK_iP023[0] + $seg1;
    $SHARK_P024[0] = SHARK_iP024[0] + $seg1;
    $SHARK_P025[0] = SHARK_iP025[0] + $seg1;
    $SHARK_P026[0] = SHARK_iP026[0] + $seg1;
    $SHARK_P027[0] = SHARK_iP027[0] + $seg1;
    $SHARK_P028[0] = SHARK_iP028[0] + $seg1;
    $SHARK_P029[0] = SHARK_iP029[0] + $seg1;
    $SHARK_P030[0] = SHARK_iP030[0] + $seg1;
    $SHARK_P031[0] = SHARK_iP031[0] + $seg1;
    $SHARK_P032[0] = SHARK_iP032[0] + $seg1;
    $SHARK_P033[0] = SHARK_iP033[0] + $seg2;
    $SHARK_P034[0] = SHARK_iP034[0] + $seg2;
    $SHARK_P035[0] = SHARK_iP035[0] + $seg2;
    $SHARK_P036[0] = SHARK_iP036[0] + $seg2;
    $SHARK_P037[0] = SHARK_iP037[0] + $seg2;
    $SHARK_P038[0] = SHARK_iP038[0] + $seg2;
    $SHARK_P039[0] = SHARK_iP039[0] + $seg2;
    $SHARK_P040[0] = SHARK_iP040[0] + $seg2;
    $SHARK_P041[0] = SHARK_iP041[0] + $seg2;
    $SHARK_P042[0] = SHARK_iP042[0] + $seg2;
    $SHARK_P043[0] = SHARK_iP043[0] + $seg3;
    $SHARK_P044[0] = SHARK_iP044[0] + $seg3;
    $SHARK_P045[0] = SHARK_iP045[0] + $seg3;
    $SHARK_P046[0] = SHARK_iP046[0] + $seg3;
    $SHARK_P047[0] = SHARK_iP047[0] + $seg3;
    $SHARK_P048[0] = SHARK_iP048[0] + $seg3;
    $SHARK_P049[0] = SHARK_iP049[0] + $seg3;
    $SHARK_P050[0] = SHARK_iP050[0] + $seg3;
    $SHARK_P051[0] = SHARK_iP051[0] + $seg3;
    $SHARK_P052[0] = SHARK_iP052[0] + $seg3;
    $SHARK_P002[0] = SHARK_iP002[0] + $seg4;
    $SHARK_P061[0] = SHARK_iP061[0] + $seg4;
    $SHARK_P069[0] = SHARK_iP069[0] + $seg4;
    $SHARK_P070[0] = SHARK_iP070[0] + $seg4;

    $fish.vtail += (($fish.dtheta - $fish.vtail) * 0.1);

    if ($fish.vtail > 0.5) {
        $fish.vtail = 0.5;
    } else if ($fish.vtail < -0.5) {
        $fish.vtail = -0.5;
    }
    $segup = $thrash * $fish.vtail;

    $SHARK_P023[1] = SHARK_iP023[1] + $segup;
    $SHARK_P024[1] = SHARK_iP024[1] + $segup;
    $SHARK_P025[1] = SHARK_iP025[1] + $segup;
    $SHARK_P026[1] = SHARK_iP026[1] + $segup;
    $SHARK_P027[1] = SHARK_iP027[1] + $segup;
    $SHARK_P028[1] = SHARK_iP028[1] + $segup;
    $SHARK_P029[1] = SHARK_iP029[1] + $segup;
    $SHARK_P030[1] = SHARK_iP030[1] + $segup;
    $SHARK_P031[1] = SHARK_iP031[1] + $segup;
    $SHARK_P032[1] = SHARK_iP032[1] + $segup;
    $SHARK_P033[1] = SHARK_iP033[1] + $segup * 5.0;
    $SHARK_P034[1] = SHARK_iP034[1] + $segup * 5.0;
    $SHARK_P035[1] = SHARK_iP035[1] + $segup * 5.0;
    $SHARK_P036[1] = SHARK_iP036[1] + $segup * 5.0;
    $SHARK_P037[1] = SHARK_iP037[1] + $segup * 5.0;
    $SHARK_P038[1] = SHARK_iP038[1] + $segup * 5.0;
    $SHARK_P039[1] = SHARK_iP039[1] + $segup * 5.0;
    $SHARK_P040[1] = SHARK_iP040[1] + $segup * 5.0;
    $SHARK_P041[1] = SHARK_iP041[1] + $segup * 5.0;
    $SHARK_P042[1] = SHARK_iP042[1] + $segup * 5.0;
    $SHARK_P043[1] = SHARK_iP043[1] + $segup * 12.0;
    $SHARK_P044[1] = SHARK_iP044[1] + $segup * 12.0;
    $SHARK_P045[1] = SHARK_iP045[1] + $segup * 12.0;
    $SHARK_P046[1] = SHARK_iP046[1] + $segup * 12.0;
    $SHARK_P047[1] = SHARK_iP047[1] + $segup * 12.0;
    $SHARK_P048[1] = SHARK_iP048[1] + $segup * 12.0;
    $SHARK_P049[1] = SHARK_iP049[1] + $segup * 12.0;
    $SHARK_P050[1] = SHARK_iP050[1] + $segup * 12.0;
    $SHARK_P051[1] = SHARK_iP051[1] + $segup * 12.0;
    $SHARK_P052[1] = SHARK_iP052[1] + $segup * 12.0;
    $SHARK_P002[1] = SHARK_iP002[1] + $segup * 17.0;
    $SHARK_P061[1] = SHARK_iP061[1] + $segup * 17.0;
    $SHARK_P069[1] = SHARK_iP069[1] + $segup * 17.0;
    $SHARK_P070[1] = SHARK_iP070[1] + $segup * 17.0;

    glPushMatrix();

    glTranslatef(0.0, 0.0, -3000.0);

    $mat = glGetFloatv(GL_MODELVIEW_MATRIX);
    $n = 0;
    if ($mat[0][2] >= 0.0) {
        $n += 1;
    }
    if ($mat[1][2] >= 0.0) {
        $n += 2;
    }
    if ($mat[2][2] >= 0.0) {
        $n += 4;
    }
    glScalef(2.0, 1.0, 1.0);

    glEnable(GL_CULL_FACE);
    switch ($n) {
    case 0:
        Fish_1();
        break;
    case 1:
        Fish_2();
        break;
    case 2:
        Fish_3();
        break;
    case 3:
        Fish_4();
        break;
    case 4:
        Fish_5();
        break;
    case 5:
        Fish_6();
        break;
    case 6:
        Fish_7();
        break;
    case 7:
        Fish_8();
        break;
    }
    glDisable(GL_CULL_FACE);

    glPopMatrix();
}

sub FishTransform($fish)
{

    glTranslatef($fish.y
		 , $fish.z, -$fish.x);
    glRotatef(-$fish.psi, 0.0, 1.0, 0.0);
    glRotatef($fish.theta, 1.0, 0.0, 0.0);
    glRotatef(-$fish.phi, 0.0, 0.0, 1.0);
}

sub WhalePilot($fish)
{
    $fish.phi = -20.0;
    $fish.theta = 0.0;
    $fish.psi -= 0.5;

    $fish.x += WHALESPEED * $fish.v * cos($fish.psi / RAD) * cos($fish.theta / RAD);
    $fish.y
	+= WHALESPEED * $fish.v * sin($fish.psi / RAD) * cos($fish.theta / RAD);
    $fish.z += WHALESPEED * $fish.v * sin($fish.theta / RAD);
}

our $sign = 1;
sub SharkPilot($fish)
{
    my ($X, $Y, $Z, $tpsi, $ttheta, $thetal);

    $fish.xt = 60000.0;
    $fish.yt = 0.0;
    $fish.zt = 0.0;

    $X = $fish.xt - $fish.x;
    $Y = $fish.yt - $fish.y
	;
    $Z = $fish.zt - $fish.z;

    $thetal = $fish.theta;

    $ttheta = RAD * atan($Z / (sqrt($X * $X + $Y * $Y)));

    if ($ttheta > $fish.theta + 0.25) {
        $fish.theta += 0.5;
    } else if ($ttheta < $fish.theta - 0.25) {
        $fish.theta -= 0.5;
    }
    if ($fish.theta > 90.0) {
        $fish.theta = 90.0;
    }
    if ($fish.theta < -90.0) {
        $fish.theta = -90.0;
    }
    $fish.dtheta = $fish.theta - $thetal;

    $tpsi = RAD * atan2($Y, $X);

    $fish.attack = 0;

    if (abs($tpsi - $fish.psi) < 10.0) {
        $fish.attack = 1;
    } else if (abs($tpsi - $fish.psi) < 45.0) {
        if ($fish.psi > $tpsi) {
            $fish.psi -= 0.5;
            if ($fish.psi < -180.0) {
                $fish.psi += 360.0;
            }
        } else if ($fish.psi < $tpsi) {
            $fish.psi += 0.5;
            if ($fish.psi > 180.0) {
                $fish.psi -= 360.0;
            }
        }
    } else {
        if (rand() % 100 > 98) {
            $sign = 1 - $sign;
        }
        $fish.psi += $sign;
        if ($fish.psi > 180.0) {
            $fish.psi -= 360.0;
        }
        if ($fish.psi < -180.0) {
            $fish.psi += 360.0;
        }
    }

    if ($fish.attack) {
        if ($fish.v < 1.1) {
            $fish.spurt = 1;
        }
        if ($fish.spurt) {
            $fish.v += 0.2;
        }
        if ($fish.v > 5.0) {
            $fish.spurt = 0;
        }
        if (($fish.v > 1.0) && (!$fish.spurt)) {
            $fish.v -= 0.2;
        }
    } else {
        if (!(rand() % 400) && (!$fish.spurt)) {
            $fish.spurt = 1;
        }
        if ($fish.spurt) {
            $fish.v += 0.05;
        }
        if ($fish.v > 3.0) {
            $fish.spurt = 0;
        }
        if (($fish.v > 1.0) && (!$fish.spurt)) {
            $fish.v -= 0.05;
        }
    }

    $fish.x += SHARKSPEED * $fish.v * cos($fish.psi / RAD) * cos($fish.theta / RAD);
    $fish.y
	+= SHARKSPEED * $fish.v * sin($fish.psi / RAD) * cos($fish.theta / RAD);
    $fish.z += SHARKSPEED * $fish.v * sin($fish.theta / RAD);
}

sub SharkMiss($i)
{
    my $j;
    my ($avoid, $thetal);
    my ($X, $Y, $Z, $R);

    for ($j = 0; $j < NUM_SHARKS; $j++) {
        if ($j != $i) {
            $X = $sharks[$j].x - $sharks[$i].x;
            $Y = $sharks[$j].y
		- $sharks[$i].y
		;
            $Z = $sharks[$j].z - $sharks[$i].z;

            $R = sqrt($X * $X + $Y * $Y + $Z * $Z);

            $avoid = 1.0;
            $thetal = $sharks[$i].theta;

            if ($R < SHARKSIZE) {
                if ($Z > 0.0) {
                    $sharks[$i].theta -= $avoid;
                } else {
                    $sharks[$i].theta += $avoid;
                }
            }
            $sharks[$i].dtheta += ($sharks[$i].theta - $thetal);
        }
    }
}

const WHALE_N001 = (0.019249 ,0.011340 ,-0.999750);
const WHALE_N002 = (-0.132579 ,0.954547 ,0.266952);
const WHALE_N003 = (-0.196061 ,0.980392 ,-0.019778);
const WHALE_N004 = (0.695461 ,0.604704 ,0.388158);
const WHALE_N005 = (0.870600 ,0.425754 ,0.246557);
const WHALE_N006 = (-0.881191 ,0.392012 ,0.264251);
const WHALE_N008 = (-0.341437 ,0.887477 ,0.309523);
const WHALE_N009 = (0.124035 ,-0.992278 ,0.000000);
const WHALE_N010 = (0.242536 ,0.000000 ,-0.970143);
const WHALE_N011 = (0.588172 ,0.000000 ,0.808736);
const WHALE_N012 = (0.929824 ,-0.340623 ,-0.139298);
const WHALE_N013 = (0.954183 ,0.267108 ,-0.134865);
const WHALE_N014 = (0.495127 ,0.855436 ,-0.151914);
const WHALE_N015 = (-0.390199 ,0.906569 ,-0.160867);
const WHALE_N016 = (-0.923605 ,0.354581 ,-0.145692);
const WHALE_N017 = (-0.955796 ,-0.260667 ,-0.136036);
const WHALE_N018 = (-0.501283 ,-0.853462 ,-0.142540);
const WHALE_N019 = (0.405300 ,-0.901974 ,-0.148913);
const WHALE_N020 = (0.909913 ,-0.392746 ,-0.133451);
const WHALE_N021 = (0.936494 ,0.331147 ,-0.115414);
const WHALE_N022 = (0.600131 ,0.793724 ,-0.099222);
const WHALE_N023 = (-0.231556 ,0.968361 ,-0.093053);
const WHALE_N024 = (-0.844369 ,0.525330 ,-0.105211);
const WHALE_N025 = (-0.982725 ,-0.136329 ,-0.125164);
const WHALE_N026 = (-0.560844 ,-0.822654 ,-0.093241);
const WHALE_N027 = (0.263884 ,-0.959981 ,-0.093817);
const WHALE_N028 = (0.842057 ,-0.525192 ,-0.122938);
const WHALE_N029 = (0.921620 ,0.367565 ,-0.124546);
const WHALE_N030 = (0.613927 ,0.784109 ,-0.090918);
const WHALE_N031 = (-0.448754 ,0.888261 ,-0.098037);
const WHALE_N032 = (-0.891865 ,0.434376 ,-0.126077);
const WHALE_N033 = (-0.881447 ,-0.448017 ,-0.149437);
const WHALE_N034 = (-0.345647 ,-0.922057 ,-0.174183);
const WHALE_N035 = (0.307998 ,-0.941371 ,-0.137688);
const WHALE_N036 = (0.806316 ,-0.574647 ,-0.140124);
const WHALE_N037 = (0.961346 ,0.233646 ,-0.145681);
const WHALE_N038 = (0.488451 ,0.865586 ,-0.110351);
const WHALE_N039 = (-0.374290 ,0.921953 ,-0.099553);
const WHALE_N040 = (-0.928504 ,0.344533 ,-0.138485);
const WHALE_N041 = (-0.918419 ,-0.371792 ,-0.135189);
const WHALE_N042 = (-0.520666 ,-0.833704 ,-0.183968);
const WHALE_N043 = (0.339204 ,-0.920273 ,-0.195036);
const WHALE_N044 = (0.921475 ,-0.387382 ,-0.028636);
const WHALE_N045 = (0.842465 ,0.533335 ,-0.076204);
const WHALE_N046 = (0.380110 ,0.924939 ,0.002073);
const WHALE_N047 = (-0.276128 ,0.961073 ,-0.009579);
const WHALE_N048 = (-0.879684 ,0.473001 ,-0.049250);
const WHALE_N049 = (-0.947184 ,-0.317614 ,-0.044321);
const WHALE_N050 = (-0.642059 ,-0.764933 ,-0.051363);
const WHALE_N051 = (0.466794 ,-0.880921 ,-0.077990);
const WHALE_N052 = (0.898509 ,-0.432277 ,0.076279);
const WHALE_N053 = (0.938985 ,0.328141 ,0.103109);
const WHALE_N054 = (0.442420 ,0.895745 ,0.043647);
const WHALE_N055 = (-0.255163 ,0.966723 ,0.018407);
const WHALE_N056 = (-0.833769 ,0.540650 ,0.111924);
const WHALE_N057 = (-0.953653 ,-0.289939 ,0.080507);
const WHALE_N058 = (-0.672357 ,-0.730524 ,0.119461);
const WHALE_N059 = (0.522249 ,-0.846652 ,0.102157);
const WHALE_N060 = (0.885868 ,-0.427631 ,0.179914);
const WHALE_N062 = (0.648942 ,0.743116 ,0.163255);
const WHALE_N063 = (-0.578967 ,0.807730 ,0.111219);
const WHALE_N065 = (-0.909864 ,-0.352202 ,0.219321);
const WHALE_N066 = (-0.502541 ,-0.818090 ,0.279610);
const WHALE_N067 = (0.322919 ,-0.915358 ,0.240504);
const WHALE_N068 = (0.242536 ,0.000000 ,-0.970143);
const WHALE_N069 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N070 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N071 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N072 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N073 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N074 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N075 = (0.031220 ,0.999025 ,-0.031220);
const WHALE_N076 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N077 = (0.446821 ,0.893642 ,0.041889);
const WHALE_N078 = (0.863035 ,-0.100980 ,0.494949);
const WHALE_N079 = (0.585597 ,-0.808215 ,0.062174);
const WHALE_N080 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N081 = (1.000000 ,0.000000 ,0.000000);
const WHALE_N082 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N083 = (-1.000000 ,0.000000 ,0.000000);
const WHALE_N084 = (-0.478893 ,0.837129 ,-0.264343);
const WHALE_N085 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N086 = (0.763909 ,0.539455 ,-0.354163);
const WHALE_N087 = (0.446821 ,0.893642 ,0.041889);
const WHALE_N088 = (0.385134 ,-0.908288 ,0.163352);
const WHALE_N089 = (-0.605952 ,0.779253 ,-0.159961);
const WHALE_N090 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N091 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N092 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N093 = (0.000000 ,1.000000 ,0.000000);
const WHALE_N094 = (1.000000 ,0.000000 ,0.000000);
const WHALE_N095 = (-1.000000 ,0.000000 ,0.000000);
const WHALE_N096 = (0.644444 ,-0.621516 ,0.445433);
const WHALE_N097 = (-0.760896 ,-0.474416 ,0.442681);
const WHALE_N098 = (0.636888 ,-0.464314 ,0.615456);
const WHALE_N099 = (-0.710295 ,0.647038 ,0.277168);
const WHALE_N100 = (0.009604 ,0.993655 ,0.112063);
const WHALE_iP001 = (18.74, 13.19, 3.76);
our $WHALE_P001 = (18.74, 13.19, 3.76);
our $WHALE_P002 = (0.00, 390.42, 10292.57);
our $WHALE_P003 = (55.80, 622.31, 8254.35);
our $WHALE_P004 = (20.80, 247.66, 10652.13);
our $WHALE_P005 = (487.51, 198.05, 9350.78);
our $WHALE_P006 = (-457.61, 199.04, 9353.01);
our $WHALE_P008 = (-34.67, 247.64, 10663.71);
const WHALE_iP009 = (97.46, 67.63, 593.82);
const WHALE_iP010 = (-84.33, 67.63, 588.18);
const WHALE_iP011 = (118.69, 8.98, -66.91);
our $WHALE_P009 = (97.46, 67.63, 593.82);
our $WHALE_P010 = (-84.33, 67.63, 588.18);
our $WHALE_P011 = (118.69, 8.98, -66.91);
const WHALE_iP012 = (156.48, -31.95, 924.54);
const WHALE_iP013 = (162.00, 110.22, 924.54);
const WHALE_iP014 = (88.16, 221.65, 924.54);
const WHALE_iP015 = (-65.21, 231.16, 924.54);
const WHALE_iP016 = (-156.48, 121.97, 924.54);
const WHALE_iP017 = (-162.00, -23.93, 924.54);
const WHALE_iP018 = (-88.16, -139.10, 924.54);
const WHALE_iP019 = (65.21, -148.61, 924.54);
const WHALE_iP020 = (246.87, -98.73, 1783.04);
const WHALE_iP021 = (253.17, 127.76, 1783.04);
const WHALE_iP022 = (132.34, 270.77, 1783.04);
const WHALE_iP023 = (-97.88, 285.04, 1783.04);
const WHALE_iP024 = (-222.97, 139.80, 1783.04);
const WHALE_iP025 = (-225.29, -86.68, 1783.04);
const WHALE_iP026 = (-108.44, -224.15, 1783.04);
const WHALE_iP027 = (97.88, -221.56, 1783.04);
const WHALE_iP028 = (410.55, -200.66, 3213.87);
const WHALE_iP029 = (432.19, 148.42, 3213.87);
const WHALE_iP030 = (200.66, 410.55, 3213.87);
const WHALE_iP031 = (-148.42, 432.19, 3213.87);
const WHALE_iP032 = (-407.48, 171.88, 3213.87);
const WHALE_iP033 = (-432.19, -148.42, 3213.87);
const WHALE_iP034 = (-148.88, -309.74, 3213.87);
const WHALE_iP035 = (156.38, -320.17, 3213.87);
const WHALE_iP036 = (523.39, -303.81, 4424.57);
const WHALE_iP037 = (574.66, 276.84, 4424.57);
const WHALE_iP038 = (243.05, 492.50, 4424.57);
const WHALE_iP039 = (-191.23, 520.13, 4424.57);
const WHALE_iP040 = (-523.39, 304.01, 4424.57);
const WHALE_iP041 = (-574.66, -231.83, 4424.57);
const WHALE_iP042 = (-266.95, -578.17, 4424.57);
const WHALE_iP043 = (211.14, -579.67, 4424.57);
const WHALE_iP044 = (680.57, -370.27, 5943.46);
const WHALE_iP045 = (834.01, 363.09, 5943.46);
const WHALE_iP046 = (371.29, 614.13, 5943.46);
const WHALE_iP047 = (-291.43, 621.86, 5943.46);
const WHALE_iP048 = (-784.13, 362.60, 5943.46);
const WHALE_iP049 = (-743.29, -325.82, 5943.46);
const WHALE_iP050 = (-383.24, -804.77, 5943.46);
const WHALE_iP051 = (283.47, -846.09, 5943.46);
our $WHALE_P012 = (156.48, -31.95, 924.54);
our $WHALE_P013 = (162.00, 110.22, 924.54);
our $WHALE_P014 = (88.16, 221.65, 924.54);
our $WHALE_P015 = (-65.21, 231.16, 924.54);
our $WHALE_P016 = (-156.48, 121.97, 924.54);
our $WHALE_P017 = (-162.00, -23.93, 924.54);
our $WHALE_P018 = (-88.16, -139.10, 924.54);
our $WHALE_P019 = (65.21, -148.61, 924.54);
our $WHALE_P020 = (246.87, -98.73, 1783.04);
our $WHALE_P021 = (253.17, 127.76, 1783.04);
our $WHALE_P022 = (132.34, 270.77, 1783.04);
our $WHALE_P023 = (-97.88, 285.04, 1783.04);
our $WHALE_P024 = (-222.97, 139.80, 1783.04);
our $WHALE_P025 = (-225.29, -86.68, 1783.04);
our $WHALE_P026 = (-108.44, -224.15, 1783.04);
our $WHALE_P027 = (97.88, -221.56, 1783.04);
our $WHALE_P028 = (410.55, -200.66, 3213.87);
our $WHALE_P029 = (432.19, 148.42, 3213.87);
our $WHALE_P030 = (200.66, 410.55, 3213.87);
our $WHALE_P031 = (-148.42, 432.19, 3213.87);
our $WHALE_P032 = (-407.48, 171.88, 3213.87);
our $WHALE_P033 = (-432.19, -148.42, 3213.87);
our $WHALE_P034 = (-148.88, -309.74, 3213.87);
our $WHALE_P035 = (156.38, -320.17, 3213.87);
our $WHALE_P036 = (523.39, -303.81, 4424.57);
our $WHALE_P037 = (574.66, 276.84, 4424.57);
our $WHALE_P038 = (243.05, 492.50, 4424.57);
our $WHALE_P039 = (-191.23, 520.13, 4424.57);
our $WHALE_P040 = (-523.39, 304.01, 4424.57);
our $WHALE_P041 = (-574.66, -231.83, 4424.57);
our $WHALE_P042 = (-266.95, -578.17, 4424.57);
our $WHALE_P043 = (211.14, -579.67, 4424.57);
our $WHALE_P044 = (680.57, -370.27, 5943.46);
our $WHALE_P045 = (834.01, 363.09, 5943.46);
our $WHALE_P046 = (371.29, 614.13, 5943.46);
our $WHALE_P047 = (-291.43, 621.86, 5943.46);
our $WHALE_P048 = (-784.13, 362.60, 5943.46);
our $WHALE_P049 = (-743.29, -325.82, 5943.46);
our $WHALE_P050 = (-383.24, -804.77, 5943.46);
our $WHALE_P051 = (283.47, -846.09, 5943.46);
our $WHALE_P052 = (599.09, -332.24, 7902.59);
our $WHALE_P053 = (735.48, 306.26, 7911.92);
our $WHALE_P054 = (321.55, 558.53, 7902.59);
our $WHALE_P055 = (-260.54, 559.84, 7902.59);
our $WHALE_P056 = (-698.66, 320.83, 7902.59);
our $WHALE_P057 = (-643.29, -299.16, 7902.59);
our $WHALE_P058 = (-341.47, -719.30, 7902.59);
our $WHALE_P059 = (252.57, -756.12, 7902.59);
our $WHALE_P060 = (458.39, -265.31, 9355.44);
our $WHALE_P062 = (224.04, 438.98, 9364.77);
our $WHALE_P063 = (-165.71, 441.27, 9355.44);
our $WHALE_P065 = (-473.99, -219.71, 9355.44);
our $WHALE_P066 = (-211.97, -479.87, 9355.44);
our $WHALE_P067 = (192.86, -504.03, 9355.44);
const WHALE_iP068 = (-112.44, 9.25, -64.42);
const WHALE_iP069 = (1155.63, 0.00, -182.46);
const WHALE_iP070 = (-1143.13, 0.00, -181.54);
const WHALE_iP071 = (1424.23, 0.00, -322.09);
const WHALE_iP072 = (-1368.01, 0.00, -310.38);
const WHALE_iP073 = (1255.57, 2.31, 114.05);
const WHALE_iP074 = (-1149.38, 0.00, 117.12);
const WHALE_iP075 = (718.36, 0.00, 433.36);
const WHALE_iP076 = (-655.90, 0.00, 433.36);
our $WHALE_P068 = (-112.44, 9.25, -64.42);
our $WHALE_P069 = (1155.63, 0.00, -182.46);
our $WHALE_P070 = (-1143.13, 0.00, -181.54);
our $WHALE_P071 = (1424.23, 0.00, -322.09);
our $WHALE_P072 = (-1368.01, 0.00, -310.38);
our $WHALE_P073 = (1255.57, 2.31, 114.05);
our $WHALE_P074 = (-1149.38, 0.00, 117.12);
our $WHALE_P075 = (718.36, 0.00, 433.36);
our $WHALE_P076 = (-655.90, 0.00, 433.36);
our $WHALE_P077 = (1058.00, -2.66, 7923.51);
our $WHALE_P078 = (-1016.51, -15.47, 7902.87);
our $WHALE_P079 = (-1363.99, -484.50, 7593.38);
our $WHALE_P080 = (1478.09, -861.47, 7098.12);
our $WHALE_P081 = (1338.06, -284.68, 7024.15);
our $WHALE_P082 = (-1545.51, -860.64, 7106.60);
our $WHALE_P083 = (1063.19, -70.46, 7466.60);
our $WHALE_P084 = (-1369.18, -288.11, 7015.34);
our $WHALE_P085 = (1348.44, -482.50, 7591.41);
our $WHALE_P086 = (-1015.45, -96.80, 7474.86);
our $WHALE_P087 = (731.04, 148.38, 7682.58);
our $WHALE_P088 = (-697.03, 151.82, 7668.81);
our $WHALE_P089 = (-686.82, 157.09, 7922.29);
our $WHALE_P090 = (724.73, 147.75, 7931.39);
const WHALE_iP091 = (0.00, 327.10, 2346.55);
const WHALE_iP092 = (0.00, 552.28, 2311.31);
const WHALE_iP093 = (0.00, 721.16, 2166.41);
const WHALE_iP094 = (0.00, 693.42, 2388.80);
const WHALE_iP095 = (0.00, 389.44, 2859.97);
our $WHALE_P091 = (0.00, 327.10, 2346.55);
our $WHALE_P092 = (0.00, 552.28, 2311.31);
our $WHALE_P093 = (0.00, 721.16, 2166.41);
our $WHALE_P094 = (0.00, 693.42, 2388.80);
our $WHALE_P095 = (0.00, 389.44, 2859.97);
const WHALE_iP096 = (222.02, -183.67, 10266.89);
const WHALE_iP097 = (-128.90, -182.70, 10266.89);
const WHALE_iP098 = (41.04, 88.31, 10659.36);
const WHALE_iP099 = (-48.73, 88.30, 10659.36);
our $WHALE_P096 = (222.02, -183.67, 10266.89);
our $WHALE_P097 = (-128.90, -182.70, 10266.89);
our $WHALE_P098 = (41.04, 88.31, 10659.36);
our $WHALE_P099 = (-48.73, 88.30, 10659.36);
our $WHALE_P100 = (0.00, 603.42, 9340.68);
our $WHALE_P104 = (-9.86, 567.62, 7858.65);
our $WHALE_P105 = (31.96, 565.27, 7908.46);
our $WHALE_P106 = (22.75, 568.13, 7782.83);
our $WHALE_P107 = (58.93, 568.42, 7775.94);
our $WHALE_P108 = (55.91, 565.59, 7905.86);
our $WHALE_P109 = (99.21, 566.00, 7858.65);
our $WHALE_P110 = (-498.83, 148.14, 9135.10);
our $WHALE_P111 = (-495.46, 133.24, 9158.48);
our $WHALE_P112 = (-490.82, 146.23, 9182.76);
our $WHALE_P113 = (-489.55, 174.11, 9183.66);
our $WHALE_P114 = (-492.92, 189.00, 9160.28);
our $WHALE_P115 = (-497.56, 176.02, 9136.00);
our $WHALE_P116 = (526.54, 169.68, 9137.70);
our $WHALE_P117 = (523.49, 184.85, 9161.42);
our $WHALE_P118 = (518.56, 171.78, 9186.06);
our $WHALE_P119 = (516.68, 143.53, 9186.98);
our $WHALE_P120 = (519.73, 128.36, 9163.26);
our $WHALE_P121 = (524.66, 141.43, 9138.62);

sub Whale001()
{

    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N068);
    glVertex3fv($WHALE_P068);
    glNormal3fv(WHALE_N010);
    glVertex3fv($WHALE_P010);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N068);
    glVertex3fv($WHALE_P068);
    glNormal3fv(WHALE_N076);
    glVertex3fv($WHALE_P076);
    glNormal3fv(WHALE_N010);
    glVertex3fv($WHALE_P010);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N068);
    glVertex3fv($WHALE_P068);
    glNormal3fv(WHALE_N070);
    glVertex3fv($WHALE_P070);
    glNormal3fv(WHALE_N076);
    glVertex3fv($WHALE_P076);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N076);
    glVertex3fv($WHALE_P076);
    glNormal3fv(WHALE_N070);
    glVertex3fv($WHALE_P070);
    glNormal3fv(WHALE_N074);
    glVertex3fv($WHALE_P074);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N070);
    glVertex3fv($WHALE_P070);
    glNormal3fv(WHALE_N072);
    glVertex3fv($WHALE_P072);
    glNormal3fv(WHALE_N074);
    glVertex3fv($WHALE_P074);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N072);
    glVertex3fv($WHALE_P072);
    glNormal3fv(WHALE_N070);
    glVertex3fv($WHALE_P070);
    glNormal3fv(WHALE_N074);
    glVertex3fv($WHALE_P074);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N074);
    glVertex3fv($WHALE_P074);
    glNormal3fv(WHALE_N070);
    glVertex3fv($WHALE_P070);
    glNormal3fv(WHALE_N076);
    glVertex3fv($WHALE_P076);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N070);
    glVertex3fv($WHALE_P070);
    glNormal3fv(WHALE_N068);
    glVertex3fv($WHALE_P068);
    glNormal3fv(WHALE_N076);
    glVertex3fv($WHALE_P076);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N076);
    glVertex3fv($WHALE_P076);
    glNormal3fv(WHALE_N068);
    glVertex3fv($WHALE_P068);
    glNormal3fv(WHALE_N010);
    glVertex3fv($WHALE_P010);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N068);
    glVertex3fv($WHALE_P068);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N010);
    glVertex3fv($WHALE_P010);
    glEnd();
}

sub Whale002()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N011);
    glVertex3fv($WHALE_P011);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N009);
    glVertex3fv($WHALE_P009);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N075);
    glVertex3fv($WHALE_P075);
    glNormal3fv(WHALE_N011);
    glVertex3fv($WHALE_P011);
    glNormal3fv(WHALE_N009);
    glVertex3fv($WHALE_P009);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N069);
    glVertex3fv($WHALE_P069);
    glNormal3fv(WHALE_N011);
    glVertex3fv($WHALE_P011);
    glNormal3fv(WHALE_N075);
    glVertex3fv($WHALE_P075);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N069);
    glVertex3fv($WHALE_P069);
    glNormal3fv(WHALE_N075);
    glVertex3fv($WHALE_P075);
    glNormal3fv(WHALE_N073);
    glVertex3fv($WHALE_P073);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N071);
    glVertex3fv($WHALE_P071);
    glNormal3fv(WHALE_N069);
    glVertex3fv($WHALE_P069);
    glNormal3fv(WHALE_N073);
    glVertex3fv($WHALE_P073);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N011);
    glVertex3fv($WHALE_P011);
    glNormal3fv(WHALE_N009);
    glVertex3fv($WHALE_P009);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N009);
    glVertex3fv($WHALE_P009);
    glNormal3fv(WHALE_N011);
    glVertex3fv($WHALE_P011);
    glNormal3fv(WHALE_N075);
    glVertex3fv($WHALE_P075);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N011);
    glVertex3fv($WHALE_P011);
    glNormal3fv(WHALE_N069);
    glVertex3fv($WHALE_P069);
    glNormal3fv(WHALE_N075);
    glVertex3fv($WHALE_P075);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N069);
    glVertex3fv($WHALE_P069);
    glNormal3fv(WHALE_N073);
    glVertex3fv($WHALE_P073);
    glNormal3fv(WHALE_N075);
    glVertex3fv($WHALE_P075);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N069);
    glVertex3fv($WHALE_P069);
    glNormal3fv(WHALE_N071);
    glVertex3fv($WHALE_P071);
    glNormal3fv(WHALE_N073);
    glVertex3fv($WHALE_P073);
    glEnd();
}

sub Whale003()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N018);
    glVertex3fv($WHALE_P018);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N019);
    glVertex3fv($WHALE_P019);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N019);
    glVertex3fv($WHALE_P019);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N012);
    glVertex3fv($WHALE_P012);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N017);
    glVertex3fv($WHALE_P017);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N018);
    glVertex3fv($WHALE_P018);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N017);
    glVertex3fv($WHALE_P017);
    glNormal3fv(WHALE_N016);
    glVertex3fv($WHALE_P016);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N013);
    glVertex3fv($WHALE_P013);
    glNormal3fv(WHALE_N012);
    glVertex3fv($WHALE_P012);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N016);
    glVertex3fv($WHALE_P016);
    glNormal3fv(WHALE_N015);
    glVertex3fv($WHALE_P015);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N014);
    glVertex3fv($WHALE_P014);
    glNormal3fv(WHALE_N013);
    glVertex3fv($WHALE_P013);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N001);
    glVertex3fv($WHALE_P001);
    glNormal3fv(WHALE_N015);
    glVertex3fv($WHALE_P015);
    glNormal3fv(WHALE_N014);
    glVertex3fv($WHALE_P014);
    glEnd();
}

sub Whale004()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N014);
    glVertex3fv($WHALE_P014);
    glNormal3fv(WHALE_N015);
    glVertex3fv($WHALE_P015);
    glNormal3fv(WHALE_N023);
    glVertex3fv($WHALE_P023);
    glNormal3fv(WHALE_N022);
    glVertex3fv($WHALE_P022);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N015);
    glVertex3fv($WHALE_P015);
    glNormal3fv(WHALE_N016);
    glVertex3fv($WHALE_P016);
    glNormal3fv(WHALE_N024);
    glVertex3fv($WHALE_P024);
    glNormal3fv(WHALE_N023);
    glVertex3fv($WHALE_P023);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N016);
    glVertex3fv($WHALE_P016);
    glNormal3fv(WHALE_N017);
    glVertex3fv($WHALE_P017);
    glNormal3fv(WHALE_N025);
    glVertex3fv($WHALE_P025);
    glNormal3fv(WHALE_N024);
    glVertex3fv($WHALE_P024);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N017);
    glVertex3fv($WHALE_P017);
    glNormal3fv(WHALE_N018);
    glVertex3fv($WHALE_P018);
    glNormal3fv(WHALE_N026);
    glVertex3fv($WHALE_P026);
    glNormal3fv(WHALE_N025);
    glVertex3fv($WHALE_P025);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N013);
    glVertex3fv($WHALE_P013);
    glNormal3fv(WHALE_N014);
    glVertex3fv($WHALE_P014);
    glNormal3fv(WHALE_N022);
    glVertex3fv($WHALE_P022);
    glNormal3fv(WHALE_N021);
    glVertex3fv($WHALE_P021);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N012);
    glVertex3fv($WHALE_P012);
    glNormal3fv(WHALE_N013);
    glVertex3fv($WHALE_P013);
    glNormal3fv(WHALE_N021);
    glVertex3fv($WHALE_P021);
    glNormal3fv(WHALE_N020);
    glVertex3fv($WHALE_P020);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N018);
    glVertex3fv($WHALE_P018);
    glNormal3fv(WHALE_N019);
    glVertex3fv($WHALE_P019);
    glNormal3fv(WHALE_N027);
    glVertex3fv($WHALE_P027);
    glNormal3fv(WHALE_N026);
    glVertex3fv($WHALE_P026);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N019);
    glVertex3fv($WHALE_P019);
    glNormal3fv(WHALE_N012);
    glVertex3fv($WHALE_P012);
    glNormal3fv(WHALE_N020);
    glVertex3fv($WHALE_P020);
    glNormal3fv(WHALE_N027);
    glVertex3fv($WHALE_P027);
    glEnd();
}

sub Whale005()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N022);
    glVertex3fv($WHALE_P022);
    glNormal3fv(WHALE_N023);
    glVertex3fv($WHALE_P023);
    glNormal3fv(WHALE_N031);
    glVertex3fv($WHALE_P031);
    glNormal3fv(WHALE_N030);
    glVertex3fv($WHALE_P030);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N021);
    glVertex3fv($WHALE_P021);
    glNormal3fv(WHALE_N022);
    glVertex3fv($WHALE_P022);
    glNormal3fv(WHALE_N030);
    glVertex3fv($WHALE_P030);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N021);
    glVertex3fv($WHALE_P021);
    glNormal3fv(WHALE_N030);
    glVertex3fv($WHALE_P030);
    glNormal3fv(WHALE_N029);
    glVertex3fv($WHALE_P029);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N023);
    glVertex3fv($WHALE_P023);
    glNormal3fv(WHALE_N024);
    glVertex3fv($WHALE_P024);
    glNormal3fv(WHALE_N031);
    glVertex3fv($WHALE_P031);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N024);
    glVertex3fv($WHALE_P024);
    glNormal3fv(WHALE_N032);
    glVertex3fv($WHALE_P032);
    glNormal3fv(WHALE_N031);
    glVertex3fv($WHALE_P031);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N024);
    glVertex3fv($WHALE_P024);
    glNormal3fv(WHALE_N025);
    glVertex3fv($WHALE_P025);
    glNormal3fv(WHALE_N032);
    glVertex3fv($WHALE_P032);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N025);
    glVertex3fv($WHALE_P025);
    glNormal3fv(WHALE_N033);
    glVertex3fv($WHALE_P033);
    glNormal3fv(WHALE_N032);
    glVertex3fv($WHALE_P032);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N020);
    glVertex3fv($WHALE_P020);
    glNormal3fv(WHALE_N021);
    glVertex3fv($WHALE_P021);
    glNormal3fv(WHALE_N029);
    glVertex3fv($WHALE_P029);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N020);
    glVertex3fv($WHALE_P020);
    glNormal3fv(WHALE_N029);
    glVertex3fv($WHALE_P029);
    glNormal3fv(WHALE_N028);
    glVertex3fv($WHALE_P028);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N027);
    glVertex3fv($WHALE_P027);
    glNormal3fv(WHALE_N020);
    glVertex3fv($WHALE_P020);
    glNormal3fv(WHALE_N028);
    glVertex3fv($WHALE_P028);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N027);
    glVertex3fv($WHALE_P027);
    glNormal3fv(WHALE_N028);
    glVertex3fv($WHALE_P028);
    glNormal3fv(WHALE_N035);
    glVertex3fv($WHALE_P035);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N025);
    glVertex3fv($WHALE_P025);
    glNormal3fv(WHALE_N026);
    glVertex3fv($WHALE_P026);
    glNormal3fv(WHALE_N033);
    glVertex3fv($WHALE_P033);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N033);
    glVertex3fv($WHALE_P033);
    glNormal3fv(WHALE_N026);
    glVertex3fv($WHALE_P026);
    glNormal3fv(WHALE_N034);
    glVertex3fv($WHALE_P034);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N026);
    glVertex3fv($WHALE_P026);
    glNormal3fv(WHALE_N027);
    glVertex3fv($WHALE_P027);
    glNormal3fv(WHALE_N035);
    glVertex3fv($WHALE_P035);
    glNormal3fv(WHALE_N034);
    glVertex3fv($WHALE_P034);
    glEnd();
}

sub Whale006()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N092);
    glVertex3fv($WHALE_P092);
    glNormal3fv(WHALE_N093);
    glVertex3fv($WHALE_P093);
    glNormal3fv(WHALE_N094);
    glVertex3fv($WHALE_P094);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N093);
    glVertex3fv($WHALE_P093);
    glNormal3fv(WHALE_N092);
    glVertex3fv($WHALE_P092);
    glNormal3fv(WHALE_N094);
    glVertex3fv($WHALE_P094);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N092);
    glVertex3fv($WHALE_P092);
    glNormal3fv(WHALE_N091);
    glVertex3fv($WHALE_P091);
    glNormal3fv(WHALE_N095);
    glVertex3fv($WHALE_P095);
    glNormal3fv(WHALE_N094);
    glVertex3fv($WHALE_P094);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N091);
    glVertex3fv($WHALE_P091);
    glNormal3fv(WHALE_N092);
    glVertex3fv($WHALE_P092);
    glNormal3fv(WHALE_N094);
    glVertex3fv($WHALE_P094);
    glNormal3fv(WHALE_N095);
    glVertex3fv($WHALE_P095);
    glEnd();
}

sub Whale007()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N030);
    glVertex3fv($WHALE_P030);
    glNormal3fv(WHALE_N031);
    glVertex3fv($WHALE_P031);
    glNormal3fv(WHALE_N039);
    glVertex3fv($WHALE_P039);
    glNormal3fv(WHALE_N038);
    glVertex3fv($WHALE_P038);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N029);
    glVertex3fv($WHALE_P029);
    glNormal3fv(WHALE_N030);
    glVertex3fv($WHALE_P030);
    glNormal3fv(WHALE_N038);
    glVertex3fv($WHALE_P038);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N029);
    glVertex3fv($WHALE_P029);
    glNormal3fv(WHALE_N038);
    glVertex3fv($WHALE_P038);
    glNormal3fv(WHALE_N037);
    glVertex3fv($WHALE_P037);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N028);
    glVertex3fv($WHALE_P028);
    glNormal3fv(WHALE_N029);
    glVertex3fv($WHALE_P029);
    glNormal3fv(WHALE_N037);
    glVertex3fv($WHALE_P037);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N028);
    glVertex3fv($WHALE_P028);
    glNormal3fv(WHALE_N037);
    glVertex3fv($WHALE_P037);
    glNormal3fv(WHALE_N036);
    glVertex3fv($WHALE_P036);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N035);
    glVertex3fv($WHALE_P035);
    glNormal3fv(WHALE_N028);
    glVertex3fv($WHALE_P028);
    glNormal3fv(WHALE_N036);
    glVertex3fv($WHALE_P036);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N035);
    glVertex3fv($WHALE_P035);
    glNormal3fv(WHALE_N036);
    glVertex3fv($WHALE_P036);
    glNormal3fv(WHALE_N043);
    glVertex3fv($WHALE_P043);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N034);
    glVertex3fv($WHALE_P034);
    glNormal3fv(WHALE_N035);
    glVertex3fv($WHALE_P035);
    glNormal3fv(WHALE_N043);
    glVertex3fv($WHALE_P043);
    glNormal3fv(WHALE_N042);
    glVertex3fv($WHALE_P042);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N033);
    glVertex3fv($WHALE_P033);
    glNormal3fv(WHALE_N034);
    glVertex3fv($WHALE_P034);
    glNormal3fv(WHALE_N042);
    glVertex3fv($WHALE_P042);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N033);
    glVertex3fv($WHALE_P033);
    glNormal3fv(WHALE_N042);
    glVertex3fv($WHALE_P042);
    glNormal3fv(WHALE_N041);
    glVertex3fv($WHALE_P041);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N031);
    glVertex3fv($WHALE_P031);
    glNormal3fv(WHALE_N032);
    glVertex3fv($WHALE_P032);
    glNormal3fv(WHALE_N039);
    glVertex3fv($WHALE_P039);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N039);
    glVertex3fv($WHALE_P039);
    glNormal3fv(WHALE_N032);
    glVertex3fv($WHALE_P032);
    glNormal3fv(WHALE_N040);
    glVertex3fv($WHALE_P040);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N032);
    glVertex3fv($WHALE_P032);
    glNormal3fv(WHALE_N033);
    glVertex3fv($WHALE_P033);
    glNormal3fv(WHALE_N040);
    glVertex3fv($WHALE_P040);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N040);
    glVertex3fv($WHALE_P040);
    glNormal3fv(WHALE_N033);
    glVertex3fv($WHALE_P033);
    glNormal3fv(WHALE_N041);
    glVertex3fv($WHALE_P041);
    glEnd();
}

sub Whale008()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N042);
    glVertex3fv($WHALE_P042);
    glNormal3fv(WHALE_N043);
    glVertex3fv($WHALE_P043);
    glNormal3fv(WHALE_N051);
    glVertex3fv($WHALE_P051);
    glNormal3fv(WHALE_N050);
    glVertex3fv($WHALE_P050);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N043);
    glVertex3fv($WHALE_P043);
    glNormal3fv(WHALE_N036);
    glVertex3fv($WHALE_P036);
    glNormal3fv(WHALE_N051);
    glVertex3fv($WHALE_P051);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N051);
    glVertex3fv($WHALE_P051);
    glNormal3fv(WHALE_N036);
    glVertex3fv($WHALE_P036);
    glNormal3fv(WHALE_N044);
    glVertex3fv($WHALE_P044);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N041);
    glVertex3fv($WHALE_P041);
    glNormal3fv(WHALE_N042);
    glVertex3fv($WHALE_P042);
    glNormal3fv(WHALE_N050);
    glVertex3fv($WHALE_P050);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N041);
    glVertex3fv($WHALE_P041);
    glNormal3fv(WHALE_N050);
    glVertex3fv($WHALE_P050);
    glNormal3fv(WHALE_N049);
    glVertex3fv($WHALE_P049);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N036);
    glVertex3fv($WHALE_P036);
    glNormal3fv(WHALE_N037);
    glVertex3fv($WHALE_P037);
    glNormal3fv(WHALE_N044);
    glVertex3fv($WHALE_P044);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N044);
    glVertex3fv($WHALE_P044);
    glNormal3fv(WHALE_N037);
    glVertex3fv($WHALE_P037);
    glNormal3fv(WHALE_N045);
    glVertex3fv($WHALE_P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N040);
    glVertex3fv($WHALE_P040);
    glNormal3fv(WHALE_N041);
    glVertex3fv($WHALE_P041);
    glNormal3fv(WHALE_N049);
    glVertex3fv($WHALE_P049);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N040);
    glVertex3fv($WHALE_P040);
    glNormal3fv(WHALE_N049);
    glVertex3fv($WHALE_P049);
    glNormal3fv(WHALE_N048);
    glVertex3fv($WHALE_P048);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N039);
    glVertex3fv($WHALE_P039);
    glNormal3fv(WHALE_N040);
    glVertex3fv($WHALE_P040);
    glNormal3fv(WHALE_N048);
    glVertex3fv($WHALE_P048);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N039);
    glVertex3fv($WHALE_P039);
    glNormal3fv(WHALE_N048);
    glVertex3fv($WHALE_P048);
    glNormal3fv(WHALE_N047);
    glVertex3fv($WHALE_P047);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N037);
    glVertex3fv($WHALE_P037);
    glNormal3fv(WHALE_N038);
    glVertex3fv($WHALE_P038);
    glNormal3fv(WHALE_N045);
    glVertex3fv($WHALE_P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N038);
    glVertex3fv($WHALE_P038);
    glNormal3fv(WHALE_N046);
    glVertex3fv($WHALE_P046);
    glNormal3fv(WHALE_N045);
    glVertex3fv($WHALE_P045);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N038);
    glVertex3fv($WHALE_P038);
    glNormal3fv(WHALE_N039);
    glVertex3fv($WHALE_P039);
    glNormal3fv(WHALE_N047);
    glVertex3fv($WHALE_P047);
    glNormal3fv(WHALE_N046);
    glVertex3fv($WHALE_P046);
    glEnd();
}

sub Whale009()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N050);
    glVertex3fv($WHALE_P050);
    glNormal3fv(WHALE_N051);
    glVertex3fv($WHALE_P051);
    glNormal3fv(WHALE_N059);
    glVertex3fv($WHALE_P059);
    glNormal3fv(WHALE_N058);
    glVertex3fv($WHALE_P058);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N051);
    glVertex3fv($WHALE_P051);
    glNormal3fv(WHALE_N044);
    glVertex3fv($WHALE_P044);
    glNormal3fv(WHALE_N059);
    glVertex3fv($WHALE_P059);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N059);
    glVertex3fv($WHALE_P059);
    glNormal3fv(WHALE_N044);
    glVertex3fv($WHALE_P044);
    glNormal3fv(WHALE_N052);
    glVertex3fv($WHALE_P052);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N044);
    glVertex3fv($WHALE_P044);
    glNormal3fv(WHALE_N045);
    glVertex3fv($WHALE_P045);
    glNormal3fv(WHALE_N053);
    glVertex3fv($WHALE_P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N044);
    glVertex3fv($WHALE_P044);
    glNormal3fv(WHALE_N053);
    glVertex3fv($WHALE_P053);
    glNormal3fv(WHALE_N052);
    glVertex3fv($WHALE_P052);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N049);
    glVertex3fv($WHALE_P049);
    glNormal3fv(WHALE_N050);
    glVertex3fv($WHALE_P050);
    glNormal3fv(WHALE_N058);
    glVertex3fv($WHALE_P058);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N049);
    glVertex3fv($WHALE_P049);
    glNormal3fv(WHALE_N058);
    glVertex3fv($WHALE_P058);
    glNormal3fv(WHALE_N057);
    glVertex3fv($WHALE_P057);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N048);
    glVertex3fv($WHALE_P048);
    glNormal3fv(WHALE_N049);
    glVertex3fv($WHALE_P049);
    glNormal3fv(WHALE_N057);
    glVertex3fv($WHALE_P057);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N048);
    glVertex3fv($WHALE_P048);
    glNormal3fv(WHALE_N057);
    glVertex3fv($WHALE_P057);
    glNormal3fv(WHALE_N056);
    glVertex3fv($WHALE_P056);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N047);
    glVertex3fv($WHALE_P047);
    glNormal3fv(WHALE_N048);
    glVertex3fv($WHALE_P048);
    glNormal3fv(WHALE_N056);
    glVertex3fv($WHALE_P056);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N047);
    glVertex3fv($WHALE_P047);
    glNormal3fv(WHALE_N056);
    glVertex3fv($WHALE_P056);
    glNormal3fv(WHALE_N055);
    glVertex3fv($WHALE_P055);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N045);
    glVertex3fv($WHALE_P045);
    glNormal3fv(WHALE_N046);
    glVertex3fv($WHALE_P046);
    glNormal3fv(WHALE_N053);
    glVertex3fv($WHALE_P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N046);
    glVertex3fv($WHALE_P046);
    glNormal3fv(WHALE_N054);
    glVertex3fv($WHALE_P054);
    glNormal3fv(WHALE_N053);
    glVertex3fv($WHALE_P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N046);
    glVertex3fv($WHALE_P046);
    glNormal3fv(WHALE_N047);
    glVertex3fv($WHALE_P047);
    glNormal3fv(WHALE_N055);
    glVertex3fv($WHALE_P055);
    glNormal3fv(WHALE_N054);
    glVertex3fv($WHALE_P054);
    glEnd();
}

sub Whale010()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N080);
    glVertex3fv($WHALE_P080);
    glNormal3fv(WHALE_N081);
    glVertex3fv($WHALE_P081);
    glNormal3fv(WHALE_N085);
    glVertex3fv($WHALE_P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N081);
    glVertex3fv($WHALE_P081);
    glNormal3fv(WHALE_N083);
    glVertex3fv($WHALE_P083);
    glNormal3fv(WHALE_N085);
    glVertex3fv($WHALE_P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N085);
    glVertex3fv($WHALE_P085);
    glNormal3fv(WHALE_N083);
    glVertex3fv($WHALE_P083);
    glNormal3fv(WHALE_N077);
    glVertex3fv($WHALE_P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N083);
    glVertex3fv($WHALE_P083);
    glNormal3fv(WHALE_N087);
    glVertex3fv($WHALE_P087);
    glNormal3fv(WHALE_N077);
    glVertex3fv($WHALE_P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N077);
    glVertex3fv($WHALE_P077);
    glNormal3fv(WHALE_N087);
    glVertex3fv($WHALE_P087);
    glNormal3fv(WHALE_N090);
    glVertex3fv($WHALE_P090);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N081);
    glVertex3fv($WHALE_P081);
    glNormal3fv(WHALE_N080);
    glVertex3fv($WHALE_P080);
    glNormal3fv(WHALE_N085);
    glVertex3fv($WHALE_P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N083);
    glVertex3fv($WHALE_P083);
    glNormal3fv(WHALE_N081);
    glVertex3fv($WHALE_P081);
    glNormal3fv(WHALE_N085);
    glVertex3fv($WHALE_P085);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N083);
    glVertex3fv($WHALE_P083);
    glNormal3fv(WHALE_N085);
    glVertex3fv($WHALE_P085);
    glNormal3fv(WHALE_N077);
    glVertex3fv($WHALE_P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N087);
    glVertex3fv($WHALE_P087);
    glNormal3fv(WHALE_N083);
    glVertex3fv($WHALE_P083);
    glNormal3fv(WHALE_N077);
    glVertex3fv($WHALE_P077);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N087);
    glVertex3fv($WHALE_P087);
    glNormal3fv(WHALE_N077);
    glVertex3fv($WHALE_P077);
    glNormal3fv(WHALE_N090);
    glVertex3fv($WHALE_P090);
    glEnd();
}

sub Whale011()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N082);
    glVertex3fv($WHALE_P082);
    glNormal3fv(WHALE_N084);
    glVertex3fv($WHALE_P084);
    glNormal3fv(WHALE_N079);
    glVertex3fv($WHALE_P079);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N084);
    glVertex3fv($WHALE_P084);
    glNormal3fv(WHALE_N086);
    glVertex3fv($WHALE_P086);
    glNormal3fv(WHALE_N079);
    glVertex3fv($WHALE_P079);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N079);
    glVertex3fv($WHALE_P079);
    glNormal3fv(WHALE_N086);
    glVertex3fv($WHALE_P086);
    glNormal3fv(WHALE_N078);
    glVertex3fv($WHALE_P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N086);
    glVertex3fv($WHALE_P086);
    glNormal3fv(WHALE_N088);
    glVertex3fv($WHALE_P088);
    glNormal3fv(WHALE_N078);
    glVertex3fv($WHALE_P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N078);
    glVertex3fv($WHALE_P078);
    glNormal3fv(WHALE_N088);
    glVertex3fv($WHALE_P088);
    glNormal3fv(WHALE_N089);
    glVertex3fv($WHALE_P089);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N088);
    glVertex3fv($WHALE_P088);
    glNormal3fv(WHALE_N086);
    glVertex3fv($WHALE_P086);
    glNormal3fv(WHALE_N089);
    glVertex3fv($WHALE_P089);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N089);
    glVertex3fv($WHALE_P089);
    glNormal3fv(WHALE_N086);
    glVertex3fv($WHALE_P086);
    glNormal3fv(WHALE_N078);
    glVertex3fv($WHALE_P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N086);
    glVertex3fv($WHALE_P086);
    glNormal3fv(WHALE_N084);
    glVertex3fv($WHALE_P084);
    glNormal3fv(WHALE_N078);
    glVertex3fv($WHALE_P078);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N078);
    glVertex3fv($WHALE_P078);
    glNormal3fv(WHALE_N084);
    glVertex3fv($WHALE_P084);
    glNormal3fv(WHALE_N079);
    glVertex3fv($WHALE_P079);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N084);
    glVertex3fv($WHALE_P084);
    glNormal3fv(WHALE_N082);
    glVertex3fv($WHALE_P082);
    glNormal3fv(WHALE_N079);
    glVertex3fv($WHALE_P079);
    glEnd();
}

sub Whale012()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N058);
    glVertex3fv($WHALE_P058);
    glNormal3fv(WHALE_N059);
    glVertex3fv($WHALE_P059);
    glNormal3fv(WHALE_N067);
    glVertex3fv($WHALE_P067);
    glNormal3fv(WHALE_N066);
    glVertex3fv($WHALE_P066);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N059);
    glVertex3fv($WHALE_P059);
    glNormal3fv(WHALE_N052);
    glVertex3fv($WHALE_P052);
    glNormal3fv(WHALE_N060);
    glVertex3fv($WHALE_P060);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N059);
    glVertex3fv($WHALE_P059);
    glNormal3fv(WHALE_N060);
    glVertex3fv($WHALE_P060);
    glNormal3fv(WHALE_N067);
    glVertex3fv($WHALE_P067);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N058);
    glVertex3fv($WHALE_P058);
    glNormal3fv(WHALE_N066);
    glVertex3fv($WHALE_P066);
    glNormal3fv(WHALE_N065);
    glVertex3fv($WHALE_P065);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N058);
    glVertex3fv($WHALE_P058);
    glNormal3fv(WHALE_N065);
    glVertex3fv($WHALE_P065);
    glNormal3fv(WHALE_N057);
    glVertex3fv($WHALE_P057);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N056);
    glVertex3fv($WHALE_P056);
    glNormal3fv(WHALE_N057);
    glVertex3fv($WHALE_P057);
    glNormal3fv(WHALE_N065);
    glVertex3fv($WHALE_P065);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N056);
    glVertex3fv($WHALE_P056);
    glNormal3fv(WHALE_N065);
    glVertex3fv($WHALE_P065);
    glNormal3fv(WHALE_N006);
    glVertex3fv($WHALE_P006);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N056);
    glVertex3fv($WHALE_P056);
    glNormal3fv(WHALE_N006);
    glVertex3fv($WHALE_P006);
    glNormal3fv(WHALE_N063);
    glVertex3fv($WHALE_P063);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N056);
    glVertex3fv($WHALE_P056);
    glNormal3fv(WHALE_N063);
    glVertex3fv($WHALE_P063);
    glNormal3fv(WHALE_N055);
    glVertex3fv($WHALE_P055);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N054);
    glVertex3fv($WHALE_P054);
    glNormal3fv(WHALE_N062);
    glVertex3fv($WHALE_P062);
    glNormal3fv(WHALE_N005);
    glVertex3fv($WHALE_P005);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N054);
    glVertex3fv($WHALE_P054);
    glNormal3fv(WHALE_N005);
    glVertex3fv($WHALE_P005);
    glNormal3fv(WHALE_N053);
    glVertex3fv($WHALE_P053);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N053);
    glVertex3fv($WHALE_P053);
    glNormal3fv(WHALE_N005);
    glVertex3fv($WHALE_P005);
    glNormal3fv(WHALE_N060);
    glVertex3fv($WHALE_P060);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N053);
    glVertex3fv($WHALE_P053);
    glNormal3fv(WHALE_N060);
    glVertex3fv($WHALE_P060);
    glNormal3fv(WHALE_N052);
    glVertex3fv($WHALE_P052);
    glEnd();
}

sub Whale013()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N066);
    glVertex3fv($WHALE_P066);
    glNormal3fv(WHALE_N067);
    glVertex3fv($WHALE_P067);
    glNormal3fv(WHALE_N096);
    glVertex3fv($WHALE_P096);
    glNormal3fv(WHALE_N097);
    glVertex3fv($WHALE_P097);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N097);
    glVertex3fv($WHALE_P097);
    glNormal3fv(WHALE_N096);
    glVertex3fv($WHALE_P096);
    glNormal3fv(WHALE_N098);
    glVertex3fv($WHALE_P098);
    glNormal3fv(WHALE_N099);
    glVertex3fv($WHALE_P099);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N065);
    glVertex3fv($WHALE_P065);
    glNormal3fv(WHALE_N066);
    glVertex3fv($WHALE_P066);
    glNormal3fv(WHALE_N097);
    glVertex3fv($WHALE_P097);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N067);
    glVertex3fv($WHALE_P067);
    glNormal3fv(WHALE_N060);
    glVertex3fv($WHALE_P060);
    glNormal3fv(WHALE_N096);
    glVertex3fv($WHALE_P096);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N060);
    glVertex3fv($WHALE_P060);
    glNormal3fv(WHALE_N005);
    glVertex3fv($WHALE_P005);
    glNormal3fv(WHALE_N096);
    glVertex3fv($WHALE_P096);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N096);
    glVertex3fv($WHALE_P096);
    glNormal3fv(WHALE_N005);
    glVertex3fv($WHALE_P005);
    glNormal3fv(WHALE_N098);
    glVertex3fv($WHALE_P098);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N006);
    glVertex3fv($WHALE_P006);
    glNormal3fv(WHALE_N065);
    glVertex3fv($WHALE_P065);
    glNormal3fv(WHALE_N097);
    glVertex3fv($WHALE_P097);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N006);
    glVertex3fv($WHALE_P006);
    glNormal3fv(WHALE_N097);
    glVertex3fv($WHALE_P097);
    glNormal3fv(WHALE_N099);
    glVertex3fv($WHALE_P099);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($WHALE_P005);
    glVertex3fv($WHALE_P006);
    glVertex3fv($WHALE_P099);
    glVertex3fv($WHALE_P098);
    glEnd();
}

sub Whale014()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N062);
    glVertex3fv($WHALE_P062);
    glNormal3fv(WHALE_N004);
    glVertex3fv($WHALE_P004);
    glNormal3fv(WHALE_N005);
    glVertex3fv($WHALE_P005);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($WHALE_P006);
    glVertex3fv($WHALE_P005);
    glVertex3fv($WHALE_P004);
    glVertex3fv($WHALE_P008);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N063);
    glVertex3fv($WHALE_P063);
    glNormal3fv(WHALE_N006);
    glVertex3fv($WHALE_P006);
    glNormal3fv(WHALE_N002);
    glVertex3fv($WHALE_P002);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N002);
    glVertex3fv($WHALE_P002);
    glNormal3fv(WHALE_N006);
    glVertex3fv($WHALE_P006);
    glNormal3fv(WHALE_N008);
    glVertex3fv($WHALE_P008);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N002);
    glVertex3fv($WHALE_P002);
    glNormal3fv(WHALE_N008);
    glVertex3fv($WHALE_P008);
    glNormal3fv(WHALE_N004);
    glVertex3fv($WHALE_P004);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N062);
    glVertex3fv($WHALE_P062);
    glNormal3fv(WHALE_N002);
    glVertex3fv($WHALE_P002);
    glNormal3fv(WHALE_N004);
    glVertex3fv($WHALE_P004);
    glEnd();
}

sub Whale015()
{
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N055);
    glVertex3fv($WHALE_P055);
    glNormal3fv(WHALE_N003);
    glVertex3fv($WHALE_P003);
    glNormal3fv(WHALE_N054);
    glVertex3fv($WHALE_P054);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N003);
    glVertex3fv($WHALE_P003);
    glNormal3fv(WHALE_N055);
    glVertex3fv($WHALE_P055);
    glNormal3fv(WHALE_N063);
    glVertex3fv($WHALE_P063);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N003);
    glVertex3fv($WHALE_P003);
    glNormal3fv(WHALE_N063);
    glVertex3fv($WHALE_P063);
    glNormal3fv(WHALE_N100);
    glVertex3fv($WHALE_P100);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N003);
    glVertex3fv($WHALE_P003);
    glNormal3fv(WHALE_N100);
    glVertex3fv($WHALE_P100);
    glNormal3fv(WHALE_N054);
    glVertex3fv($WHALE_P054);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N054);
    glVertex3fv($WHALE_P054);
    glNormal3fv(WHALE_N100);
    glVertex3fv($WHALE_P100);
    glNormal3fv(WHALE_N062);
    glVertex3fv($WHALE_P062);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N100);
    glVertex3fv($WHALE_P100);
    glNormal3fv(WHALE_N063);
    glVertex3fv($WHALE_P063);
    glNormal3fv(WHALE_N002);
    glVertex3fv($WHALE_P002);
    glEnd();
    glBegin(GL_POLYGON);
    glNormal3fv(WHALE_N100);
    glVertex3fv($WHALE_P100);
    glNormal3fv(WHALE_N002);
    glVertex3fv($WHALE_P002);
    glNormal3fv(WHALE_N062);
    glVertex3fv($WHALE_P062);
    glEnd();
}

sub Whale016()
{
    glBegin(GL_POLYGON);
    glVertex3fv($WHALE_P104);
    glVertex3fv($WHALE_P105);
    glVertex3fv($WHALE_P106);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($WHALE_P107);
    glVertex3fv($WHALE_P108);
    glVertex3fv($WHALE_P109);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($WHALE_P110);
    glVertex3fv($WHALE_P111);
    glVertex3fv($WHALE_P112);
    glVertex3fv($WHALE_P113);
    glVertex3fv($WHALE_P114);
    glVertex3fv($WHALE_P115);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex3fv($WHALE_P116);
    glVertex3fv($WHALE_P117);
    glVertex3fv($WHALE_P118);
    glVertex3fv($WHALE_P119);
    glVertex3fv($WHALE_P120);
    glVertex3fv($WHALE_P121);
    glEnd();
}

sub DrawWhale($fish)
{
    my ($seg0, $seg1, $seg2, $seg3, $seg4, $seg5, $seg6, $seg7);
    my ($pitch, $thrash, $chomp);

    $fish.htail = int($fish.htail - int(5.0 * $fish.v)) % 360;

    $thrash = 70.0 * $fish.v;

    $seg0 = 1.5 * $thrash * sin(($fish.htail) * RRAD);
    $seg1 = 2.5 * $thrash * sin(($fish.htail + 10.0) * RRAD);
    $seg2 = 3.7 * $thrash * sin(($fish.htail + 15.0) * RRAD);
    $seg3 = 4.8 * $thrash * sin(($fish.htail + 23.0) * RRAD);
    $seg4 = 6.0 * $thrash * sin(($fish.htail + 28.0) * RRAD);
    $seg5 = 6.5 * $thrash * sin(($fish.htail + 35.0) * RRAD);
    $seg6 = 6.5 * $thrash * sin(($fish.htail + 40.0) * RRAD);
    $seg7 = 6.5 * $thrash * sin(($fish.htail + 55.0) * RRAD);

    $pitch = $fish.v * sin(($fish.htail - 160.0) * RRAD);

    $chomp = 0.0;
    if ($fish.v > 2.0) {
        $chomp = -($fish.v - 2.0) * 200.0;
    }
    $WHALE_P012[1] = WHALE_iP012[1] + $seg5;
    $WHALE_P013[1] = WHALE_iP013[1] + $seg5;
    $WHALE_P014[1] = WHALE_iP014[1] + $seg5;
    $WHALE_P015[1] = WHALE_iP015[1] + $seg5;
    $WHALE_P016[1] = WHALE_iP016[1] + $seg5;
    $WHALE_P017[1] = WHALE_iP017[1] + $seg5;
    $WHALE_P018[1] = WHALE_iP018[1] + $seg5;
    $WHALE_P019[1] = WHALE_iP019[1] + $seg5;

    $WHALE_P020[1] = WHALE_iP020[1] + $seg4;
    $WHALE_P021[1] = WHALE_iP021[1] + $seg4;
    $WHALE_P022[1] = WHALE_iP022[1] + $seg4;
    $WHALE_P023[1] = WHALE_iP023[1] + $seg4;
    $WHALE_P024[1] = WHALE_iP024[1] + $seg4;
    $WHALE_P025[1] = WHALE_iP025[1] + $seg4;
    $WHALE_P026[1] = WHALE_iP026[1] + $seg4;
    $WHALE_P027[1] = WHALE_iP027[1] + $seg4;

    $WHALE_P028[1] = WHALE_iP028[1] + $seg2;
    $WHALE_P029[1] = WHALE_iP029[1] + $seg2;
    $WHALE_P030[1] = WHALE_iP030[1] + $seg2;
    $WHALE_P031[1] = WHALE_iP031[1] + $seg2;
    $WHALE_P032[1] = WHALE_iP032[1] + $seg2;
    $WHALE_P033[1] = WHALE_iP033[1] + $seg2;
    $WHALE_P034[1] = WHALE_iP034[1] + $seg2;
    $WHALE_P035[1] = WHALE_iP035[1] + $seg2;

    $WHALE_P036[1] = WHALE_iP036[1] + $seg1;
    $WHALE_P037[1] = WHALE_iP037[1] + $seg1;
    $WHALE_P038[1] = WHALE_iP038[1] + $seg1;
    $WHALE_P039[1] = WHALE_iP039[1] + $seg1;
    $WHALE_P040[1] = WHALE_iP040[1] + $seg1;
    $WHALE_P041[1] = WHALE_iP041[1] + $seg1;
    $WHALE_P042[1] = WHALE_iP042[1] + $seg1;
    $WHALE_P043[1] = WHALE_iP043[1] + $seg1;

    $WHALE_P044[1] = WHALE_iP044[1] + $seg0;
    $WHALE_P045[1] = WHALE_iP045[1] + $seg0;
    $WHALE_P046[1] = WHALE_iP046[1] + $seg0;
    $WHALE_P047[1] = WHALE_iP047[1] + $seg0;
    $WHALE_P048[1] = WHALE_iP048[1] + $seg0;
    $WHALE_P049[1] = WHALE_iP049[1] + $seg0;
    $WHALE_P050[1] = WHALE_iP050[1] + $seg0;
    $WHALE_P051[1] = WHALE_iP051[1] + $seg0;

    $WHALE_P009[1] = WHALE_iP009[1] + $seg6;
    $WHALE_P010[1] = WHALE_iP010[1] + $seg6;
    $WHALE_P075[1] = WHALE_iP075[1] + $seg6;
    $WHALE_P076[1] = WHALE_iP076[1] + $seg6;

    $WHALE_P001[1] = WHALE_iP001[1] + $seg7;
    $WHALE_P011[1] = WHALE_iP011[1] + $seg7;
    $WHALE_P068[1] = WHALE_iP068[1] + $seg7;
    $WHALE_P069[1] = WHALE_iP069[1] + $seg7;
    $WHALE_P070[1] = WHALE_iP070[1] + $seg7;
    $WHALE_P071[1] = WHALE_iP071[1] + $seg7;
    $WHALE_P072[1] = WHALE_iP072[1] + $seg7;
    $WHALE_P073[1] = WHALE_iP073[1] + $seg7;
    $WHALE_P074[1] = WHALE_iP074[1] + $seg7;

    $WHALE_P091[1] = WHALE_iP091[1] + $seg3 * 1.1;
    $WHALE_P092[1] = WHALE_iP092[1] + $seg3;
    $WHALE_P093[1] = WHALE_iP093[1] + $seg3;
    $WHALE_P094[1] = WHALE_iP094[1] + $seg3;
    $WHALE_P095[1] = WHALE_iP095[1] + $seg3 * 0.9;

    $WHALE_P099[1] = WHALE_iP099[1] + $chomp;
    $WHALE_P098[1] = WHALE_iP098[1] + $chomp;
    $WHALE_P097[1] = WHALE_iP097[1] + $chomp;
    $WHALE_P096[1] = WHALE_iP096[1] + $chomp;

    glPushMatrix();

    glRotatef($pitch, 1.0, 0.0, 0.0);

    glTranslatef(0.0, 0.0, 8000.0);

    glRotatef(180.0, 0.0, 1.0, 0.0);

    glScalef(3.0, 3.0, 3.0);

    glEnable(GL_CULL_FACE);

    Whale001();
    Whale002();
    Whale003();
    Whale004();
    Whale005();
    Whale006();
    Whale007();
    Whale008();
    Whale009();
    Whale010();
    Whale011();
    Whale012();
    Whale013();
    Whale014();
    Whale015();
    Whale016();

    glDisable(GL_CULL_FACE);

    glPopMatrix();
}

/* Copyright (c) Mark J. Kilgard, 1994. */
our $sharks;
our $momWhale;
our $babyWhale;
our $dolph;

our $moving;

sub InitFishs()
{
    for (my $i = 0; $i < NUM_SHARKS; $i++) {
        $sharks[$i].x = 70000.0 + rand() % 6000;
        $sharks[$i].y
	    = rand() % 6000;
        $sharks[$i].z = rand() % 6000;
        $sharks[$i].psi = rand() % 360 - 180.0;
        $sharks[$i].v = 1.0;
    }

    $dolph.x = 30000.0;
    $dolph.y
	= 0.0;
    $dolph.z = 6000.0;
    $dolph.psi = 90.0;
    $dolph.theta = 0.0;
    $dolph.v = 3.0;

    $momWhale.x = 70000.0;
    $momWhale.y
	= 0.0;
    $momWhale.z = 0.0;
    $momWhale.psi = 90.0;
    $momWhale.theta = 0.0;
    $momWhale.v = 3.0;

    $babyWhale.x = 60000.0;
    $babyWhale.y
	= -2000.0;
    $babyWhale.z = -2000.0;
    $babyWhale.psi = 90.0;
    $babyWhale.theta = 0.0;
    $babyWhale.v = 3.0;
}

const ambient = (0.1, 0.1, 0.1, 1.0);
const diffuse = (1.0, 1.0, 1.0, 1.0);
const position = (0.0, 1.0, 0.0, 0.0);
const mat_shininess = (90.0,);
const mat_specular = (0.8, 0.8, 0.8, 1.0);
const mat_diffuse = (0.46, 0.66, 0.795, 1.0);
const mat_ambient = (0.0, 0.1, 0.2, 1.0);
const lmodel_ambient = (0.4, 0.4, 0.4, 1.0);
const lmodel_localviewer = (0.0,);

sub Init()
{
    glFrontFace(GL_CW);

    glDepthFunc(GL_LEQUAL);
    glEnable(GL_DEPTH_TEST);

    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    glLightfv(GL_LIGHT0, GL_POSITION, position);
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, lmodel_ambient);
    glLightModelfv(GL_LIGHT_MODEL_LOCAL_VIEWER, lmodel_localviewer);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, mat_shininess);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, mat_specular);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, mat_diffuse);
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, mat_ambient);

    InitFishs();

    glClearColor(0.0, 0.5, 0.9, 0.0);
}

sub Reshape($width, $height)
{
    glViewport(0, 0, $width, $height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(400.0, 2.0, 10000.0, 400000.0);
    glMatrixMode(GL_MODELVIEW);
}

sub Animate()
{
    for (my $i = 0; $i < NUM_SHARKS; $i++) {
        SharkPilot(\$sharks[$i]);
        SharkMiss($i);
    }
    WhalePilot(\$dolph);
    $dolph.phi++;
    glutPostRedisplay();
    WhalePilot(\$momWhale);
    $momWhale.phi++;
    WhalePilot(\$babyWhale);
    $babyWhale.phi++;
}

sub Key($key, $x, $y)
{
    switch ($key) {
    case 27:               # Esc will quit
        exit(1);
        break;
    case 32: #' ':         # space will advance frame
        if (!$moving) {
            Animate();
        }
    }
}

sub Display()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    for (my $i = 0; $i < NUM_SHARKS; $i++) {
        glPushMatrix();
        FishTransform(\$sharks[$i]);
        DrawShark(\$sharks[$i]);
        glPopMatrix();
    }

    glPushMatrix();
    FishTransform(\$dolph);
    DrawDolphin(\$dolph);
    glPopMatrix();

    glPushMatrix();
    FishTransform(\$momWhale);
    DrawWhale(\$momWhale);
    glPopMatrix();

    glPushMatrix();
    FishTransform(\$babyWhale);
    glScalef(0.45, 0.45, 0.3);
    DrawWhale(\$babyWhale);
    glPopMatrix();

    glutSwapBuffers();
}

sub Visible($state)
{
    if ($state == GLUT_VISIBLE) {
        if ($moving)
            glutIdleFunc(\Animate());
    } else {
        if ($moving)
            glutIdleFunc();
    }
}

sub menuSelect($value)
{
    switch ($value) {
    case 1:
        $moving = GL_TRUE;
        glutIdleFunc(\Animate());
        break;
    case 2:
        $moving = GL_FALSE;
        glutIdleFunc();
        break;
    case 3:
        exit(0);
        break;
    }
}

sub main()
{
    glutInitWindowSize(500, 250);
    glutInit();
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);
    glutCreateWindow("GLUT Atlantis Demo");
    Init();
    glutDisplayFunc(\Display());
    glutReshapeFunc(\Reshape());
    glutKeyboardFunc(\Key());
    $moving = GL_TRUE;
    glutIdleFunc(\Animate());
    glutVisibilityFunc(\Visible());
    glutCreateMenu(\menuSelect());
    glutAddMenuEntry("Start motion", 1);
    glutAddMenuEntry("Stop motion", 2);
    glutAddMenuEntry("Quit", 3);
    glutAttachMenu(GLUT_RIGHT_BUTTON);
    glutMainLoop();
}

main();
