classdef GainSearch < ExampleMission.DefaultConfiguration

    methods (Static)
        function parameters_cells = configureParameters()
            num_Kp_values = 5;
            Kp_values = 10.^linspace(-5,1,num_Kp_values);
            Kd_values = Kp_values;
            [Kp_mesh, Kd_mesh] = meshgrid(Kp_values, Kd_values);

            num_simulations = numel(Kp_mesh);
            parameters_cells = repmat(configureParameters@ExampleMission.DefaultConfiguration(), num_simulations, 1);
            for index = 1:num_simulations
                parameters_cells{index}.GncAlgorithms.QuaternionFeedbackControl.Kp = Kp_mesh(index);
                parameters_cells{index}.GncAlgorithms.QuaternionFeedbackControl.Kd = Kd_mesh(index);
            end

        end

        function BusesInfo = configureBuses(parameters_cells)

            num_simulations = numel(parameters_cells);
            BusesInfo = repmat(struct('buses_list',{},'BusTemplates',{}), 1, num_simulations);

            for index = 1:num_simulations
                BusesInfo(index) = configureBuses@ExampleMission.DefaultConfiguration(parameters_cells(index));                
            end

        end

        function simulation_inputs = configureSimulationInputs(parameters_cells, BusesInfo)

            num_simulations = numel(parameters_cells);
            simulation_inputs(num_simulations) = Simulink.SimulationInput;

            for index = 1:num_simulations
                simulation_inputs(index) = configureSimulationInputs@ExampleMission.DefaultConfiguration(parameters_cells(index), BusesInfo(index));
                simulation_inputs(index) = simulation_inputs(index).setVariable('Kp_log', log10(parameters_cells{index}.GncAlgorithms.QuaternionFeedbackControl.Kp));
                simulation_inputs(index) = simulation_inputs(index).setVariable('Kd_log', log10(parameters_cells{index}.GncAlgorithms.QuaternionFeedbackControl.Kd));
            end

        end
    end

    methods (Access = public)
        function fig = plotSettlingTime(obj)
            num_simulations = numel(obj.parameters_cells);
            settling_times = inf(num_simulations, 1);
            kp = nan(size(settling_times));
            kd = kp;
            for index = 1:num_simulations
                error_quaternion = obj.simulation_outputs(index).logsout{6}.Values.error_quaternion_RB;
                axang = quat2axang(error_quaternion.Data);
                settling_times_index = find(rad2deg(axang(:,end)) > 1, 1, "last");
                settling_times(index) = error_quaternion.Time(settling_times_index);

                kp(index) = obj.parameters_cells{index}.GncAlgorithms.QuaternionFeedbackControl.Kp;
                kd(index) = obj.parameters_cells{index}.GncAlgorithms.QuaternionFeedbackControl.Kd;
            end
            fig = figure;
            scatter(kp, kd, [], settling_times, 'filled');
            cb = colorbar;
            xlabel('Proportional Gain');
            ylabel('Derivative Gain');
            ylabel(cb, 'Settling Time in s');
            yscale('log');
            xscale('log');
            title('Settling Time During Gain Search');
        end
    end
end