function [shape,scale] = gampara(mean, std)

shape = (mean.^2)./(std.^2);
scale = (std.^2)./mean;

end