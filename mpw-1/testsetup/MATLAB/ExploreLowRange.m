fprintf("Explore Low Temp Range......\n");
% Explore low-temp range
tstart_ind  = 1; % -40C
twin_len    = 12; % -40C + 120C = 80C
pcalib      = 1; % +/- 10C calibration
    % Explore the best designs out of 64
params_arr = zeros(2, Nchip, 64);
inacc_arr  = zeros(Ntemp, Nchip, 64);
params_sec_arr = zeros(order_sec + 1, 64);
inacc_arr_sec = zeros(Ntemp, Nchip, 64);
Nc_A_arr = zeros(1, 64);
indlist_A_arr = zeros(2, Nchip, 64);
inacc_B_arr = zeros(1, 64);
indlist_B_arr = zeros(2, Nc_B, 64);
for design = 1:64
    freq_arr = freq_data_array(:, :, design);
    [params, inacc, params_sec, inacc_sec, Nc_A, indlist_A, inacc_B, indlist_B] = ...
        EvalDesignGivenRange(freq_arr, tlist, tstart_ind, twin_len, pcalib, inacc_th, Nc_B, order_sec);
    params_arr(:, :, design) = params;
    inacc_arr(:, :, design) = inacc;
    params_sec_arr(:, design) = params_sec;
    inacc_arr_sec(:, :, design) = inacc_sec;
    Nc_A_arr(:, design) = Nc_A;
    indlist_A_arr(:, :, design) = indlist_A;
    inacc_B_arr(:, design) = inacc_B;
    indlist_B_arr(:, :, design) = indlist_B;
end

% Best design with header-A
[design, inacc_sub_arr, inacc_sub_arr_sec, pos_inacc, neg_inacc, ~, sigma_sec, pos_sigma_inacc, neg_sigma_inacc] = ...
    EvalDesignInacc(1:32, inacc_arr, inacc_arr_sec, inacc_B_arr, indlist_B_arr, tstart_ind, twin_len);
fprintf("Header-A Design %d has lowest maximum absolute error. \n", design);
fprintf("Max/Min error w/o SEC is %f/+%f degreeC. \n", neg_inacc(1), pos_inacc(1));
fprintf("3-sigma error w/o SEC is %f/+%f degreeC. \n", neg_sigma_inacc(1), pos_sigma_inacc(1));
fprintf("Max/Min error w/ SEC is %f/+%f degreeC. \n", neg_inacc(2), pos_inacc(2));
fprintf("3-sigma error w/ SEC is %f/+%f degreeC. \n", neg_sigma_inacc(2), pos_sigma_inacc(2));
    % Plot Inaccuracy and 3-sigma against temp
[fig, hdl] = PlotInacc(fig, tlist(tstart_ind:(tstart_ind + twin_len)), inacc_sub_arr, inacc_sub_arr_sec, sigma_sec, design);
saveas(hdl, './Figures/InaccVStemp_hdrA_lr.emf');
fprintf("\n");

% Best design with header-B
[design, inacc_sub_arr, inacc_sub_arr_sec, pos_inacc, neg_inacc, sigma, sigma_sec, pos_sigma_inacc, neg_sigma_inacc] = ...
    EvalDesignInacc(33:64, inacc_arr, inacc_arr_sec, inacc_B_arr, indlist_B_arr, tstart_ind, twin_len);
fprintf("Header-B Design %d has lowest maximum absolute error. \n", design);
fprintf("Max/Min error w/o SEC is %f/+%f degreeC. \n", neg_inacc(1), pos_inacc(1));
fprintf("3-sigma error w/o SEC is %f/+%f degreeC. \n", neg_sigma_inacc(1), pos_sigma_inacc(1));
fprintf("Max/Min error w/ SEC is %f/+%f degreeC. \n", neg_inacc(2), pos_inacc(2));
fprintf("3-sigma error w/ SEC is %f/+%f degreeC. \n", neg_sigma_inacc(2), pos_sigma_inacc(2));
    % Plot Inaccuracy and 3-sigma against temp
[fig, hdl] = PlotInacc(fig, tlist(tstart_ind:(tstart_ind + twin_len)), inacc_sub_arr, inacc_sub_arr_sec, sigma_sec, design);
saveas(hdl, './Figures/InaccVStemp_hdrB_lr.emf');
fprintf("\n");