function McCabe_Thiele_non_ideal_NTS
%This program plots the McCabe Thiele Diagram for a binary system
clc
clear
close

%Givens
xD=0.99;
xW=0.01;
xF=0.55;
alpha=1.5;
q=0.5;
effic=0.6;
n=1.25; % R/Rmin
options=optimset('display','off');

% 45 line
plot([0 1],[0 1],'-k','linewidth',0.2)
hold on
grid on
set(gca,'Xlim',[0 1])
set(gca,'Ylim',[0 1])
xlabel('x'),ylabel('y')

% Equilibrium curve
y_eq_1=@(x) alpha.*x./(1-(1-alpha).*x);
y_eq_2=@(x) (x>=0&x<0.05).*(2817.*x.^3-489.5.*x.^2+29.91.*x)+...
    (x>=0.05&x<=0.2).*(-0.006252.*x.^-1.21+0.858)+...
    (x>0.2&x<=1).*(0.7244*x.^3-1.003.*x.^2+0.5348.*x+0.7438);

y_eq=y_eq_2;

fplot(y_eq,[0 1],'-k','linewidth',0.2)

% q-line
q_slope=q/(q-1);
q_intercept=-xF/(q-1);
q_eq=@(x) q_slope*x+q_intercept;

if q>1
    fplot(q_eq,[xF 1],'k')
elseif q==1
    plot([xF xF],[xF 1],'k')
elseif q<1&&q>0
    fplot(q_eq,[0 xF],'k')
elseif q==0
    plot([xF 0],[xF xF],'k')
else
    fplot(q_eq,[0 xF],'k')
end

% Rmin assuming ideal/near ideal equilibrium relation
if q==1
    x_pinch=xF;
else
    x_pinch=fsolve(@(x) q_eq(x)-y_eq(x),xF,options);
end
y_pinch=y_eq(x_pinch);

Rminslope=(xD-y_pinch)/(xD-x_pinch);
Rminintercept=xD-Rminslope*xD;
Rmin_old=xD/Rminintercept-1;
R=Rmin_old;

% Intersection between top section line and ideal/near ideal equilibrium curve

topsection=@(x) R/(1+R)*x+xD/(1+R);
if q==1
    x_intersect=xF;
else
    x_intersect=fsolve(@(x) topsection(x)-q_eq(x),xF,options);
end
y_intersect=topsection(x_intersect);

% Rmin check
x_test=x_pinch:0.01:xD;
k=1;

for R=20:-0.01:0
    topsection=@(x) R/(1+R)*x+xD/(1+R);
    E=y_eq(x_test);
    T=topsection(x_test);
    F=find(T>=E);
    m(k)=length(F);
    Reflux(k)=R;
    k=k+1;
end
pinchandmore=(find(m>0));
Rminloc=min(pinchandmore);
Rmin_new=Reflux(Rminloc);

Rmin=max([Rmin_new,Rmin_old]);
R=n.*Rmin;

% Actual intersection between q-line and top section line

topsection=@(x) R./(1+R).*x+xD./(1+R);
if q==1
    x_intersect=xF;
else
    x_intersect=fsolve(@(x) topsection(x)-q_eq(x),xF,options);
end
y_intersect=topsection(x_intersect);

plot([xD x_intersect],[xD y_intersect],'-k')
plot([xW x_intersect],[xW y_intersect],'k')

% Top section
x_eq=@(y) y/(alpha+(1-alpha)*y);

x_top_1=xD;
y_top_1=xD;
i=0;

while x_top_1>x_intersect
    
    y_top_2=y_top_1;
    x_top_2=fsolve(@(x) (y_eq(x)-y_top_1),x_top_1,options);
    x_top_3=x_top_2;
    y_top_3=topsection(x_top_3);

    plot([x_top_1 x_top_2],[y_top_1 y_top_2],'r')
    plot([x_top_2 x_top_3],[y_top_2 y_top_3],'r')
    
    x_top_plot=x_top_1;
  
    x_top_1=x_top_3;
    y_top_1=y_top_3;
    i=i+1;
    
end

NTS_top=i-1+(x_intersect-x_top_plot)/(x_top_3-x_top_plot);

%Bottom section

bottomslope=(xW-y_intersect)/(xW-x_intersect);
bottomintercept=xW-bottomslope*xW;

x_bottom=@(y) (y-bottomintercept)/bottomslope;

x_bottom_1=xW;
y_bottom_1=xW;
j=0;
while y_bottom_1<y_intersect
    x_bottom_2=x_bottom_1;
    y_bottom_2=y_eq(x_bottom_2);
    y_bottom_3=y_bottom_2;
    x_bottom_3=x_bottom(y_bottom_3);

    plot([x_bottom_1 x_bottom_2],[y_bottom_1 y_bottom_2],'b')
    plot([x_bottom_2 x_bottom_3],[y_bottom_2 y_bottom_3],'b')
    
    y_bottom_plot=y_bottom_1;
    x_bottom_1=x_bottom_3;
    y_bottom_1=y_bottom_3;
    j=j+1;
end
NTS_bottom=j-1+(y_intersect-y_bottom_plot)/(y_bottom_2-y_bottom_plot);

NAS_top=ceil(NTS_top/effic);
NAS_bottom=ceil(NTS_bottom/effic);

fprintf('\nNumber of theoretical stages in top section are %4.2f,\nNumber of actual stages in top section are %2.0f\n',NTS_top,NAS_top)
fprintf('\nNumber of theoretical stages in bottom section are %4.2f,\nNumber of actual stages in bottom section are %2.0f\n',NTS_bottom,NAS_bottom)
end
