function debug (cor, vetorPos)
%esboço/debug
hold on
    if ~isempty(vetorPos)
        text(10 , 10 , ...
                    strcat('X:', num2str(round(vetorPos(1))),...
                    'Y:', num2str(round(vetorPos(2))),...
                    'Z:', num2str(round(vetorPos(3)))),'Color', cor, 'FontSize',20,'FontWeight','bold');
    end
hold off
%keyboard
end