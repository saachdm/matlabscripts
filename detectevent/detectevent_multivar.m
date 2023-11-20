% A script for detecting events based on multiple variables
% The principle is to find the intersect (if the relation is AND) or the
% union (if the relation is OR) between each variable events. This script
% relies on detectevent_single.m
%
%
% Written for a university project

% In this example, three variables of interest are considered, A,B, and C.
% The event definition for this example are:
% intersect(idx_event_C,union(idx_event_B,idx_event_A))
%
% The event detection for each variable relies on detectevent_single.m.
% Thus, consult the aforementioned script for the detailed explanation.
%
% Todo: Make this script as function and automate the detection and
% flattening of the events.


% Detecting and flattening event_A

event_A=detectevent_single(A,0,0,10,false);
[nRow,~]=size(event_A);
idx_event_A=[];
for i=1:1:nRow
    idx_event_A=[idx_event_A event_A(i,1):1:event_A(i,2)];
end

% Detecting and flattening event_B

event_B=detectevent_single(B,0,0,10,false);
[nRow,~]=size(event_B);
idx_event_B=[];
for i=1:1:nRow
    idx_event_B=[idx_event_B event_B(i,1):1:event_B(i,2)];
end

% Detecting and flattening event_C

event_C=detectevent_single(C,0,0,10,false);
[nRow,~]=size(event_C);
idx_event_C=[];
for i=1:1:nRow
    idx_event_C=[idx_event_C event_C(i,1):1:event_C(i,2)];
end


% Feel free to copy-paste and adjust the lines above if you need more
% variables (3,4,5, etc)

%If intersect, the relation is AND. If union, the relation is OR
idx_all=intersect(idx_event_C,union(idx_event_B,idx_event_A)); %idx_all will consist of indexes that as a result of the union/intersect between the variables of interest

diff_idx_both=[0 diff(idx_all)];

%Event start index is whenever the diff is not one
%Event end index is whenever the next diff is more than one
event_start=[];
event_end=[];
for i=1:1:length(diff_idx_both)-1
    if diff_idx_both(i)~=1
        event_start=[event_start;i];
    end
    if diff_idx_both(i+1)>1 || i+1==length(diff_idx_both)
        event_end=[event_end;i];
    end
end

% First column is the start, second column is the end.
idx_event=[idx_all(event_start)' idx_all(event_end)'];

