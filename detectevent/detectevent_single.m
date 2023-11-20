function idx_event=detectevent_single(var_to_detect,baseline,threshold,delta,plot_validation)

% A script to detect events in a single timeseries variable (mx1)
% Event is considered as timeperiods in which the [var_to_detect] rises from
% the [baseline] and return to [baseline]. If [threshold] is provided, then
% event is considered if the [var_to_detect] reaches the threshold. [delta]
% serves to reduce noise in the detection. If there are lots of
% ups-and-downs near the [baseline], then there will be lots of short events.
% However if the events are within [delta] timestep, it will be considered
% as one event.
%
% If [plot_validation] is True, then [var_to_detect] will be plotted along
% with the [event_start] and [event_end] to validate

% Input:
% [var_to_detect] --> (mx1) vector of floats
% [baseline] --> (1x1) float
% [threshold] --> (1x1) float
% [delta] --> (1x1) float
% [plot_validation] --> boolean

% Output:
% [idx_event] --> (mx2) Where m is the number of detected events. 
% First column is the event starts, second column is
% the event ends. Thus, each row represents a single event.

arguments
    var_to_detect
    baseline
    threshold
    delta=5; %Default to 5
    plot_validation=false;
end

event_start=[];
event_end=[];
traversed=[];
inSearchingState=false;
searchIdx=0;
searchIdx_arr=[];
for i=1:1:length(var_to_detect)
    if i==1
        continue
    else
        traversed=[traversed;var_to_detect(i)];

        if inSearchingState==true
            searchIdx=searchIdx+1;
        else
            searchIdx=0;
        end
        searchIdx_arr(i)=searchIdx;
        if searchIdx<=delta

            %%% Start event detection
            % i lies i+1 of the baseline
            if var_to_detect(i)>baseline && var_to_detect(i-1)<=baseline || (i==2 && var_to_detect(i)~=0)
                if inSearchingState==true
                    event_end=event_end(1:end-1);
                    inSearchingState=false;
                else
                    event_start=[event_start;i-1];
                end
            end


            %%% End event detection
            % i lies in the baseline
            if ((var_to_detect(i)<=baseline && var_to_detect(i-1)>baseline)) || (i==length(var_to_detect) && var_to_detect(i)~=0)
                event_end=[event_end;i];
                inSearchingState=true;
            end

        else
            if var_to_detect(i)>baseline && var_to_detect(i-1)<=baseline || (i==2 && var_to_detect(i)~=0)
                if inSearchingState==true
                    event_end=event_end(1:end-1);
                    inSearchingState=false;
                else
                    event_start=[event_start;i-1];
                end
            end
            inSearchingState=false;
        end
    end
end

if threshold~=0
    ii=length(event_start);
    idx=1;
    while(length(event_start)<=ii)
        vector=var_to_detect(event_start(idx):event_end(idx));
        if sum(vector>=threshold)>0
            continue
        else
            event_start(idx)=[];
            event_end(idx)=[];
        end
    end
end

idx_event=[event_start event_end];

if plot_validation==true
    figure
    hold on
    plot(var_to_detect)
    xline(idx_event(:,1))
    xline(idx_event(:,2),'Color','g')
end

end