classdef BasicClass < handle
   properties
      Value
   end
   methods
      function r = roundOff(obj)
         r = round([obj.Value],2);
      end
      function r = multiplyBy(obj,n)
         r = [obj.Value] * n;
      end
      
      function obj = maa(obj,n) 
          obj.Value = obj.Value*n;
      end
   end
end