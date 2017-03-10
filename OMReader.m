clear
clc
I=rgb2gray(imread('home/abhi/Desktop/scan0001.jpg'));  %path of the saved OMR sheet image
str='ABCDE';                                                                      %options marked in the sheet
str2='';
startx=363;starty=252;           %coordinates of the left most corner of the first choice box
                              %These coordinates can be found out by using ginput function in MATLAB
diffx=32;diffy=27;   %approximate size of the rectangular choice boxes 
                                         %This again can be found out using ginput
xdiff=42;                      %approximate distance between each row of choice boxes on the sheet
t=200;                          %threshold for selecting grey pixels
p=0.5;                           %percentage of pixels to be grey for selecting a choice box as choice
f=1;s=1;
adjustx=10;          %parameter needed for adjusting distance between choice boxes in the vertical direction
mark(:,:,1)=I;mark(:,:,2)=I;mark(:,:,3)=I;
for i=1:25                               %this loop runs for each of the 25 rows of boxes on the left side of the OMR sheet
    sx=startx+(i-1)*xdiff;   %estimating the x-coordinate determining the start of each row
    for j=1:5          %this loop runs for each of the 5 choice boxes in each row
        sy=starty+(j-1)*(diffy+4);         %estimating the starting y-coordinate for each choice box

                               %So, when i=3 and j=4, we are referring to the choice box D of problem 3 of Section-I                                            % and (sx,sy) represent the estimated starting coordinate pair for the corresponding box.
                               %We will now assume that our choice box has most of its pixels common with a 
                               % rectangular box of dimensions diffx and diffy and with starting coordinates (sx,sy).
                               %So, if we calculate the total number of gray pixels in this rectangular box, the sum will be                                  % nearly same as that for our choice box.
        n=0;
        for k=1:diffy                  %these two loops pick each pixel in our rectangular box, k corresponds to y-
            for l=1:diffx               %coordinate and l corresponds to x-coordinate of the pixel
                a(k,l)=I(sx+l,sy+k);
                if(a(k,l)<=t)
                    n=n+1;                %n increases when any pixel is found to be below a threshold intensity t
                end
            end
        end
        if(n>p*diffy*diffx)     %If total grey pixels in the rectangle are greater than a certain percentage,
            c(i,j)=0;                      % mark the corresponding choice
        else
            c(i,j)=1;
        end
            mark(sx,sy,1)=255;            mark(sx,sy,2)=0;            mark(sx,sy,3)=0;   %make (sx,sy) red
    end
    if(f==(6*s))
             startx=startx-adjustx;s=s+1;           %adjustment done after every 6 rows to reduce estimation error
    end
    f=f+1;
end
                              %Same thing is now carried out for the other 25 rows on the right side of the image
startx=360;
starty=737;
f=1;
s=1;
for i=1:25
    sx=startx+(i-1)*xdiff;
    for j=1:5
        n=0;
        sy=starty+(j-1)*(diffy+4);
        for k=1:diffy
            for l=1:diffx
                a(k,l)=I(sx+l,sy+k);
                if(a(k,l)<=t)
                    n=n+1;
                end
            end
        end
        if(n>p*diffy*diffx)
            c(i+25,j)=0;
        else
            c(i+25,j)=1;
        end
            mark(sx,sy,1)=255;            mark(sx,sy,2)=0;            mark(sx,sy,3)=0;
    end
    if(f==(6*s))
             startx=startx-adjustx;s=s+1;
    end
    f=f+1;
end
                           %Printing the results
for i=1:50                                             %this loop runs for all the rows
    m=0;
    for j=1:5                                            %this loop corresponds to each of the five choice boxes in a row
    if(c(i,j)==0)                                     %if the corresponding choice is marked, print it out
        str2=[str2 '' str(j)];
    else
        m=m+1;
    end
    end
    if(m==5)                                           %if no choice is marked, print NONE
        str2=[str2 '0'];
    end
end
subplot(1,2,1)
imshow(mark)
subplot(1,2,2)
imshow(c)
str2;
str3=['B','A','D','C','A','D','C','B','A','D','C','B','B','C','D','C','B','D','B','C','D','C','A','D','C','B','C','D','C','B','C','B','C','B','D','C','B','C','D','C','B','A','A','D','C','B','A','D','C','B'];
mark1=0;
ccount=0;
wcount=0;
uncount=0;
for i=1:50
    if str2(i)==str3(i)
        mark1=mark1+3;
        ccount=ccount+1;
    else if str2(i)=='0'
        mark1=mark1+0;
        uncount=uncount+1;
        else if str2(i)~=str3(i)
        mark1=mark1-1;
        wcount=wcount+1;
            end
        end
    end
end
Correct = ccount;
Wrong = wcount;
Unattempted = uncount;
Marks = mark1;
table(Correct, Wrong, Unattempted, Marks)

