classdef TM5900 < RobotBaseClass
    %% UR10 
    % Universal Robot 10kg payload robot model
    % URL: https://www.universal-robots.com/articles/ur/application-installation/dh-parameters-for-calculations-of-kinematics-and-dynamics/
    %
    % WARNING: This model has been created by UTS students in the subject
    % 41013. No guarentee is made about the accuracy or correctness of the
    % of the DH parameters of the accompanying ply files. Do not assume
    % that this matches the real robot!

    properties(Access = public)   
        plyFileNameStem = 'TM5900';        
    end
    
    methods
%% Constructor
        function self = TM5900(baseTr,useTool,toolFilename)
            if nargin < 3
                if nargin == 2
                    error('If you set useTool you must pass in the toolFilename as well');
                elseif nargin == 0 % Nothing passed
                    baseTr = transl(0,0,0);                
                end             
            else % All passed in 
                self.useTool = useTool;
                toolTrData = load([toolFilename,'.mat']);
                self.toolTr = toolTrData.tool;
                self.toolFilename = [toolFilename,'.ply'];
            end

            self.CreateModel();
			self.model.base = self.model.base.T * baseTr;
            self.model.tool = self.toolTr;
            self.PlotAndColourRobot();
            drawnow

            % % Initial joint configuration (home position or any valid starting position)
            % q = zeros(1, length(self.model.links)); % Zero position for all joints
            % 
            % % Invoke the teach function for interactive control
            % self.model.teach(q);  % Use the teach panel to move the robot
        end

%% CreateModel
        function CreateModel(self)
            link(1) = Link('d',0.145,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset', 0);
            link(2) = Link('d',0,'a',-0.429,'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
            link(3) = Link('d',0,'a',-0.411,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d',0.106,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            link(5) = Link('d',0.106,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            link(6) = Link('d',0.113,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);

            
            link(1).qlim = [-55 90]*pi/180; % OG -45 90
            % % link(1).qlim = [-360 360]*pi/180;
            % % link(2).qlim = [-70 70]*pi/180;

            link(2).qlim = [0 45]*pi/180; % 0 45 OG
            link(3).qlim = [0 160]*pi/180; % OG 0 160
            
            
            % link(3).qlim = [57 145]*pi/180;
            % link(4).qlim = [-251 -149]*pi/180;
            % link(5).qlim = [260 300]*pi/180;
            % link(6).qlim = [260 300]*pi/180;  
                                                                                                                                                        
            link(2).offset = -pi/2;
            link(4).offset = pi/2;

            %Experiment
            % 
            % link(1).offset = pi/4; %EXPERIMENT
            % link(3).offset = -pi/4; %EXPERIMENT

            self.model = SerialLink(link,'name',self.name);
        end
    end
end