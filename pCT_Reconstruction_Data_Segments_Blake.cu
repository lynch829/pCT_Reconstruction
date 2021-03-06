// //#ifndef PCT_RECONSTRUCTION_CU
//#define PCT_RECONSTRUCTION_CU
//#pragma once
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************** Proton CT Preprocessing and Image Reconstruction Code ******************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
#include "pCT_Reconstruction_Data_Segments_Blake.h"

//#define PROFILER 11
// Includes, CUDA project
//#include <cutil_inline.h>

// Includes, kernels
//#include "pCT_Reconstruction_GPU.cu"
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************************** Host functions declarations ********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
bool file_exists (const char* );
bool file_exists2 (const char* file_location) { return static_cast<bool>( std::ifstream(file_location) ); };
bool file_exists3 (const char* file_location) { return std::ifstream(file_location).good(); };
bool directory_exists(char* );
bool mkdir(char*);
unsigned int create_unique_dir( char* );
void assign_directories();
void apply_permissions();
void execution_times_2_txt();
void execution_times_2_csv();
void init_execution_times_csv();

// Execution Control Functions
void timer( bool, clock_t&, clock_t&, double&, const char*);
double timer( bool, clock_t&, const char*);
void exit_program_if( bool);
void pause_execution();
void exit_program_if( bool, const char* );

// Memory transfers and allocations/deallocations
void initial_processing_memory_clean();
void resize_vectors( unsigned int );
void shrink_vectors( unsigned int );
void data_shift_vectors( unsigned int, unsigned int );
void post_cut_memory_clean(); 

// Image Initialization/Construction Functions
template<typename T> void initialize_host_image( T*& );
template<typename T> void add_ellipse( T*&, int, double, double, double, double, T );
template<typename T> void add_circle( T*&, int, double, double, double, T );
template<typename O> void import_image( O*&, char* );

// Preprocessing setup and initializations 
void write_run_settings();
void assign_SSD_positions();
void initializations();
void count_histories();	
void count_histories_old();
void count_histories_v0();
void count_histories_v02();
void count_histories_v1();
void reserve_vector_capacity(); 

// Preprocessing functions
void read_energy_responses( const int, const int, const int );
void combine_data_sets();
void read_data_chunk( const int, const int, const int );
void read_data_chunk_old( const int, const int, const int );
void read_data_chunk_v0( const int, const int, const int );
void read_data_chunk_v02( const int, const int, const int );
void read_data_chunk_v1( const int, const int, const int );
void apply_tuv_shifts( unsigned int );
void convert_mm_2_cm( unsigned int );
void recon_volume_intersections( const int );
void binning( const int );
void calculate_means();
void initialize_stddev();
void sum_squared_deviations( const int, const int );
void calculate_standard_deviations();
void statistical_cuts( const int, const int );
void initialize_sinogram();
void construct_sinogram();
void FBP();
void FBP_image_2_hull();
void filter();
void backprojection();

// Hull-Detection 
void hull_initializations();
template<typename T> void initialize_hull( T*&, T*& );
void hull_detection( const int );
void hull_detection_finish();
void SC( const int );
void MSC( const int );
void MSC_edge_detection();
void SM( const int );
void SM_edge_detection();
void SM_edge_detection_2();
void hull_conversion_int_2_bool( int* );
void hull_selection();
template<typename T, typename T2> void averaging_filter( T*&, T2*&, int, bool, double );
template<typename T> void median_filter_2D( T*&, unsigned int );
template<typename T> void median_filter_2D( T*&, T*&, unsigned int );

// MLP: IN DEVELOPMENT
void create_MLP_test_image();	
void MLP();
template<typename O> bool find_MLP_endpoints( O*&, double, double, double, double, double, double&, double&, double&, int&, int&, int&, bool);
void collect_MLP_endpoints();
unsigned int find_MLP( unsigned int*&, float*&, double, double, double, double, double, double, double, double, double, double, int, int, int );
void generate_error_for_MLP(double *&,unsigned int,double,double);
double mean_chord_length( double, double, double, double, double, double );
double mean_chord_length2( double, double, double, double, double, double, double, double );
double EffectiveChordLength(double, double);

// Image Reconstruction
void initial_iterate_generate_hybrid();
void define_initial_iterate();
void create_hull_image_hybrid();
void image_reconstruction();
template< typename T, typename L, typename R> T discrete_dot_product( L*&, R*&, unsigned int*&, unsigned int );
template< typename T, typename RHS> T scalar_dot_product( double, RHS*&, unsigned int*&, unsigned int );
double update_vector_multiplier( double, double, float*&, unsigned int*&, unsigned int );
void update_iterate( double, double, float*&, unsigned int*&, unsigned int );
void DROP_blocks_error_red_sp(unsigned int*&, float*&, double, unsigned int, double, float*&, unsigned int*& );
void DROP_blocks_error(unsigned int*&, float*&, float*&, double, unsigned int, double, float*&, unsigned int*& );
void DROP_blocks_error_red( unsigned int*& , float*& ,float*& , double , unsigned int , double , float*& , unsigned int*& );
//void DROP_update_error(float*&, double*&, unsigned int*& , double*&);
void DROP_blocks_red( unsigned int*&, float*&, double, unsigned int, double, float*&, unsigned int*& );
void DROP_blocks( unsigned int*&, float*&, double, unsigned int, double, float*&, unsigned int*& );
void DROP_update( float*&, float*&, unsigned int*& );
void DROP_blocks2( unsigned int*&, float*&, double, unsigned int, double, float*&, unsigned int*&, unsigned int&, unsigned int*& );
void DROP_update2( float*&, float*&, unsigned int*&, unsigned int&, unsigned int*& );
void DROP_blocks3( unsigned int*&, float*&, double, unsigned int, double, float*&, unsigned int*&, unsigned int& );
void DROP_update3( float*&, float*&, unsigned int*&, unsigned int&);
void DROP_blocks_robust2( unsigned int*&, float*&, double, unsigned int, double, float*&, unsigned int*&, double*& );
void DROP_update_robust2( float*&, float*&, unsigned int*&, double*& );

// Write arrays/vectors to file(s)
void binary_2_ASCII();
template<typename T> void array_2_disk( const char*, const char*, const char*, T*, const int, const int, const int, const int, const bool );
template<typename T> void vector_2_disk( const char*, const char*, const char*, std::vector<T>, const int, const int, const int, const bool );
template<typename T> void t_bins_2_disk( FILE*, const std::vector<int>&, const std::vector<T>&, const BIN_ANALYSIS_TYPE, const int );
template<typename T> void bins_2_disk( const char*, const std::vector<int>&, const std::vector<T>&, const BIN_ANALYSIS_TYPE, const BIN_ANALYSIS_FOR, const BIN_ORGANIZATION, ... );
template<typename T> void t_bins_2_disk( FILE*, int*&, T*&, const unsigned int, const BIN_ANALYSIS_TYPE, const BIN_ORGANIZATION, int );
template<typename T> void bins_2_disk( const char*, int*&, T*&, const int, const BIN_ANALYSIS_TYPE, const BIN_ANALYSIS_FOR, const BIN_ORGANIZATION, ... );
FILE* create_MLP_file( char* );
template<typename T> void MLP_data_2_disk(const char*, FILE*, unsigned int, unsigned int*, T*&, bool );
void write_MLP_endpoints();
unsigned int read_MLP_endpoints();
void write_MLP( FILE*, unsigned int*&, unsigned int);
unsigned int read_MLP(FILE*, unsigned int*&);
void read_MLP_error(FILE*, float*&, unsigned int);
void export_hull();
void import_hull();

// Image position/voxel calculation functions
int calculate_voxel( double, double, double );
int position_2_voxel( double, double, double );
int positions_2_voxels(const double, const double, const double, int&, int&, int& );
void voxel_2_3D_voxels( int, int&, int&, int& );
double voxel_2_position( int, double, int, int );
void voxel_2_positions( int, double&, double&, double& );
double voxel_2_radius_squared( int );

// Voxel walk algorithm functions
double distance_remaining( double, double, int, int, double, int );
double edge_coordinate( double, int, double, int, int );
double path_projection( double, double, double, int, double, int, int );
double corresponding_coordinate( double, double, double, double );
void take_2D_step( const int, const int, const int, const double, const double, const double, const double, const double, const double, const double, const double, const double, double&, double&, double&, int&, int&, int&, int&, double&, double&, double& );
void take_3D_step( const int, const int, const int, const double, const double, const double, const double, const double, const double, const double, const double, const double, double&, double&, double&, int&, int&, int&, int&, double&, double&, double& );

// Host helper functions		
double randn(double, double);
template< typename T, typename T2> T max_n( int, T2, ...);
template< typename T, typename T2> T min_n( int, T2, ...);
template<typename T> T* sequential_numbers( int, int );
void bin_2_indexes( int, int&, int&, int& );
inline const char * bool_2_string( bool b ){ return b ? "true" : "false"; }
std::string terminal_response(char*);
char((&terminal_response( char*, char(&)[256]))[256]);
char((&current_MMDD( char(&)[5]))[5]);
char((&current_MMDDYYYY( char(&)[9]))[9]);
char((&current_YY_MM_DD( char(&)[9]))[9]);

//Console Window Print Statement Functions
void print_colored_text(const char*, unsigned int, unsigned int );
void print_section_separator(const char, unsigned int, unsigned int );
void construct_header_line( const char*, const char, char* );
void print_section_header( const char*, const char, unsigned int, unsigned int );
void print_section_exit( const char*, const char*, unsigned int, unsigned int );

// New routine test functions
void command_line_settings( unsigned int, char** );
void read_configurations();
void write_reconstruction_settings();
void generate_history_sequence(ULL, ULL, ULL* );
void verify_history_sequence(ULL, ULL, ULL* );
void test_func();
void test_func2( std::vector<int>&, std::vector<double>&);

/***********************************************************************************************************************************************************************************************************************/
/****************************************************************************************** Device (GPU) function declarations *****************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/

// Preprocessing routines
__device__ bool calculate_intercepts( double, double, double, double&, double& );
__global__ void recon_volume_intersections_GPU( int, int*, bool*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float* );
__global__ void binning_GPU( int, int*, int*, bool*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float* );
__global__ void calculate_means_GPU( int*, float*, float*, float* );
__global__ void sum_squared_deviations_GPU( int, int*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*  );
__global__ void calculate_standard_deviations_GPU( int*, float*, float*, float* );
__global__ void statistical_cuts_GPU( int, int*, int*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, bool* );
__global__ void construct_sinogram_GPU( int*, float* );
__global__ void filter_GPU( float*, float* );
__global__ void backprojection_GPU( float*, float* );
__global__ void FBP_image_2_hull_GPU( float*, bool* );

// Hull-Detection 
template<typename T> __global__ void initialize_hull_GPU( T* );
__global__ void SC_GPU( const int, bool*, int*, bool*, float*, float*, float*, float*, float*, float*, float* );
__global__ void MSC_GPU( const int, int*, int*, bool*, float*, float*, float*, float*, float*, float*, float* );
__global__ void SM_GPU( const int, int*, int*, bool*, float*, float*, float*, float*, float*, float*, float* );
__global__ void MSC_edge_detection_GPU( int* );
__global__ void MSC_edge_detection_GPU( int*, int* );
__global__ void SM_edge_detection_GPU( int*, int* );
__global__ void SM_edge_detection_GPU_2( int*, int* );
__global__ void carve_differences( int*, int* );
//template<typename H, typename D> __global__ void averaging_filter_GPU( H*, D*, int, bool, double );
template<typename D> __global__ void median_filter_GPU( D*, D*, int, bool, double );
template<typename D> __global__ void averaging_filter_GPU( D*, D*, int, bool, double );
template<typename D> __global__ void apply_averaging_filter_GPU( D*, D* );

//*********************************************************************MLP & Reconstruction GPU: IN DEVELOPMENT*********************************************************************************************
// MLP & Reconstruction GPU: IN DEVELOPMENT    
void generate_trig_tables();
void import_trig_tables();
void generate_scattering_coefficient_table();
void import_scattering_coefficient_table();
void generate_polynomial_tables();
void import_polynomial_tables();
void MLP_lookup_table_2_GPU();
void free_MLP_lookup_tables();

void image_reconstruction_GPU_tabulated();//*
template<typename O> __device__ bool find_MLP_endpoints_GPU( O*, double, double, double, double, double, double&, double&, double&, int&, int&, int&, bool);                                            			//*
//__device__ bool find_MLP_endpoints_GPU( bool*, double, double, double, double, double, double&, double&, double&, int&, int&, int&, bool); 
__device__ int find_MLP_GPU(float*, double, unsigned int, double, double, double, double, double, double, double, double, double, double, double, double, unsigned int*, double, double&, double& );                        		//*
//__device__ void find_MLP_GPU(float*, double, unsigned int, double, double, double, double, double, double, double, double, double, double, double, float, unsigned int*, int&, double&, double&, double& );                        		//*
__device__ int find_MLP_GPU_tabulated(float*, double, unsigned int, double, double, double, double, double, double, double, double, double, double, double, float, unsigned int*, double, double&, double&, double*, double*, double*, double*, double*, double*, double*, double* );
//__device__ void find_MLP_GPU_tabulated(float*, double, unsigned int, double, double, double, double, double, double, double, double, double, double, float, unsigned int*, float&, int&, double*, double*, double*, double*, double*, double*, double*, double*);
__device__ int find_MLP_GPU_tabulated_exact(float*, double, unsigned int, double, double, double, double, double, double, double, double, double, double, double, float, unsigned int*, float*, double, double&, double&, double*, double*, double*, double*, double*, double*, double*, double* );
__device__ int find_MLP_GPU_tabulated_exact2(float*, double, unsigned int, double, double, double, double, double, double, double, double, double, double, double, float, float*, double, double&, double&, double*, double*, double*, double*, double*, double*, double*, double* );
__global__ void collect_MLP_endpoints_GPU(bool*, unsigned int*, bool*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float* , int, int );                               	//*
__global__ void collect_MLP_endpoints_GPU_nobool(unsigned int*, bool*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float* , int, int );                               	//*
//__global__ void block_update_GPU(float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, unsigned int*, float*, unsigned int*, int, int, float);                                          	//*
//__global__ void block_update_GPU_tabulated(float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, unsigned int*, float*, unsigned int*, int, int, float, double*, double*, double*, double*, double*, double*, double*, double*);
__global__ void block_update_GPU(float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, unsigned int*, float*, unsigned int*, int, int, double);                                          	//*
__global__ void block_update_GPU_tabulated(float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, unsigned int*, float*, unsigned int*, int, int, double, double*, double*, double*, double*, double*, double*, double*, double*);
__global__ void block_update_GPU_tabulated_exact(float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, unsigned int*, float*, unsigned int*, int, int, double, double*, double*, double*, double*, double*, double*, double*, double*);
__global__ void block_update_GPU_tabulated_exact2(float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, unsigned int*, float*, int, int, double, double*, double*, double*, double*, double*, double*, double*, double*);
__global__ void x_update_GPU(float*, double*, unsigned int*); 
__global__ void DROP_init_arrays_GPU(float*, unsigned int*); 

float calculate_total_variation( float* );
__device__ float calculate_total_variation_GPU( float* );
void allocate_perturbation_arrays( bool);
void generate_perturbation_vector();
__global__ void generate_perturbation_vector_GPU( float*, float*, float*, float*, float*, float* );
__device__ void generate_perturbation_vector_GPU( float*, float*, float*, float*, float*, float*, int, int, int );
__global__ void apply_perturbation_GPU(float*, float*, float, float* );
void perturb_x( float& );
void perturb_x_GPU(float&);
void TVS_DROP_full_tx_tabulated(const int);
void TVS_DROP_full_tx_tabulated_GPU(const int);
void DROP_TVS_full_tx_tabulated(const int);
void DROP_TVS_full_tx_tabulated_GPU(const int);

void reconstruction_cuts_allocations(const int);
void reconstruction_cuts_host_2_device(const int, const int);
void reconstruction_cuts_device_2_host(const int, const int);
void reconstruction_cuts_deallocations();
void reconstruction_cuts_full_tx( const int );
void reconstruction_cuts_partial_tx(const int, const int);
void reconstruction_cuts_partial_tx_preallocated(const int, const int);

void reconstruction_cuts_allocations_nobool(const int);
void reconstruction_cuts_host_2_device_nobool(const int, const int);
void reconstruction_cuts_device_2_host_nobool(const int, const int);
void reconstruction_cuts_deallocations_nobool();
void reconstruction_cuts_full_tx_nobool( const int );
void reconstruction_cuts_partial_tx_nobool(const int, const int);
void reconstruction_cuts_partial_tx_preallocated_nobool(const int, const int);

void allocate_x();
void deallocate_x();
void x_host_2_GPU();
void x_GPU_2_host();
void DROP_allocate_arrays();
void DROP_deallocate_arrays();
void DROP_allocations(const int);
void DROP_host_2_device(const int,const int);
void DROP_deallocations();
void DROP_full_tx(const int);								// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = STANDARD
void DROP_partial_tx( const int );							// DROP_TX_MODE = PARTIAL_TX, MLP_ALGORITHM = STANDARD
void DROP_partial_tx_preallocated( const int );				// DROP_TX_MODE = PARTIAL_TX_PREALLOCATED, MLP_ALGORITHM = STANDARD
void DROP_full_tx_tabulated(const int);						// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = TABULATED
void DROP_partial_tx_tabulated( const int );				// DROP_TX_MODE = PARTIAL_TX, MLP_ALGORITHM = TABULATED
void DROP_partial_tx_preallocated_tabulated( const int );	// DROP_TX_MODE = PARTIAL_TX_PREALLOCATED, MLP_ALGORITHM = TABULATED
void DROP_TVS_full_tx_tabulated(const int);

float calculate_total_variation( float* );
void allocate_perturbation_arrays( bool);
void generate_perturbation_vector();
void perturb_x( float& );

int BlobIndex(int, int, int);
__device__ int BlobIndex_GPU(int, int, int);
__global__ void block_update_GPU_tabulated_blob(float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, float*, unsigned int*, float*, unsigned int*, int, int, double, double*, double*, double*, double*, double*, double*, double*, double*);
__device__ int find_blob_MLP_GPU_tabulated(float*, double, unsigned int, double, double, double, double, double, double, double, double, double, double, double, float, unsigned int*, double, double&, double&, double*, double*, double*, double*, double*, double*, double*, double* );

void image_reconstruction_GPU();  
__device__ double EffectiveChordLength_GPU(double, double);                                                                                                                                              			//*

// Image Reconstruction
__global__ void create_hull_image_hybrid_GPU( bool*&, float*& );
//template< typename X> __device__ double update_vector_multiplier2( double, double, X*&, int*, int );
__device__ double scalar_dot_product_GPU_2( double, float*&, int*, int );
__device__ double update_vector_multiplier_GPU_22( double, double, float*&, int*, int );
//template< typename X> __device__ void update_iterate2( double, double, X*&, int*, int );
__device__ void update_iterate_GPU_22( double, double, float*&, int*, int );
void update_x();

// Image position/voxel calculation functions
__device__ int calculate_voxel_GPU( double, double, double );
__device__ int positions_2_voxels_GPU(const double, const double, const double, int&, int&, int& );
__device__ int position_2_voxel_GPU( double, double, double );
__device__ void voxel_2_3D_voxels_GPU( int, int&, int&, int& );
__device__ double voxel_2_position_GPU( int, double, int, int );
__device__ void voxel_2_positions_GPU( int, double&, double&, double& );
__device__ double voxel_2_radius_squared_GPU( int );

// Voxel walk algorithm functions
__device__ double distance_remaining_GPU( double, double, int, int, double, int );
__device__ double edge_coordinate_GPU( double, int, double, int, int );
__device__ double path_projection_GPU( double, double, double, int, double, int, int );
__device__ double corresponding_coordinate_GPU( double, double, double, double );
__device__ void take_2D_step_GPU( const int, const int, const int, const double, const double, const double, const double, const double, const double, const double, const double, const double, double&, double&, double&, int&, int&, int&, int&, double&, double&, double& );
__device__ void take_3D_step_GPU( const int, const int, const int, const double, const double, const double, const double, const double, const double, const double, const double, const double, double&, double&, double&, int&, int&, int&, int&, double&, double&, double& );

// Device helper functions
cudaError_t CUDA_error_check( char* );
cudaError_t CUDA_error_check_and_sync_device( char*, char* );

// New routine test functions
__global__ void test_func_GPU( int* );
__global__ void test_func_device( double*, double*, double* );

/***********************************************************************************************************************************************************************************************************************/
/***************************************************************************************************** Program Main ****************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
int main(int argc, char** argv)
{
	//char statement[256];
	if( RUN_ON )
	{
		current_MMDDYYYY( EXECUTION_DATE);
		//command_line_settings( argc, argv );
		print_colored_text(print_statement, LIGHT, CYAN );
		assign_directories();
		/********************************************************************************************************************************************************/
		/* Perform program setup routines and start the execution timing clock																														*/
		/********************************************************************************************************************************************************/
		sprintf( print_statement, "Determine the # of protons for each gantry angle and in total and initialize host/GPU arrays to accomdate this data");
		print_section_header( print_statement, '*', LIGHT, BLUE );
		timer( START, begin_program, "for entire program");
		timer( START, begin_preprocessing, "for preprocessing");
		hull_initializations();			// Initialize hull detection images and transfer them to the GPU (performed if SC_ON, MSC_ON, or SM_ON is true)		
		initializations();				// allocate and initialize host and GPU memory for statistical
		count_histories();				// count the number of histories per file, per scan, total, etc.
		reserve_vector_capacity();		// Reserve enough memory so vectors don't grow into another reserved memory space, wasting time since they must be moved
		
		sprintf( print_statement, "Proton counting and initializations complete");
		print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );
		/********************************************************************************************************************************************************/
		/* Iteratively Read and Process Data One Chunk at a Time. There are at Most	MAX_GPU_HISTORIES Per Chunk (i.e. Iteration). On Each Iteration:			*/
		/*	(1) Read data from file																																*/
		/*	(2) Determine which histories traverse the reconstruction volume and store this	information in a boolean array										*/
		/*	(3) Determine which bin each history belongs to																										*/
		/*	(4) Use the boolean array to determine which histories to keep and then push the intermediate data from these histories onto the permanent 			*/
		/*		storage std::vectors																															*/
		/*	(5) Free up temporary host/GPU array memory allocated during iteration																				*/
		/********************************************************************************************************************************************************/
		sprintf( print_statement, "Read data from disk and perform preprocessing");
		print_section_header( print_statement, '*', LIGHT, BLUE );
		sprintf( print_statement, "Iteratively reading data from hard disk");
		print_colored_text( print_statement, DARK, CYAN );	
		sprintf( print_statement, "Removing proton histories that don't pass through the reconstruction volume");
		print_colored_text( print_statement, DARK, CYAN );	
		sprintf( print_statement, "Binning the data from those that did...\n");
		print_colored_text( print_statement, DARK, CYAN );	
		timer( START, begin_data_reads, "for reading data, coordinate conversions/intersections, hull detection counts, and binning");
		int start_file_num = 0, end_file_num = 0, histories_2_process = 0;
		while( start_file_num != NUM_FILES )
		{
			while( end_file_num < NUM_FILES )
			{
				if( histories_2_process + histories_per_file[end_file_num] < MAX_GPU_HISTORIES )
					histories_2_process += histories_per_file[end_file_num];
				else
					break;
				end_file_num++;
			}
			read_data_chunk( histories_2_process, start_file_num, end_file_num );
			//histories_2_process = 1500000;
			recon_volume_intersections( histories_2_process );
			binning( histories_2_process );
			hull_detection( histories_2_process );
			initial_processing_memory_clean();
			
			start_file_num = end_file_num;
			histories_2_process = 0;
		}		
		execution_time_data_reads = timer( STOP, begin_data_reads, "for reading data, coordinate conversions/intersections, hull detection counts, and binning");
		if( COUNT_0_WEPLS )
			std::cout << "Histories with WEPL = 0 : " << zero_WEPL << std::endl;
		sprintf( print_statement, "Data reading complete.");
		print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );
		
		percentage_pass_intersection_cuts = (double) recon_vol_histories / total_histories * 100;
		sprintf(print_statement, "%d out of %d (%4.2f%%) histories traversed the reconstruction volume", recon_vol_histories, total_histories, percentage_pass_intersection_cuts );
		//shrink_vectors( recon_vol_histories );	// Shrink vector capacities to their size = # histories remaining reconstruction volume intersection cuts
		print_colored_text( print_statement, DARK, GREEN );
		
		hull_detection_finish();
		exit_program_if( EXIT_AFTER_HULLS, "through hull detection" );
		/********************************************************************************************************************************************************/
		/* Calculate the standard deviation in WEPL, relative ut-angle, and relative uv-angle for each bin.  Iterate through the valid history std::vectors one	*/
		/* chunk at a time, with at most MAX_GPU_HISTORIES per chunk, and calculate the difference between the mean WEPL and WEPL, mean relative ut-angle and	*/ 
		/* relative ut-angle, and mean relative uv-angle and relative uv-angle for each history. The standard deviation is then found by calculating the sum	*/
		/* of these differences for each bin and dividing it by the number of histories in the bin 																*/
		/********************************************************************************************************************************************************/
		sprintf( print_statement, "Calculating the cumulative sum of the squared deviation in WEPL and relative ut/uv angles over all histories for each bin");
		print_section_header( print_statement, '-', LIGHT, BLUE );

		int remaining_histories = recon_vol_histories;
		int start_position = 0;
		calculate_means();
		initialize_stddev();
		while( remaining_histories > 0 )
		{
			if( remaining_histories > MAX_CUTS_HISTORIES )
				histories_2_process = MAX_CUTS_HISTORIES;
			else
				histories_2_process = remaining_histories;
			sum_squared_deviations( start_position, histories_2_process );
			remaining_histories -= MAX_CUTS_HISTORIES;
			start_position		+= MAX_CUTS_HISTORIES;
		} 
		calculate_standard_deviations();
		/********************************************************************************************************************************************************/
		/* Iterate through the valid history vectors one chunk at a time, with at most MAX_GPU_HISTORIES per chunk, and perform statistical cuts				*/
		/********************************************************************************************************************************************************/
		sprintf( print_statement, "Perform statistical cuts and use the remaining data to generate the sinogram and FBP image");
		print_section_header( print_statement, '-', LIGHT, BLUE );
		
		remaining_histories = recon_vol_histories, start_position = 0;
		initialize_sinogram();
		
		sprintf( print_statement, "Performing statistical cuts...");
		print_colored_text( print_statement, DARK, CYAN );	
		while( remaining_histories > 0 )
		{
			if( remaining_histories > MAX_CUTS_HISTORIES )
				histories_2_process = MAX_CUTS_HISTORIES;
			else
				histories_2_process = remaining_histories;
			statistical_cuts( start_position, histories_2_process );
			remaining_histories -= MAX_CUTS_HISTORIES;
			start_position		+= MAX_CUTS_HISTORIES;
		}
		sprintf( print_statement, "Statistical cuts complete.");
		print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );
		
		percentage_pass_statistical_cuts = (double) post_cut_histories / total_histories * 100;
		sprintf(print_statement, "%d out of %d (%4.2f%%) histories also passed statistical cuts", post_cut_histories, total_histories, percentage_pass_statistical_cuts );
		print_colored_text( print_statement, DARK, GREEN );

		post_cut_memory_clean();
		resize_vectors( post_cut_histories );
		//shrink_vectors( post_cut_histories );
		exit_program_if( EXIT_AFTER_CUTS, "through statistical data cuts" );
		/********************************************************************************************************************************************************/
		/* Generate the sinogram from remaining histories after cuts, perform filtered backprojection, and generate/define the hull/initial iterate to use		*/
		/********************************************************************************************************************************************************/
		sprintf( print_statement, "Constructing sinogram...");
		print_colored_text( print_statement, DARK, CYAN );	
		
		construct_sinogram();
		exit_program_if( EXIT_AFTER_SINOGRAM, "through sinogram generation" );
		if( FBP_ON )
			FBP();
		exit_program_if( EXIT_AFTER_FBP, "through FBP" );
		hull_selection();
		define_initial_iterate();

		sprintf( print_statement, "Preprocessing complete");
		print_section_exit(print_statement, SECTION_EXIT_STRING, DARK, RED );

		execution_time_preprocessing = timer( STOP, begin_preprocessing, "for preprocessing");
		
		/********************************************************************************************************************************************************/
		/* Perform image reconstruction																							*/
		/********************************************************************************************************************************************************/		
		sprintf( print_statement, "Image Reconstruction");
		print_section_header( print_statement, '*', LIGHT, BLUE );
		
		timer( START, begin_reconstruction, "for complete image reconstruction");
		//image_reconstruction();
		image_reconstruction_GPU(); // Write to the external file	 		
		sprintf(print_statement, "Image reconstruction complete: ");
		print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );
		
		execution_time_DROP = timer( STOP, begin_DROP, "for all iterations of DROP");
		execution_time_reconstruction = timer( STOP, begin_reconstruction, "for complete image reconstruction");
		if( WRITE_X ) 
			array_2_disk(X_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
		print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );
		/********************************************************************************************************************************************************/
		/* PROGRAM COMPLETION TASKS																				*/
		/********************************************************************************************************************************************************/		
		sprintf( print_statement, "Program has finished execution.");
		print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );

		execution_time_program = timer( STOP, begin_program, "for entire program");	
		execution_times_2_txt();
		execution_times_2_csv();
		apply_permissions();
	}
	else
	{
		test_func();			
	}
	cout << "Helloall" << endl;
	
	/************************************************************************************************************************************************************/
	/* Program has finished execution. Require the user to hit enter to terminate the program and close the terminal/console window	and write execution times to disk							*/ 															
	/************************************************************************************************************************************************************/	
	exit_program_if(true);
	//exit(1);
}
/***********************************************************************************************************************************************************************************************************************/
/**************************************************************************************** t/v conversions and energy calibrations **************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void read_energy_responses( const int num_histories, const int start_file_num, const int end_file_num )
{
	
	//char data_filename[128];
	//char magic_number[5];
	//int version_id;
	//int file_histories;
	//float projection_angle, beam_energy;
	//int generation_date, preprocess_date;
	//int phantom_name_size, data_source_size, prepared_by_size;
	//char *phantom_name, *data_source, *prepared_by;
	//int data_size;
	////int gantry_position, gantry_angle, scan_histories;
	//int gantry_position, gantry_angle, scan_number, scan_histories;
	////int array_index = 0;
	//FILE* input_file;

	//puts("Reading energy detector responses and performing energy response calibration...");
	////printf("Reading File for Gantry Angle %d from Scan Number %d...\n", gantry_angle, scan_number );
	//sprintf(data_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION );
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************************** Execution Control Functions ********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
bool is_bad_angle( const int angle )
{
	static const int bad_angles[] = {0, 80, 84, 88, 92, 96, 100, 180, 260, 264, 268, 272, 276};
	return std::binary_search( bad_angles, bad_angles + sizeof(bad_angles) / sizeof(int), angle );
}
void timer( bool start, clock_t& start_time, clock_t& end_time, double& execution_time, const char* statement_in )
{
	char statement_out[256];
	if( start )
		start_time = clock();
	else if( !start )
	{
		end_time = clock();
		clock_t execution_clock_cycles = (end_time - start_time);
		execution_time = static_cast<double>( execution_clock_cycles) / CLOCKS_PER_SEC;
		sprintf(statement_out, "Total execution time %s: %3f [seconds]\n", statement_in, execution_time );	
		print_colored_text( statement_out, LIGHT, BROWN );
	}
	else
		puts("ERROR: Invalid timer control parameter passed");
}
double timer( bool start, clock_t& start_time, const char* statement_in )
{
	char statement_out[256];
	double execution_time = 0.0;
	if( start )
		start_time = clock();
	else
	{
		clock_t end_time = clock();
		clock_t execution_clock_cycles = (end_time - start_time);
		execution_time = static_cast<double>( execution_clock_cycles) / CLOCKS_PER_SEC;
		sprintf(statement_out, "Total execution time %s: %3f [seconds]\n", statement_in, execution_time );	
		print_colored_text( statement_out, LIGHT, BROWN );
	}
	return execution_time;
}
void pause_execution()
{
	clock_t pause_start, pause_end;
	pause_start = clock();
	//char user_response[20];
	puts("Execution paused.  Hit enter to continue execution.\n");
	 //Clean the stream and ask for input
	//std::cin.ignore ( std::numeric_limits<std::streamsize>::max(), '\n' );
	std::cin.get();

	pause_end = clock();
	pause_cycles += pause_end - pause_start;
}
void exit_program_if( bool early_exit, const char* statement)
{
	if( early_exit )
	{
		char user_response[20];
		double execution_time;
		timer( STOP, program_start, program_end, execution_time, statement );
		//char statement[] = "Press 'ENTER' to exit program and close console window";
		print_section_header( statement, '*', DARK, CYAN );
		fgets(user_response, sizeof(user_response), stdin);
		exit(1);
	}
}
void exit_program_if( bool early_exit)
{
	if( early_exit )
	{
		char user_response[20];
		double execution_time;
		timer( STOP, program_start, program_end, execution_time, "" );
		puts("Hit enter to stop...");
		fgets(user_response, sizeof(user_response), stdin);
		exit(1);
	}
}
/***********************************************************************************************************************************************************************************************************************/
/******************************************************************************* Reading/Setting Run Settings, Parameters, and Configurations **************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void command_line_settings( unsigned int num_arguments, char** arguments )
{
	num_run_arguments = num_arguments;
	run_arguments = arguments; 
	if(num_arguments == 4)
	{
	  
	  //METHOD = atoi(run_arguments[1]);
	  ETA = atof(run_arguments[2]);
	  PSI_SIGN = atoi(run_arguments[3]);
	  
	  
	}
	//printf("num_arguments = %d\n", num_arguments);
	//printf("num_run_arguments = %d\n", num_run_arguments);
	//printf("chars = %s\n", run_arguments[2]);
	//printf("atof = %3f\n", atof(run_arguments[2]));
	/*if( num_arguments > 1 )
		CONFIG_DIRECTORY = arguments[1];
	if( num_run_arguments > 2 )
	{
		parameter_container.lambda = atof(run_arguments[2]); 
		LAMBDA = atof(run_arguments[2]);
		CONSTANT_LAMBDA_SCALE = VOXEL_WIDTH * LAMBDA;
	}
	if( num_run_arguments > 3 )
	{
		num_voxel_scales =  num_run_arguments - 3;
		voxel_scales = (double*)calloc( num_voxel_scales, sizeof(double) ); 
		for( unsigned int i = 3; i < num_run_arguments; i++ )
			voxel_scales[i-3] = atof(run_arguments[i]);
	}*/	
	//			  1				   2		   3	 4	  5    6   ...  N + 3  
	// ./pCT_Reconstruction [.cfg address] [LAMBDA] [C1] [C2] [C3] ... [CN]
	//switch( true )
	//{
	//	case (num_arguments >= 4): 
	//		num_voxel_scales =  num_run_arguments - 3;
	//		voxel_scales = (double*)calloc( num_voxel_scales, sizeof(double) ); 
	//		for( unsigned int i = 3; i < num_run_arguments; i++ )
	//			voxel_scales[i-3] = atof(run_arguments[i]);
	//	case (num_arguments >= 3): 
	//		parameter_container.lambda = atof(run_arguments[2]); 
	//		LAMBDA = atof(run_arguments[2]);
	//	case (num_arguments >= 2): 
	//		CONFIG_DIRECTORY = arguments[1];
	//	case default: break;
	//}
	//printf("LAMBDA = %3f\n", LAMBDA);
	
	//cout << "voxels to be scaled = " << num_voxel_scales << endl;
	//for( unsigned int i = 0; i < num_voxel_scales; i++ )
		//printf("voxel_scale[%d] = %3f\n", i, voxel_scales[i] );
}
bool file_exists ( const char* file_path) 
{
    #if defined(_WIN32) || defined(_WIN64)
		return false;
		//return file_path && ( PathFileExists(file_path) != 0 );
    #else
		if( access( file_path, F_OK ) != -1 )
			return true;
		else 
			return false;
		//struct stat sb;
		//return file_path && (stat (file_path, &sb) == 0 );
   #endif
} 
bool file_exists_OS_independent ( const char* file_path)
{
	//char system_command[256];
	//sprintf("cd %s", 
	return true;
}
bool directory_exists(char* dir_name )
{
	char mkdir_command[256]= "cd ";
	strcat( mkdir_command, dir_name);
	return !system( mkdir_command );
}
unsigned int create_unique_dir( char* dir_name )
{
	unsigned int i = 0;
	char dir_2_make[256];
	sprintf(dir_2_make, "%s", dir_name);
	while( directory_exists(dir_2_make) )
		sprintf(dir_2_make, "%s_%u", dir_name, ++i);
	mkdir( dir_2_make );
	return i;
}
void assign_directories()
{
	switch( SCAN_TYPE )
	{
		case EXPERIMENTAL:	sprintf(DATA_TYPE, "%s", EXPERIMENTAL_FOLDER );
		case SIMULATED_G:	sprintf(DATA_TYPE, "%s", SIMULATED_FOLDER );
		case SIMULATED_T:	sprintf(DATA_TYPE, "%s", SIMULATED_FOLDER );
	}
	sprintf(INPUT_DIRECTORY, "%s//%s//%s//", PCT_PATH_TARDIS, PCT_DATA_FOLDER, ORGANIZED_DATA_FOLDER ); 
	sprintf(OUTPUT_DIRECTORY, "%s//%s//%s//", PCT_PATH_TARDIS, PCT_DATA_FOLDER, RECON_DATA_FOLDER );
	sprintf(INPUT_FROM, "%s//%s//%s//%s//%s//%s", PHANTOM, DATA_TYPE, RUN_DATE, RUN_NUMBER, OUTPUT_FOLDER, PREPROCESSED_DATE ); 
	sprintf(OUTPUT_TO, "%s//%s//%s//%s//%s//%s", PHANTOM, DATA_TYPE, RUN_DATE, RUN_NUMBER, OUTPUT_FOLDER, PREPROCESSED_DATE );

	//char statement[256];
	char folder_name[256];
	
	unsigned int i = 0;
	if( TESTING_ON )
		sprintf(OUTPUT_TO_UNIQUE, "%s//%s//B_%d_L_%3f", OUTPUT_TO, RECONSTRUCTION_FOLDER, DROP_BLOCK_SIZE, LAMBDA );
	else
		sprintf(OUTPUT_TO_UNIQUE, "%s//%s//%s", OUTPUT_TO, RECONSTRUCTION_FOLDER, EXECUTION_DATE );
	sprintf(folder_name, "%s%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE );
	if( OVERWRITING_OK )
	{
		sprintf(print_statement, "Overwriting previous data permitted:");
		print_colored_text(print_statement, LIGHT, CYAN);
		while( directory_exists(folder_name ) )
			sprintf(folder_name, "%s%s_%u", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, ++i );
		sprintf(folder_name, "%s%s_%u", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, --i );
		mkdir( folder_name );
	}
	else
	{
		sprintf(print_statement, "Overwriting previous data NOT permitted:");
		print_colored_text(print_statement, LIGHT, CYAN);
		sprintf(folder_name, "%s%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE );
		i = create_unique_dir( folder_name );	
	}
	if( i != 0 )
		sprintf(OUTPUT_TO_UNIQUE, "%s_%u", OUTPUT_TO_UNIQUE, i );	
	sprintf(print_statement, "Writing output data/images to:");
	print_colored_text(print_statement, LIGHT, CYAN );
	print_colored_text(OUTPUT_TO_UNIQUE, DARK, GREEN );
}
bool mkdir(char* directory)
{
	char mkdir_command[256];
	#if defined(_WIN32) || defined(_WIN64)
		sprintf(mkdir_command, "mkdir \"%s\"", directory);
	#else
		sprintf(mkdir_command, "mkdir -p \"%s\"", directory);
	#endif
	return !system(mkdir_command);
}
void apply_permissions()
{
	//char statement[256];
	char hostname_command[] = "echo $HOSTNAME";
	char permission_commands[256];
	std::string terminal_string = terminal_response(hostname_command);
	terminal_string.erase (terminal_string.length()-1,1); 
	
	//std::cout << "terminal string output =" << terminal_string << ";" << endl;
	//std::cout << "workstation_hostname string =" << workstation_hostname << ";" << endl;
	//std::cout << (terminal_string.compare(workstation_hostname) == 0) << endl;
	if( terminal_string.compare(jpertwee_ID) == 0 )
	{
		//puts("Setting permissions on JPertwee");
		sprintf( print_statement, "Setting permissions on JPertwee...");
		print_colored_text( print_statement, LIGHT, BLUE );	
		
		sprintf(permission_commands, "chmod -R %s %s%s", GLOBAL_ACCESS, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE );
		//system("chmod -R 777 /local/organized_data/*");
		system(permission_commands);
		//sprintf(permission_commands, "chmod -R 777 %s%s//*", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE );
		//system("chmod -R 777 /local/pCT_code/*");
	}
	//else if( (terminal_string.compare(whartnell_hostname) == 0) || (terminal_string.compare(whartnell_ID) )
	//{
	//	puts("Setting permissions on WHartnell");
	//	//system("chmod -R 777 /local/organized_data/*");
	//	system("chmod -R 777 /local/reconstruction_data/*");
	//	system("chmod -R 777 /local/pCT_code/*");
	//}
	else if( terminal_string.compare(workstation_2_hostname) == 0 )
	{
		sprintf( print_statement, "Setting permissions on Workstation #2...");
		print_colored_text( print_statement, LIGHT, BLUE );	
		system("chmod -R 777 /home/share/*");
	}
	// Workstation #2
	//system("chmod -R 777 /home/share/*");
	//// Jpertwee
	//system("chmod -R 777 /local/organized_data/*");
	//system("chmod -R 777 /local/pct_code/*");
}
void post_reconstruction_results_transfers()
{
	//// Workstation #2
	////const char INPUT_DIRECTORY[]	= "//home//share//organized_data//";
	////const char OUTPUT_DIRECTORY[]	= "//home//share//reconstruction_data//";
	//// WHartnell
	////const char INPUT_DIRECTORY[]	= "//local//organized_data//pCT_data//";
	////const char OUTPUT_DIRECTORY[]	= "//local//reconstruction_data//pCT_data//";
	//// JPertwee
	//const char INPUT_DIRECTORY[]	= "//local//organized_data//";
	//const char OUTPUT_DIRECTORY[]	= "//local//reconstruction_data//";
	//const char KODIAK_RECON_DIR[]	= "//data/ion//pCT_data//reconstruction_data//";
	//const char WS2_RECON_DIR[]		= "//home//share//reconstruction_data//";
	//const char WHARTNELL_RECON_DIR[]	= "//local//pCT_Data//reconstruction_data//";

	////const char INPUT_FROM[]		= "input_CTP404_4M//Simulated//141028";
	////const char INPUT_FROM[]		= "CTP404_Sensitom//Experimental//150516//0061//Output//150625";
	//const char INPUT_FROM[]		= "Edge_Phantom//Experimental//150516//0057//Output//150525";
	////const char INPUT_FROM[]		= "Head_Phantom//Experimental//150516//0059_Sup//Output//150625";
	////const char INPUT_FROM[]		= "Head_Phantom//Experimental//150516//0060_inf//Output//150625";

	////const char OUTPUT_TO[]      = "input_CTP404_4M//Simulated//141028";
	////const char OUTPUT_TO[]      = "CTP404_Sensitom//Experimental//150516//0061";
	//const char OUTPUT_TO[]      = "Edge_Phantom//Experimental//150516//0057";
	////const char OUTPUT_TO[]      = "Head_Phantom//Experimental//150516//0059_Sup";
	////const char OUTPUT_TO[]      = "Head_Phantom//Experimental//150516//0060_Inf";

	//const char KODIAK_CODE_DIR[]	= "//data/ion//pCT_code//Reconstruction//";
	//const char WS2_CODE_DIR[]		= "//home//share//pCT_code//";
	//const char WHARTNELL_CODE_DIR[]	= "//local//pCT_code//";
	//const char JPERTWEE_CODE_DIR[]	= "//local//pCT_code//";

	//const char KODIAK_SCP_BASE[]	= "scp -r schultze@kodiak:";

	//char OUTPUT_TO_UNIQUE[256];
	//char KODIAK_OUTPUT_PATH[256];
	//char WS2_OUTPUT_PATH[256];
	//char WHARTNELL_OUTPUT_PATH[256];
	// scp -r * schultze@kodiak:/data/ion/pCT_data/reconstruction_data/Edge_Phantom/Experimental/150516/0057/
	char scp_command[256];
	sprintf(scp_command, "scp -r %s%s %s%s%s//", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, KODIAK_LOGIN, KODIAK_RECON_DIR, OUTPUT_TO_UNIQUE);
	puts(scp_command);
}
/***********************************************************************************************************************************************************************************************************************/
/************************************************************************************** Memory Transfers, Maintenance, and Cleaning ************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void initializations()
{
	puts("Allocating statistical analysis arrays on host/GPU...");

	bin_counts_h		  = (int*)	 calloc( NUM_BINS, sizeof(int)	 );
	mean_WEPL_h			  = (float*) calloc( NUM_BINS, sizeof(float) );
	mean_rel_ut_angle_h	  = (float*) calloc( NUM_BINS, sizeof(float) );
	mean_rel_uv_angle_h	  = (float*) calloc( NUM_BINS, sizeof(float) );
	
	if( ( bin_counts_h == NULL ) || (mean_WEPL_h == NULL) || (mean_rel_ut_angle_h == NULL) || (mean_rel_uv_angle_h == NULL) )
	{
		puts("std dev allocation error\n");
		exit(1);
	}

	cudaMalloc((void**) &bin_counts_d,			SIZE_BINS_INT );
	cudaMalloc((void**) &mean_WEPL_d,			SIZE_BINS_FLOAT );
	cudaMalloc((void**) &mean_rel_ut_angle_d,	SIZE_BINS_FLOAT );
	cudaMalloc((void**) &mean_rel_uv_angle_d,	SIZE_BINS_FLOAT );

	cudaMemcpy( bin_counts_d,			bin_counts_h,			SIZE_BINS_INT,		cudaMemcpyHostToDevice );
	cudaMemcpy( mean_WEPL_d,			mean_WEPL_h,			SIZE_BINS_FLOAT,	cudaMemcpyHostToDevice );
	cudaMemcpy( mean_rel_ut_angle_d,	mean_rel_ut_angle_h,	SIZE_BINS_FLOAT,	cudaMemcpyHostToDevice );
	cudaMemcpy( mean_rel_uv_angle_d,	mean_rel_uv_angle_h,	SIZE_BINS_FLOAT,	cudaMemcpyHostToDevice );
}
void reserve_vector_capacity()
{
	// Reserve enough memory for vectors to hold all histories.  If a vector grows to the point where the next memory address is already allocated to another
	// object, the system must first move the vector to a new location in memory which can hold the existing vector and new element.  The eventual size of these
	// vectors is quite large and the possibility of this happening is high for one or more vectors and it can happen multiple times as the vector grows.  Moving 
	// a vector and its contents is a time consuming process, especially as it becomes large, so we reserve enough memory to guarantee this does not happen.
	bin_num_vector.reserve( total_histories );
	//gantry_angle_vector.reserve( total_histories );
	WEPL_vector.reserve( total_histories );
	x_entry_vector.reserve( total_histories );
	y_entry_vector.reserve( total_histories );
	z_entry_vector.reserve( total_histories );
	x_exit_vector.reserve( total_histories );
	y_exit_vector.reserve( total_histories );
	z_exit_vector.reserve( total_histories );
	xy_entry_angle_vector.reserve( total_histories );
	xz_entry_angle_vector.reserve( total_histories );
	xy_exit_angle_vector.reserve( total_histories );
	xz_exit_angle_vector.reserve( total_histories );
}
void initial_processing_memory_clean()
{
	//clear_input_memory
	//free( missed_recon_volume_h );
	free( gantry_angle_h );
	cudaFree( x_entry_d );
	cudaFree( y_entry_d );
	cudaFree( z_entry_d );
	cudaFree( x_exit_d );
	cudaFree( y_exit_d );
	cudaFree( z_exit_d );
	cudaFree( missed_recon_volume_d );
	cudaFree( bin_num_d );
	cudaFree( WEPL_d);
}
void resize_vectors( unsigned int new_size )
{
	bin_num_vector.resize( new_size );
	//gantry_angle_vector.resize( new_size );
	WEPL_vector.resize( new_size );
	x_entry_vector.resize( new_size );	
	y_entry_vector.resize( new_size );	
	z_entry_vector.resize( new_size );
	x_exit_vector.resize( new_size );
	y_exit_vector.resize( new_size );
	z_exit_vector.resize( new_size );
	xy_entry_angle_vector.resize( new_size );	
	xz_entry_angle_vector.resize( new_size );	
	xy_exit_angle_vector.resize( new_size );
	xz_exit_angle_vector.resize( new_size );
}
void shrink_vectors( unsigned int new_capacity )
{
	//bin_num_vector.shrink_to_fit();
	//gantry_angle_vector.shrink_to_fit();
	//WEPL_vector.shrink_to_fit();
	//x_entry_vector.shrink_to_fit();	
	//y_entry_vector.shrink_to_fit();	
	//z_entry_vector.shrink_to_fit();	
	//x_exit_vector.shrink_to_fit();	
	//y_exit_vector.shrink_to_fit();	
	//z_exit_vector.shrink_to_fit();	
	//xy_entry_angle_vector.shrink_to_fit();	
	//xz_entry_angle_vector.shrink_to_fit();	
	//xy_exit_angle_vector.shrink_to_fit();	
	//xz_exit_angle_vector.shrink_to_fit();	
}
void data_shift_vectors( unsigned int read_index, unsigned int write_index )
{
	bin_num_vector[write_index] = bin_num_vector[read_index];
	//gantry_angle_vector[write_index]  = gantry_angle_vector[read_index];
	WEPL_vector[write_index] = WEPL_vector[read_index];
	x_entry_vector[write_index] = x_entry_vector[read_index];
	y_entry_vector[write_index] = y_entry_vector[read_index];
	z_entry_vector[write_index] = z_entry_vector[read_index];
	x_exit_vector[write_index] = x_exit_vector[read_index];
	y_exit_vector[write_index] = y_exit_vector[read_index];
	z_exit_vector[write_index] = z_exit_vector[read_index];
	xy_entry_angle_vector[write_index] = xy_entry_angle_vector[read_index];
	xz_entry_angle_vector[write_index] = xz_entry_angle_vector[read_index];
	xy_exit_angle_vector[write_index] = xy_exit_angle_vector[read_index];
	xz_exit_angle_vector[write_index] = xz_exit_angle_vector[read_index];
}
void initialize_stddev()
{	
	stddev_rel_ut_angle_h = (float*) calloc( NUM_BINS, sizeof(float) );	
	stddev_rel_uv_angle_h = (float*) calloc( NUM_BINS, sizeof(float) );	
	stddev_WEPL_h		  = (float*) calloc( NUM_BINS, sizeof(float) );
	if( ( stddev_rel_ut_angle_h == NULL ) || (stddev_rel_uv_angle_h == NULL) || (stddev_WEPL_h == NULL) )
	{
		puts("std dev allocation error\n");
		exit(1);
	}
	cudaMalloc((void**) &stddev_rel_ut_angle_d,	SIZE_BINS_FLOAT );
	cudaMalloc((void**) &stddev_rel_uv_angle_d,	SIZE_BINS_FLOAT );
	cudaMalloc((void**) &stddev_WEPL_d,			SIZE_BINS_FLOAT );

	cudaMemcpy( stddev_rel_ut_angle_d,	stddev_rel_ut_angle_h,	SIZE_BINS_FLOAT,	cudaMemcpyHostToDevice );
	cudaMemcpy( stddev_rel_uv_angle_d,	stddev_rel_uv_angle_h,	SIZE_BINS_FLOAT,	cudaMemcpyHostToDevice );
	cudaMemcpy( stddev_WEPL_d,			stddev_WEPL_h,			SIZE_BINS_FLOAT,	cudaMemcpyHostToDevice );
}
void post_cut_memory_clean()
{
	//char statement[] = "Freeing unnecessary memory, resizing vectors, and shrinking vectors to fit just the remaining histories...";
	sprintf(print_statement, "Freeing unnecessary memory, resizing vectors, and shrinking vectors to fit just the remaining histories...");
	print_colored_text( print_statement, LIGHT, CYAN );
	//free(failed_cuts_h );
	free(stddev_rel_ut_angle_h);
	free(stddev_rel_uv_angle_h);
	free(stddev_WEPL_h);

	//cudaFree( failed_cuts_d );
	//cudaFree( bin_num_d );
	//cudaFree( WEPL_d );
	//cudaFree( xy_entry_angle_d );
	//cudaFree( xz_entry_angle_d );
	//cudaFree( xy_exit_angle_d );
	//cudaFree( xz_exit_angle_d );

	cudaFree( mean_rel_ut_angle_d );
	cudaFree( mean_rel_uv_angle_d );
	cudaFree( mean_WEPL_d );
	cudaFree( stddev_rel_ut_angle_d );
	cudaFree( stddev_rel_uv_angle_d );
	cudaFree( stddev_WEPL_d );
}
/***********************************************************************************************************************************************************************************************************************/
/**************************************************************************************** Preprocessing setup and initializations **************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void write_run_settings()
{
	char user_response[20];
	char run_settings_filename[512];
	puts("Reading tracker plane positions...");

	sprintf(run_settings_filename, "%s%s\\run_settings.cfg", INPUT_DIRECTORY, INPUT_FROM);
	if( DEBUG_TEXT_ON )
		printf("Opening run settings file %s...\n", run_settings_filename);
	std::ofstream run_settings_file(run_settings_filename);		
	if( !run_settings_file.is_open() ) {
		printf("ERROR: run settings file file not found at %s!\n", run_settings_filename);	
		exit_program_if(true);
	}
	else
	{
		fputs("Found File", stdout);
		fflush(stdout);
		printf("user_response = \"%s\"\n", user_response);
	}
	if( DEBUG_TEXT_ON )
		puts("Loading run settings...");
	run_settings_file << "MAX_GPU_HISTORIES = " << MAX_GPU_HISTORIES << std::endl;
	run_settings_file << "GANTRY_ANGLE_INTERVAL = " << GANTRY_ANGLE_INTERVAL << std::endl;
	run_settings_file << "SSD_T_SIZE = " << SSD_T_SIZE << std::endl;
	run_settings_file << "SSD_V_SIZE = " << SSD_V_SIZE << std::endl;
	run_settings_file << "T_BIN_SIZE = " << T_BIN_SIZE << std::endl;
	run_settings_file << "V_BIN_SIZE = " << V_BIN_SIZE << std::endl;
	run_settings_file << "ANGULAR_BIN_SIZE = " << ANGULAR_BIN_SIZE << std::endl;
	run_settings_file << "GANTRY_ANGLE_INTERVAL = " << GANTRY_ANGLE_INTERVAL << std::endl;
	run_settings_file << "RECON_CYL_RADIUS = " << RECON_CYL_RADIUS << std::endl;
	run_settings_file << "RECON_CYL_HEIGHT = " << RECON_CYL_HEIGHT << std::endl;
	run_settings_file << "COLUMNS = " << COLUMNS << std::endl;
	run_settings_file << "ROWS = " << ROWS << std::endl;
	run_settings_file << "SLICE_THICKNESS" << SLICE_THICKNESS << std::endl;
	//run_settings_file << "RECON_CYL_RADIUS = " << RECON_CYL_RADIUS << std::endl;
	//run_settings_file << "RECON_CYL_HEIGHT = " << RECON_CYL_HEIGHT << std::endl;
	//run_settings_file << "COLUMNS = " << COLUMNS << std::endl;
	//run_settings_file << "ROWS = " << ROWS << std::endl;
	//run_settings_file << "SLICE_THICKNESS" << SLICE_THICKNESS << std::endl;
	run_settings_file.close();
}
void assign_SSD_positions()	//HERE THE COORDINATES OF THE DETECTORS PLANES ARE LOADED, THE CONFIG FILE IS CREATED BY FORD (RWS)
{
	char user_response[20];
	char configFilename[512];
	puts("Reading tracker plane positions...");

	sprintf(configFilename, "%s%s\\scan.cfg", INPUT_DIRECTORY, INPUT_FROM);
	if( DEBUG_TEXT_ON )
		printf("Opening config file %s...\n", configFilename);
	std::ifstream configFile(configFilename);		
	if( !configFile.is_open() ) {
		printf("ERROR: config file not found at %s!\n", configFilename);	
		exit_program_if(true);
	}
	else
	{
		fputs("Found File", stdout);
		fflush(stdout);
		printf("user_response = \"%s\"\n", user_response);
	}
	if( DEBUG_TEXT_ON )
		puts("Reading Tracking Plane Positions...");
	for( unsigned int i = 0; i < 8; i++ ) {
		configFile >> SSD_u_Positions[i];
		if( DEBUG_TEXT_ON )
			printf("SSD_u_Positions[%d] = %3f", i, SSD_u_Positions[i]);
	}
	
	configFile.close();

}
void count_histories()
{
	for( int scan_number = 0; scan_number < NUM_SCANS; scan_number++ )
		histories_per_scan[scan_number] = 0;

	histories_per_file =				 (int*) calloc( NUM_SCANS * GANTRY_ANGLES, sizeof(int) );
	histories_per_gantry_angle =		 (int*) calloc( GANTRY_ANGLES, sizeof(int) );
	recon_vol_histories_per_projection = (int*) calloc( GANTRY_ANGLES, sizeof(int) );

	if( DEBUG_TEXT_ON )
		puts("Counting proton histories...\n");
	switch( DATA_FORMAT )
	{
		case OLD_FORMAT : count_histories_old();	break;
		case VERSION_0  : count_histories_v0();		break;
		case VERSION_1  : count_histories_v1();		break;
	}
	/*if( DEBUG_TEXT_ON )
	{
		for( int file_number = 0, gantry_position_number = 0; file_number < (NUM_SCANS * GANTRY_ANGLES); file_number++, gantry_position_number++ )
		{
			if( file_number % NUM_SCANS == 0 )
				printf("There are a total of %d histories from gantry angle %d\n", histories_per_gantry_angle[gantry_position_number], int(gantry_position_number* GANTRY_ANGLE_INTERVAL) );			
			printf("====> %d Histories are From Scan Number %d\n", histories_per_file[file_number], (file_number % NUM_SCANS) + 1 );
			
		}
		for( int scan_number = 0; scan_number < NUM_SCANS; scan_number++ )
			printf("There are a total of %d histories in Scan Number %d \n", histories_per_scan[scan_number], scan_number + 1);
		printf("There are a total of %d histories\n", total_histories);
	}*/
}
void count_histories_old()
{
	//char user_response[20];
	char data_filename[128];
	int file_size, num_histories, file_number = 0, gantry_position_number = 0;
	for( int gantry_angle = 0; gantry_angle < 360; gantry_angle += int(GANTRY_ANGLE_INTERVAL), gantry_position_number++ )
	{
		for( int scan_number = 1; scan_number <= NUM_SCANS; scan_number++, file_number++ )
		{
			
			sprintf( data_filename, "%s%s/%s_trans%d_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, scan_number, gantry_angle, INPUT_DATA_EXTENSION );
			FILE *data_file = fopen(data_filename, "rb");
			if( data_file == NULL )
			{
				fputs( "Error Opening Data File:  Check that the directories are properly named.", stderr ); 
				exit_program_if(true);
			}
			fseek( data_file, 0, SEEK_END );
			file_size = ftell( data_file );
			if( BINARY_ENCODING )
			{
				if( file_size % BYTES_PER_HISTORY ) 
				{
					printf("ERROR! Problem with bytes_per_history!\n");
					exit_program_if(true);
				}
				num_histories = file_size / BYTES_PER_HISTORY;	
			}
			else
				num_histories = file_size;							
			fclose(data_file);
			histories_per_file[file_number] = num_histories;
			histories_per_gantry_angle[gantry_position_number] += num_histories;
			histories_per_scan[scan_number-1] += num_histories;
			total_histories += num_histories;
			
			if( DEBUG_TEXT_ON )
				printf("There are %d Histories for Gantry Angle %d From Scan Number %d\n", num_histories, gantry_angle, scan_number);
		}
	}
}
void count_histories_v0()
{
	char data_filename[256];
	float projection_angle;
	unsigned int num_histories, file_number = 0, gantry_position_number = 0;
	char magic_number_string[5];
	for( unsigned int gantry_angle = 0; gantry_angle < 360; gantry_angle += int(GANTRY_ANGLE_INTERVAL), gantry_position_number++ )
	{
		for( unsigned int scan_number = 1; scan_number <= NUM_SCANS; scan_number++, file_number++ )
		{
			sprintf(data_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION  );
			/*
			Contains the following headers:
				Magic number identifier: "PCTD" (4-byte string)
				Format version identifier (integer)
				Number of events in file (integer)
				Projection angle (float | degrees)
				Beam energy (float | MeV)
				Acquisition/generation date (integer | Unix time)
				Pre-process date (integer | Unix time)
				Phantom name or description (variable length string)
				Data source (variable length string)
				Prepared by (variable length string)
				* Note on variable length strings: each variable length string should be preceded with an integer containing the number of characters in the string.			
			*/
			FILE* data_file = fopen(data_filename, "rb");
			if( data_file == NULL )
			{
				fputs( "Error Opening Data File:  Check that the directories are properly named.", stderr ); 
				exit_program_if(true);
			}
			
			//fread(&magic_number, 4, 1, data_file );
			//if( magic_number != MAGIC_NUMBER_CHECK ) 
			//{
			//	//puts(magic_number);
			//	puts("Error: unknown file type (should be PCTD)!\n");
			//	exit_program_if(true);
			//}
			fread(&magic_number_string, 4, 1, data_file );
			magic_number_string[4] = '\0';
			if( strcmp( magic_number_string, "PCTD" ) != 0 ) 
			{
				//puts(magic_number);
				puts("Error: unknown file type (should be PCTD)!\n");
				exit_program_if(true);
			}
			fread(&VERSION_ID, sizeof(int), 1, data_file );			
			if( VERSION_ID == 0 )
			{
				fread(&num_histories, sizeof(int), 1, data_file );
				//if( DEBUG_TEXT_ON )
				//	printf("There are %d Histories for Gantry Angle %d From Scan Number %d\n", num_histories, gantry_angle, scan_number);
				histories_per_file[file_number] = num_histories;
				histories_per_gantry_angle[gantry_position_number] += num_histories;
				histories_per_scan[scan_number-1] += num_histories;
				total_histories += num_histories;
			
				fread(&projection_angle, sizeof(float), 1, data_file );
				projection_angles.push_back(projection_angle);

				fseek( data_file, 2 * sizeof(int) + sizeof(float), SEEK_CUR );
				fread(&PHANTOM_NAME_SIZE, sizeof(int), 1, data_file );

				fseek( data_file, PHANTOM_NAME_SIZE, SEEK_CUR );
				fread(&DATA_SOURCE_SIZE, sizeof(int), 1, data_file );

				fseek( data_file, DATA_SOURCE_SIZE, SEEK_CUR );
				fread(&PREPARED_BY_SIZE, sizeof(int), 1, data_file );

				fseek( data_file, PREPARED_BY_SIZE, SEEK_CUR );
				fclose(data_file);
				SKIP_2_DATA_SIZE = 4 + 7 * sizeof(int) + 2 * sizeof(float) + PHANTOM_NAME_SIZE + DATA_SOURCE_SIZE + PREPARED_BY_SIZE;
				//pause_execution();
			}
			else if( VERSION_ID == 1 )
			{
				fread(&num_histories, sizeof(int), 1, data_file );
				//if( DEBUG_TEXT_ON )
				//	printf("There are %d Histories for Gantry Angle %d From Scan Number %d\n", num_histories, gantry_angle, scan_number);
				histories_per_file[file_number] = num_histories;
				histories_per_gantry_angle[gantry_position_number] += num_histories;
				histories_per_scan[scan_number-1] += num_histories;
				total_histories += num_histories;
			
				fread(&projection_angle, sizeof(float), 1, data_file );
				projection_angles.push_back(projection_angle);

				fseek( data_file, 2 * sizeof(int) + sizeof(float), SEEK_CUR );
				fread(&PHANTOM_NAME_SIZE, sizeof(int), 1, data_file );

				fseek( data_file, PHANTOM_NAME_SIZE, SEEK_CUR );
				fread(&DATA_SOURCE_SIZE, sizeof(int), 1, data_file );

				fseek( data_file, DATA_SOURCE_SIZE, SEEK_CUR );
				fread(&PREPARED_BY_SIZE, sizeof(int), 1, data_file );

				fseek( data_file, PREPARED_BY_SIZE, SEEK_CUR );
				fclose(data_file);
				SKIP_2_DATA_SIZE = 4 + 7 * sizeof(int) + 2 * sizeof(float) + PHANTOM_NAME_SIZE + DATA_SOURCE_SIZE + PREPARED_BY_SIZE;
				//pause_execution();
			}
			else 
			{
				printf("ERROR: Data format is not Version (%d)!\n", VERSION_ID);
				exit_program_if(true);
			}						
		}
	}
}
void count_histories_v02()
{
	//char user_response[20];
	char data_filename[256];
	int num_histories, file_number = 0, gantry_position_number = 0;
	for( int gantry_angle = 0; gantry_angle < 360; gantry_angle += int(GANTRY_ANGLE_INTERVAL), gantry_position_number++ )
	{
		for( int scan_number = 1; scan_number <= NUM_SCANS; scan_number++, file_number++ )
		{
			sprintf(data_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION  );
			std::ifstream data_file(data_filename, std::ios::binary);
			if( data_file == NULL )
			{
				fputs( "File not found:  Check that the directories and files are properly named.", stderr ); 
				exit_program_if(true);
			}
			char magic_number[5];
			data_file.read(magic_number, 4);
			magic_number[4] = '\0';
			if( strcmp(magic_number, "PCTD") ) {
				puts("Error: unknown file type (should be PCTD)!\n");
				exit_program_if(true);
			}
			int version_id;
			data_file.read((char*)&version_id, sizeof(int));
			if( version_id == 0 )
			{
				data_file.read((char*)&num_histories, sizeof(int));						
				data_file.close();
				histories_per_file[file_number] = num_histories;
				histories_per_gantry_angle[gantry_position_number] += num_histories;
				histories_per_scan[scan_number-1] += num_histories;
				total_histories += num_histories;
			
				if( DEBUG_TEXT_ON )
					printf("There are %d Histories for Gantry Angle %d From Scan Number %d\n", num_histories, gantry_angle, scan_number);
			}
			else 
			{
				printf("ERROR: Data format is not Version (%d)!\n", version_id);
				exit_program_if(true);
			}			
		}
	}
}
void count_histories_v1()
{
	//char user_response[20];
	char data_filename[256];
	int num_histories, file_number = 0, gantry_position_number = 0;
	for( int gantry_angle = 0; gantry_angle < 360; gantry_angle += int(GANTRY_ANGLE_INTERVAL), gantry_position_number++ )
	{
		for( int scan_number = 1; scan_number <= NUM_SCANS; scan_number++, file_number++ )
		{
			sprintf(data_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION  );
			std::ifstream data_file(data_filename, std::ios::binary);
			if( data_file == NULL )
			{
				fputs( "File not found:  Check that the directories and files are properly named.", stderr ); 
				exit_program_if(true);
			}
			char magic_number[5];
			data_file.read(magic_number, 4);
			magic_number[4] = '\0';
			if( strcmp(magic_number, "PCTD") ) {
				puts("Error: unknown file type (should be PCTD)!\n");
				exit_program_if(true);
			}
			int version_id;
			data_file.read((char*)&version_id, sizeof(int));
			if( version_id == 1 )
			{
				data_file.read((char*)&num_histories, sizeof(int));						
				data_file.close();
				histories_per_file[file_number] = num_histories;
				histories_per_gantry_angle[gantry_position_number] += num_histories;
				histories_per_scan[scan_number-1] += num_histories;
				total_histories += num_histories;
			
				if( DEBUG_TEXT_ON )
					printf("There are %d Histories for Gantry Angle %d From Scan Number %d\n", num_histories, gantry_angle, scan_number);
			}
			else 
			{
				printf("ERROR: Data format is not Version 1 (Version %d detected)!\n", version_id);
				exit_program_if(true);
			}			
		}
	}
}
/***********************************************************************************************************************************************************************************************************************/
/******************************************************************************************* Image initialization/Construction *****************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
template<typename T> void initialize_host_image( T*& image )
{
	image = (T*)calloc( NUM_VOXELS, sizeof(T));
}
template<typename T> void add_ellipse( T*& image, int slice, double x_center, double y_center, double semi_major_axis, double semi_minor_axis, T value )
{
	double x, y;
	for( int row = 0; row < ROWS; row++ )
	{
		for( int column = 0; column < COLUMNS; column++ )
		{
			x = ( column - COLUMNS/2 + 0.5) * VOXEL_WIDTH;
			y = ( ROWS/2 - row - 0.5 ) * VOXEL_HEIGHT;
			if( pow( ( x - x_center) / semi_major_axis, 2 ) + pow( ( y - y_center )  / semi_minor_axis, 2 ) <= 1 )
				image[slice * COLUMNS * ROWS + row * COLUMNS + column] = value;
		}
	}
}
template<typename T> void add_circle( T*& image, int slice, double x_center, double y_center, double radius, T value )
{
	double x, y;
	for( int row = 0; row < ROWS; row++ )
	{
		for( int column = 0; column < COLUMNS; column++ )
		{
			x = ( column - COLUMNS/2 + 0.5) * VOXEL_WIDTH;
			//x_center = ( center_column - COLUMNS/2 + 0.5) * VOXEL_WIDTH;
			y = ( ROWS/2 - row - 0.5 ) * VOXEL_HEIGHT;
			//y_center = ( center_row - COLUMNS/2 + 0.5) * VOXEL_WIDTH;
			if( pow( (x - x_center), 2 ) + pow( (y - y_center), 2 ) <= pow( radius, 2) )
				image[slice * COLUMNS * ROWS + row * COLUMNS + column] = value;
		}
	}
}	
template<typename O> void import_image( O*& import_into, char* filename )
{
	FILE* input_file = fopen(filename, "rb" );
	O* temp = (O*)calloc(NUM_VOXELS, sizeof(O) );
	fread(temp, sizeof(O), NUM_VOXELS, input_file );
	free(import_into);
	import_into = temp;
}
/***********************************************************************************************************************************************************************************************************************/
/************************************************************************************** Data importation, initial cuts, and binning ************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void combine_data_sets()
{
	char input_filename1[256];
	char input_filename2[256];
	char output_filename[256];
	const char INPUT_FROM1[]	   = "input_CTP404";
	const char INPUT_FROM2[]	   = "CTP404_4M";
	const char MERGED_FOLDER[]	   = "my_merged";
	//unsigned int gantry_position, gantry_angle, scan_number, file_histories, array_index = 0, histories_read = 0; //Warning: Not used in function

	char magic_number1[4], magic_number2[4];
	int version_id1, version_id2;
	int file_histories1, file_histories2, combined_histories;

	float projection_angle1, beam_energy1;
	int generation_date1, preprocess_date1;
	int phantom_name_size1, data_source_size1, prepared_by_size1;
	char *phantom_name1, *data_source1, *prepared_by1;
	
	float projection_angle2, beam_energy2;
	int generation_date2, preprocess_date2;
	int phantom_name_size2, data_source_size2, prepared_by_size2;
	char *phantom_name2, *data_source2, *prepared_by2;

	float* t_in_1_h1, * t_in_1_h2, *t_in_2_h1, * t_in_2_h2; 
	float* t_out_1_h1, * t_out_1_h2, * t_out_2_h1, * t_out_2_h2;
	float* v_in_1_h1, * v_in_1_h2, * v_in_2_h1, * v_in_2_h2;
	float* v_out_1_h1, * v_out_1_h2, * v_out_2_h1, * v_out_2_h2;
	float* u_in_1_h1, * u_in_1_h2, * u_in_2_h1, * u_in_2_h2;
	float* u_out_1_h1, * u_out_1_h2, * u_out_2_h1, * u_out_2_h2;
	float* WEPL_h1, * WEPL_h2;

	for( unsigned int gantry_angle = 0; gantry_angle < 360; gantry_angle += int(GANTRY_ANGLE_INTERVAL) )
	{	
		cout << gantry_angle << endl;
		sprintf(input_filename1, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM1, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION );
		sprintf(input_filename2, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM2, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION );
		sprintf(output_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, MERGED_FOLDER, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION );

		printf("%s\n", input_filename1 );
		printf("%s\n", input_filename2 );
		printf("%s\n", output_filename );

		FILE* input_file1 = fopen(input_filename1, "rb");
		FILE* input_file2 = fopen(input_filename2, "rb");
		FILE* output_file = fopen(output_filename, "wb");

		if( (input_file1 == NULL) ||  (input_file2 == NULL)  || (output_file == NULL)  )
		{
			fputs( "Error Opening Data File:  Check that the directories are properly named.", stderr ); 
			exit_program_if(true);
		}

		fread(&magic_number1, sizeof(char), 4, input_file1 );
		fread(&magic_number2, sizeof(char), 4, input_file2 );
		fwrite( &magic_number1, sizeof(char), 4, output_file );
		//if( magic_number != MAGIC_NUMBER_CHECK ) 
		//{
		//	puts("Error: unknown file type (should be PCTD)!\n");
		//	exit_program_if(true);
		//}

		fread(&version_id1, sizeof(int), 1, input_file1 );
		fread(&version_id2, sizeof(int), 1, input_file2 );
		fwrite( &version_id1, sizeof(int), 1, output_file );

		fread(&file_histories1, sizeof(int), 1, input_file1 );
		fread(&file_histories2, sizeof(int), 1, input_file2 );
		combined_histories = file_histories1 + file_histories2;
		fwrite( &combined_histories, sizeof(int), 1, output_file );

		puts("Reading headers from files...\n");
	
		fread(&projection_angle1, sizeof(float), 1, input_file1 );
		fread(&projection_angle2, sizeof(float), 1, input_file2 );
		fwrite( &projection_angle1, sizeof(float), 1, output_file );
			
		fread(&beam_energy1, sizeof(float), 1, input_file1 );
		fread(&beam_energy2, sizeof(float), 1, input_file2 );
		fwrite( &beam_energy1, sizeof(float), 1, output_file );

		fread(&generation_date1, sizeof(int), 1, input_file1 );
		fread(&generation_date2, sizeof(int), 1, input_file2 );
		fwrite( &generation_date1, sizeof(int), 1, output_file );

		fread(&preprocess_date1, sizeof(int), 1, input_file1 );
		fread(&preprocess_date2, sizeof(int), 1, input_file2 );
		fwrite( &preprocess_date1, sizeof(int), 1, output_file );

		fread(&phantom_name_size1, sizeof(int), 1, input_file1 );
		fread(&phantom_name_size2, sizeof(int), 1, input_file2 );
		fwrite( &phantom_name_size1, sizeof(int), 1, output_file );

		phantom_name1 = (char*)malloc(phantom_name_size1);
		phantom_name2 = (char*)malloc(phantom_name_size2);

		fread(phantom_name1, phantom_name_size1, 1, input_file1 );
		fread(phantom_name2, phantom_name_size2, 1, input_file2 );
		fwrite( phantom_name1, phantom_name_size1, 1, output_file );

		fread(&data_source_size1, sizeof(int), 1, input_file1 );
		fread(&data_source_size2, sizeof(int), 1, input_file2 );
		fwrite( &data_source_size1, sizeof(int), 1, output_file );

		data_source1 = (char*)malloc(data_source_size1);
		data_source2 = (char*)malloc(data_source_size2);

		fread(data_source1, data_source_size1, 1, input_file1 );
		fread(data_source2, data_source_size2, 1, input_file2 );
		fwrite( &data_source1, data_source_size1, 1, output_file );

		fread(&prepared_by_size1, sizeof(int), 1, input_file1 );
		fread(&prepared_by_size2, sizeof(int), 1, input_file2 );
		fwrite( &prepared_by_size1, sizeof(int), 1, output_file );

		prepared_by1 = (char*)malloc(prepared_by_size1);
		prepared_by2 = (char*)malloc(prepared_by_size2);

		fread(prepared_by1, prepared_by_size1, 1, input_file1 );
		fread(prepared_by2, prepared_by_size2, 1, input_file2 );
		fwrite( &prepared_by1, prepared_by_size1, 1, output_file );

		puts("Reading data from files...\n");

		t_in_1_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		t_in_1_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		t_in_2_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		t_in_2_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		t_out_1_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		t_out_1_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		t_out_2_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		t_out_2_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		v_in_1_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		v_in_1_h2 = (float*)calloc( file_histories2, sizeof(float ) );		
		v_in_2_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		v_in_2_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		v_out_1_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		v_out_1_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		v_out_2_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		v_out_2_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		u_in_1_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		u_in_1_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		u_in_2_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		u_in_2_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		u_out_1_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		u_out_1_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		u_out_2_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		u_out_2_h2 = (float*)calloc( file_histories2, sizeof(float ) );
		WEPL_h1 = (float*)calloc( file_histories1, sizeof(float ) );
		WEPL_h2 = (float*)calloc( file_histories2, sizeof(float ) );

		fread( t_in_1_h1,  sizeof(float), file_histories1, input_file1 );
		fread( t_in_2_h1,  sizeof(float), file_histories1, input_file1 );
		fread( t_out_1_h1,  sizeof(float), file_histories1, input_file1 );
		fread( t_out_2_h1,  sizeof(float), file_histories1, input_file1 );
		fread( v_in_1_h1,  sizeof(float), file_histories1, input_file1 );
		fread( v_in_2_h1,  sizeof(float), file_histories1, input_file1 );
		fread( v_out_1_h1,  sizeof(float), file_histories1, input_file1 );
		fread( v_out_2_h1,  sizeof(float), file_histories1, input_file1 );
		fread( u_in_1_h1,  sizeof(float), file_histories1, input_file1 );
		fread( u_in_2_h1,  sizeof(float), file_histories1, input_file1 );
		fread( u_out_1_h1,  sizeof(float), file_histories1, input_file1 );
		fread( u_out_2_h1,  sizeof(float), file_histories1, input_file1 );
		fread( WEPL_h1,  sizeof(float), file_histories1, input_file1 );

		fread( t_in_1_h2,  sizeof(float), file_histories2, input_file2 );
		fread( t_in_2_h2,  sizeof(float), file_histories2, input_file2 );
		fread( t_out_1_h2,  sizeof(float), file_histories2, input_file2 );
		fread( t_out_2_h2,  sizeof(float), file_histories2, input_file2 );
		fread( v_in_1_h2,  sizeof(float), file_histories2, input_file2 );
		fread( v_in_2_h2,  sizeof(float), file_histories2, input_file2 );
		fread( v_out_1_h2,  sizeof(float), file_histories2, input_file2 );
		fread( v_out_2_h2,  sizeof(float), file_histories2, input_file2 );
		fread( u_in_1_h2,  sizeof(float), file_histories2, input_file2 );
		fread( u_in_2_h2,  sizeof(float), file_histories2, input_file2 );
		fread( u_out_1_h2,  sizeof(float), file_histories2, input_file2 );
		fread( u_out_2_h2,  sizeof(float), file_histories2, input_file2 );
		fread( WEPL_h2,  sizeof(float), file_histories2, input_file2 );

		fwrite( t_in_1_h1, sizeof(float), file_histories1, output_file );
		fwrite( t_in_1_h2, sizeof(float), file_histories2, output_file );		
		fwrite( t_in_2_h1, sizeof(float), file_histories1, output_file );
		fwrite( t_in_2_h2, sizeof(float), file_histories2, output_file );		
		fwrite( t_out_1_h1, sizeof(float), file_histories1, output_file );
		fwrite( t_out_1_h2, sizeof(float), file_histories2, output_file );		
		fwrite( t_out_2_h1, sizeof(float), file_histories1, output_file );
		fwrite( t_out_2_h2, sizeof(float), file_histories2, output_file );	

		fwrite( v_in_1_h1, sizeof(float), file_histories1, output_file );
		fwrite( v_in_1_h2, sizeof(float), file_histories2, output_file );		
		fwrite( v_in_2_h1, sizeof(float), file_histories1, output_file );
		fwrite( v_in_2_h2, sizeof(float), file_histories2, output_file );		
		fwrite( v_out_1_h1, sizeof(float), file_histories1, output_file );
		fwrite( v_out_1_h2, sizeof(float), file_histories2, output_file );		
		fwrite( v_out_2_h1, sizeof(float), file_histories1, output_file );
		fwrite( v_out_2_h2, sizeof(float), file_histories2, output_file );	

		fwrite( u_in_1_h1, sizeof(float), file_histories1, output_file );
		fwrite( u_in_1_h2, sizeof(float), file_histories2, output_file );		
		fwrite( u_in_2_h1, sizeof(float), file_histories1, output_file );
		fwrite( u_in_2_h2, sizeof(float), file_histories2, output_file );	
		fwrite( u_out_1_h1, sizeof(float), file_histories1, output_file );
		fwrite( u_out_1_h2, sizeof(float), file_histories2, output_file );	
		fwrite( u_out_2_h1, sizeof(float), file_histories1, output_file );
		fwrite( u_out_2_h2, sizeof(float), file_histories2, output_file );	

		fwrite( WEPL_h1, sizeof(float), file_histories1, output_file );
		fwrite( WEPL_h2, sizeof(float), file_histories2, output_file );
		
		free( t_in_1_h1 );
		free( t_in_1_h2 );
		free( t_in_2_h1 );
		free( t_in_2_h2 );
		free( t_out_1_h1 );
		free( t_out_1_h2 );
		free( t_out_2_h1 );
		free( t_out_2_h2 );

		free( v_in_1_h1 );
		free( v_in_1_h2 );
		free( v_in_2_h1 );
		free( v_in_2_h2 );
		free( v_out_1_h1 );
		free( v_out_1_h2 );
		free( v_out_2_h1 );
		free( v_out_2_h2 );

		free( u_in_1_h1 );
		free( u_in_1_h2 );
		free( u_in_2_h1 );
		free( u_in_2_h2 );
		free( u_out_1_h1 );
		free( u_out_1_h2 );
		free( u_out_2_h1 );
		free( u_out_2_h2 );

		free( WEPL_h1 );
		free( WEPL_h2 );

		fclose(input_file1);						
		fclose(input_file2);	
		fclose(output_file);	

		puts("Finished");
		pause_execution();
	}

}
void convert_mm_2_cm( unsigned int num_histories )
{
	for( unsigned int i = 0; i < num_histories; i++ ) 
	{
		// Convert the input data from mm to cm
		v_in_1_h[i]	 *= MM_TO_CM;
		v_in_2_h[i]	 *= MM_TO_CM;
		v_out_1_h[i] *= MM_TO_CM;
		v_out_2_h[i] *= MM_TO_CM;
		t_in_1_h[i]	 *= MM_TO_CM;
		t_in_2_h[i]	 *= MM_TO_CM;
		t_out_1_h[i] *= MM_TO_CM;
		t_out_2_h[i] *= MM_TO_CM;
		u_in_1_h[i]	 *= MM_TO_CM;
		u_in_2_h[i]	 *= MM_TO_CM;
		u_out_1_h[i] *= MM_TO_CM;
		u_out_2_h[i] *= MM_TO_CM;
		WEPL_h[i]	 *= MM_TO_CM;
		if( COUNT_0_WEPLS && WEPL_h[i] == 0 )
		{
			zero_WEPL++;
			zero_WEPL_files++;
		}
	}
	if( COUNT_0_WEPLS )
	{
		std::cout << "Histories in " << gantry_angle_h[0] << "with WEPL = 0 :" << zero_WEPL_files << std::endl;
		zero_WEPL_files = 0;
	}
}
void apply_tuv_shifts( unsigned int num_histories)
{
	for( unsigned int i = 0; i < num_histories; i++ ) 
	{
		// Correct for any shifts in u/t coordinates
		t_in_1_h[i]	 += T_SHIFT;
		t_in_2_h[i]	 += T_SHIFT;
		t_out_1_h[i] += T_SHIFT;
		t_out_2_h[i] += T_SHIFT;
		u_in_1_h[i]	 += U_SHIFT;
		u_in_2_h[i]	 += U_SHIFT;
		u_out_1_h[i] += U_SHIFT;
		u_out_2_h[i] += U_SHIFT;
		v_in_1_h[i]	 += V_SHIFT;
		v_in_2_h[i]	 += V_SHIFT;
		v_out_1_h[i] += V_SHIFT;
		v_out_2_h[i] += V_SHIFT;
		if( WRITE_SSD_ANGLES )
		{
			ut_entry_angle[i] = atan2( t_in_2_h[i] - t_in_1_h[i], u_in_2_h[i] - u_in_1_h[i] );	
			uv_entry_angle[i] = atan2( v_in_2_h[i] - v_in_1_h[i], u_in_2_h[i] - u_in_1_h[i] );	
			ut_exit_angle[i] = atan2( t_out_2_h[i] - t_out_1_h[i], u_out_2_h[i] - u_out_1_h[i] );	
			uv_exit_angle[i] = atan2( v_out_2_h[i] - v_out_1_h[i], u_out_2_h[i] - u_out_1_h[i] );	
		}
	}
	if( WRITE_SSD_ANGLES )
	{
		char data_filename[256];
		sprintf(data_filename, "%s_%03d%s", "ut_entry_angle", gantry_angle_h[0], ".txt" );
		array_2_disk( data_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, ut_entry_angle, COLUMNS, ROWS, SLICES, num_histories, true );
		sprintf(data_filename, "%s_%03d%s", "uv_entry_angle", gantry_angle_h[0], ".txt" );
		char ut_entry_angle[] = {"ut_entry_angle"};
		array_2_disk( ut_entry_angle, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, uv_entry_angle, COLUMNS, ROWS, SLICES, num_histories, true );
		sprintf(data_filename, "%s_%03d%s", "ut_exit_angle", gantry_angle_h[0], ".txt" );
		array_2_disk( ut_entry_angle, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, ut_exit_angle, COLUMNS, ROWS, SLICES, num_histories, true );
		sprintf(data_filename, "%s_%03d%s", "uv_exit_angle", gantry_angle_h[0], ".txt" );
		array_2_disk( ut_entry_angle, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, uv_exit_angle, COLUMNS, ROWS, SLICES, num_histories, true );
	}
}
void read_data_chunk( const int num_histories, const int start_file_num, const int end_file_num )
{
	// The GPU cannot process all the histories at once, so they are broken up into chunks that can fit on the GPU.  As we iterate 
	// through the data one chunk at a time, we determine which histories enter the reconstruction volume and if they belong to a 
	// valid bin (i.e. t, v, and angular bin number is greater than zero and less than max).  If both are true, we push the bin
	// number, WEPL, and relative entry/exit ut/uv angles to the back of their corresponding std::vector.
	
	unsigned int size_floats = sizeof(float) * num_histories;
	unsigned int size_ints = sizeof(int) * num_histories;

	t_in_1_h		= (float*) malloc(size_floats);
	t_in_2_h		= (float*) malloc(size_floats);
	t_out_1_h		= (float*) malloc(size_floats);
	t_out_2_h		= (float*) malloc(size_floats);
	u_in_1_h		= (float*) malloc(size_floats);
	u_in_2_h		= (float*) malloc(size_floats);
	u_out_1_h		= (float*) malloc(size_floats);
	u_out_2_h		= (float*) malloc(size_floats);
	v_in_1_h		= (float*) malloc(size_floats);
	v_in_2_h		= (float*) malloc(size_floats);
	v_out_1_h		= (float*) malloc(size_floats);
	v_out_2_h		= (float*) malloc(size_floats);		
	WEPL_h			= (float*) malloc(size_floats);
	gantry_angle_h	= (int*)   malloc(size_ints);

	if( WRITE_SSD_ANGLES )
	{
		ut_entry_angle	= (float*) malloc(size_floats);
		uv_entry_angle	= (float*) malloc(size_floats);
		ut_exit_angle	= (float*) malloc(size_floats);
		uv_exit_angle	= (float*) malloc(size_floats);
	}
	switch( DATA_FORMAT )
	{
		case OLD_FORMAT : read_data_chunk_old( num_histories, start_file_num, end_file_num - 1 );	break;
		case VERSION_0  : read_data_chunk_v0(  num_histories, start_file_num, end_file_num - 1 );	break;
		case VERSION_1  : read_data_chunk_v1(  num_histories, start_file_num, end_file_num - 1 );
	}
}
void read_data_chunk_old( const int num_histories, const int start_file_num, const int end_file_num )
{
	int array_index = 0, gantry_position, gantry_angle, scan_number, scan_histories;
	float v_data[4], t_data[4], WEPL_data, gantry_angle_data, dummy_data;
	char tracker_plane[4];
	char data_filename[128];
	FILE* data_file;

	for( int file_num = start_file_num; file_num <= end_file_num; file_num++ )
	{
		gantry_position = file_num / NUM_SCANS;
		gantry_angle = int(gantry_position * GANTRY_ANGLE_INTERVAL);
		scan_number = file_num % NUM_SCANS + 1;
		scan_histories = histories_per_file[file_num];

		printf("Reading File for Gantry Angle %d from Scan Number %d...\n", gantry_angle, scan_number );
		sprintf( data_filename, "%s%s/%s_trans%d_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, scan_number, gantry_angle, INPUT_DATA_EXTENSION );
		data_file = fopen( data_filename, "rb" );	

		for( int history = 0; history < scan_histories; history++, array_index++ ) 
		{
			fread(&v_data,				sizeof(float),	4, data_file);
			fread(&t_data,				sizeof(float),	4, data_file);
			fread(&tracker_plane,		sizeof(char),	4, data_file);
			fread(&WEPL_data,			sizeof(float),	1, data_file);
			fread(&gantry_angle_data,	sizeof(float),	1, data_file);
			fread(&dummy_data,			sizeof(float),	1, data_file); // dummy read because each event has an extra 4 bytes, for some reason
			if( DATA_IN_MM )
			{
				// Convert the input data from mm to cm
				v_in_1_h[array_index]	= v_data[0] * MM_TO_CM;;
				v_in_2_h[array_index]	= v_data[1] * MM_TO_CM;;
				v_out_1_h[array_index]	= v_data[2] * MM_TO_CM;;
				v_out_2_h[array_index]	= v_data[3] * MM_TO_CM;;
				t_in_1_h[array_index]	= t_data[0] * MM_TO_CM;;
				t_in_2_h[array_index]	= t_data[1] * MM_TO_CM;;
				t_out_1_h[array_index]	= t_data[2] * MM_TO_CM;;
				t_out_2_h[array_index]	= t_data[3] * MM_TO_CM;;
				WEPL_h[array_index]		= WEPL_data * MM_TO_CM;;
			}
			else
			{
				v_in_1_h[array_index]	= v_data[0];
				v_in_2_h[array_index]	= v_data[1];
				v_out_1_h[array_index]	= v_data[2];
				v_out_2_h[array_index]	= v_data[3];
				t_in_1_h[array_index]	= t_data[0];
				t_in_2_h[array_index]	= t_data[1];
				t_out_1_h[array_index]	= t_data[2];
				t_out_2_h[array_index]	= t_data[3];
				WEPL_h[array_index]		= WEPL_data;
			}
			if( !MICAH_SIM )
			{
				u_in_1_h[array_index]	= SSD_u_Positions[int(tracker_plane[0])];
				u_in_2_h[array_index]	= SSD_u_Positions[int(tracker_plane[1])];
				u_out_1_h[array_index]	= SSD_u_Positions[int(tracker_plane[2])];
				u_out_2_h[array_index]	= SSD_u_Positions[int(tracker_plane[3])];
			}
			else
			{
				u_in_1_h[array_index]	= SSD_u_Positions[0];
				u_in_2_h[array_index]	= SSD_u_Positions[2];
				u_out_1_h[array_index]	= SSD_u_Positions[4];
				u_out_2_h[array_index]	= SSD_u_Positions[6];
			}
			if( SSD_IN_MM )
			{
				// Convert the tracking plane positions from mm to cm
				u_in_1_h[array_index]	*= MM_TO_CM;;
				u_in_2_h[array_index]	*= MM_TO_CM;;
				u_out_1_h[array_index]	*= MM_TO_CM;;
				u_out_2_h[array_index]	*= MM_TO_CM;;
			}
			gantry_angle_h[array_index] = int(gantry_angle_data);
		}
		fclose(data_file);		
	}
}
void read_data_chunk_v0( const int num_histories, const int start_file_num, const int end_file_num )
{	
	/*
	Event data:
	Data is be stored with all of one type in a consecutive row, meaning the first entries will be N t0 values, where N is the number of events in the file. Next will be N t1 values, etc. This more closely matches the data structure in memory.
	Detector coordinates in mm relative to a phantom center, given in the detector coordinate system:
		t0 (float * N)
		t1 (float * N)
		t2 (float * N)
		t3 (float * N)
		v0 (float * N)
		v1 (float * N)
		v2 (float * N)
		v3 (float * N)
		u0 (float * N)
		u1 (float * N)
		u2 (float * N)
		u3 (float * N)
		WEPL in mm (float * N)
	*/
	char data_filename[128];
	//char statement[256];
	unsigned int gantry_position, gantry_angle, scan_number, file_histories, array_index = 0, histories_read = 0;

	sprintf(print_statement, "%d histories to be read from %d files", num_histories, end_file_num - start_file_num + 1 );
	print_colored_text( print_statement, LIGHT, CYAN );	
		
	for( unsigned int file_num = start_file_num; file_num <= end_file_num; file_num++ )
	{	
		gantry_position = file_num / NUM_SCANS;
		gantry_angle = int(gantry_position * GANTRY_ANGLE_INTERVAL);
		scan_number = file_num % NUM_SCANS + 1;
		file_histories = histories_per_file[file_num];
		
		sprintf(data_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION );
		FILE* data_file = fopen(data_filename, "rb");
		if( data_file == NULL )
		{
			fputs( "Error Opening Data File:  Check that the directories are properly named.\n", stderr ); 
			exit_program_if(true);
		}
		if( VERSION_ID == 0 )
		{
			//printf("\t");
			sprintf(print_statement, "\tReading %d histories for gantry angle %d from scan number %d...", file_histories, gantry_angle, scan_number );			
			print_colored_text( print_statement, LIGHT, CYAN );	
			fseek( data_file, SKIP_2_DATA_SIZE, SEEK_SET );

			fread( &t_in_1_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &t_in_2_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &t_out_1_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &t_out_2_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &v_in_1_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &v_in_2_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &v_out_1_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &v_out_2_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &u_in_1_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &u_in_2_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &u_out_1_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &u_out_2_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &WEPL_h[histories_read],    sizeof(float), file_histories, data_file );
			fclose(data_file);

			histories_read += file_histories;
			for( unsigned int i = 0; i < file_histories; i++, array_index++ ) 
				gantry_angle_h[array_index] = int(projection_angles[file_num]);							
		}
		else if( VERSION_ID == 1 )
		{
			sprintf(print_statement, "\tReading %d histories for gantry angle %d from scan number %d...", file_histories, gantry_angle, scan_number );			
			print_colored_text( print_statement, LIGHT, CYAN );	
			fseek( data_file, SKIP_2_DATA_SIZE, SEEK_SET );

			fread( &t_in_1_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &t_in_2_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &t_out_1_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &t_out_2_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &v_in_1_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &v_in_2_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &v_out_1_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &v_out_2_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &u_in_1_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &u_in_2_h[histories_read],  sizeof(float), file_histories, data_file );
			fread( &u_out_1_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &u_out_2_h[histories_read], sizeof(float), file_histories, data_file );
			fread( &WEPL_h[histories_read],    sizeof(float), file_histories, data_file );
			fclose(data_file);

			histories_read += file_histories;
			for( unsigned int i = 0; i < file_histories; i++, array_index++ ) 
				gantry_angle_h[array_index] = int(projection_angles[file_num]);							
		}
	}
	if( COUNT_0_WEPLS )
	{
		std::cout << "Histories in " << gantry_angle_h[0] << "with WEPL = 0 :" << zero_WEPL_files << std::endl;
		zero_WEPL_files = 0;
	}
	if( DATA_IN_MM )
		convert_mm_2_cm( num_histories );
	if( T_SHIFT != 0.0	||  U_SHIFT != 0.0 ||  V_SHIFT != 0.0)
		apply_tuv_shifts( num_histories );
}
void read_data_chunk_v02( const int num_histories, const int start_file_num, const int end_file_num )
{
	/*
	Contains the following headers:
		Magic number identifier: "PCTD" (4-byte string)
		Format version identifier (integer)
		Number of events in file (integer)
		Projection angle (float | degrees)
		Beam energy (float | MeV)
		Acquisition/generation date (integer | Unix time)
		Pre-process date (integer | Unix time)
		Phantom name or description (variable length string)
		Data source (variable length string)
		Prepared by (variable length string)
	* Note on variable length strings: each variable length string should be preceded with an integer containing the number of characters in the string.
	
	Event data:
	Data is be stored with all of one type in a consecutive row, meaning the first entries will be N t0 values, where N is the number of events in the file. Next will be N t1 values, etc. This more closely matches the data structure in memory.
	Detector coordinates in mm relative to a phantom center, given in the detector coordinate system:
		t0 (float * N)
		t1 (float * N)
		t2 (float * N)
		t3 (float * N)
		v0 (float * N)
		v1 (float * N)
		v2 (float * N)
		v3 (float * N)
		u0 (float * N)
		u1 (float * N)
		u2 (float * N)
		u3 (float * N)
		WEPL in mm (float * N)
	*/
	//char user_response[20];
	char data_filename[128];
	int array_index = 0, histories_read = 0;
	for( int file_num = start_file_num; file_num <= end_file_num; file_num++ )
	{
		int gantry_position = file_num / NUM_SCANS;
		int gantry_angle = int(gantry_position * GANTRY_ANGLE_INTERVAL);
		int scan_number = file_num % NUM_SCANS + 1;
		//int scan_histories = histories_per_file[file_num];

		printf("Reading File for Gantry Angle %d from Scan Number %d...\n", gantry_angle, scan_number );
		sprintf(data_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION );	
		std::ifstream data_file(data_filename, std::ios::binary);
		if( data_file == NULL )
		{
			fputs( "File not found:  Check that the directories and files are properly named.", stderr ); 
			exit_program_if(true);
		}
		char magic_number[5];
		data_file.read(magic_number, 4);
		magic_number[4] = '\0';
		if( strcmp(magic_number, "PCTD") ) {
			puts("Error: unknown file type (should be PCTD)!\n");
			exit_program_if(true);
		}
		int version_id;
		data_file.read((char*)&version_id, sizeof(int));
		if( version_id == 0 )
		{
			int file_histories;
			data_file.read((char*)&file_histories, sizeof(int));
	
			puts("Reading headers from file...\n");
	
			float projection_angle, beam_energy;
			int generation_date, preprocess_date;
			int phantom_name_size, data_source_size, prepared_by_size;
			char *phantom_name, *data_source, *prepared_by;
	
			data_file.read((char*)&projection_angle, sizeof(float));
			data_file.read((char*)&beam_energy, sizeof(float));
			data_file.read((char*)&generation_date, sizeof(int));
			data_file.read((char*)&preprocess_date, sizeof(int));
			data_file.read((char*)&phantom_name_size, sizeof(int));
			phantom_name = (char*)malloc(phantom_name_size);
			data_file.read(phantom_name, phantom_name_size);
			data_file.read((char*)&data_source_size, sizeof(int));
			data_source = (char*)malloc(data_source_size);
			data_file.read(data_source, data_source_size);
			data_file.read((char*)&prepared_by_size, sizeof(int));
			prepared_by = (char*)malloc(prepared_by_size);
			data_file.read(prepared_by, prepared_by_size);
	
			printf("Loading %d histories from file\n", file_histories);
	
			int data_size = file_histories * sizeof(float);
	
			data_file.read((char*)&t_in_1_h[histories_read], data_size);
			data_file.read((char*)&t_in_2_h[histories_read], data_size);
			data_file.read((char*)&t_out_1_h[histories_read], data_size);
			data_file.read((char*)&t_out_2_h[histories_read], data_size);
			data_file.read((char*)&v_in_1_h[histories_read], data_size);
			data_file.read((char*)&v_in_2_h[histories_read], data_size);
			data_file.read((char*)&v_out_1_h[histories_read], data_size);
			data_file.read((char*)&v_out_2_h[histories_read], data_size);
			data_file.read((char*)&u_in_1_h[histories_read], data_size);
			data_file.read((char*)&u_in_2_h[histories_read], data_size);
			data_file.read((char*)&u_out_1_h[histories_read], data_size);
			data_file.read((char*)&u_out_2_h[histories_read], data_size);
			data_file.read((char*)&WEPL_h[histories_read], data_size);
	
			//double max_v = 0;
			//double min_v = 0;
			//double max_WEPL = 0;
			//double min_WEPL = 0;
			//float v_data[4], t_data[4], WEPL_data, gantry_angle_data, dummy_data;
			for( unsigned int i = 0; i < file_histories; i++, array_index++ ) 
			{
				if( DATA_IN_MM )
				{
					// Convert the input data from mm to cm
					v_in_1_h[array_index]		*= MM_TO_CM;
					v_in_2_h[array_index]		*= MM_TO_CM;
					v_out_1_h[array_index]	*= MM_TO_CM;
					v_out_2_h[array_index]	*= MM_TO_CM;
					t_in_1_h[array_index]		*= MM_TO_CM;
					t_in_2_h[array_index]		*= MM_TO_CM; 
					t_out_1_h[array_index]	*= MM_TO_CM; 
					t_out_2_h[array_index]	*= MM_TO_CM;
					WEPL_h[array_index]		*= MM_TO_CM;
					//if( WEPL_h[array_index] < 0 )
						//printf("WEPL[%d] = %3f\n", i, WEPL_h[array_index] );
					u_in_1_h[array_index]		*= MM_TO_CM;
					u_in_2_h[array_index]		*= MM_TO_CM;
					u_out_1_h[array_index]	*= MM_TO_CM;
					u_out_2_h[array_index]	*= MM_TO_CM;
					/*if( (v_in_1_h[array_index]) > max_v )
						max_v = v_in_1_h[array_index];
					if( (v_in_2_h[array_index]) > max_v )
						max_v = v_in_2_h[array_index];
					if( (v_out_1_h[array_index]) > max_v )
						max_v = v_out_1_h[array_index];
					if( (v_out_2_h[array_index]) > max_v )
						max_v = v_out_2_h[array_index];
					
					if( (v_in_1_h[array_index]) < min_v )
						min_v = v_in_1_h[array_index];
					if( (v_in_2_h[array_index]) < min_v )
						min_v = v_in_2_h[array_index];
					if( (v_out_1_h[array_index]) < min_v )
						min_v = v_out_1_h[array_index];
					if( (v_out_2_h[array_index]) < min_v )
						min_v = v_out_2_h[array_index];

					if( (WEPL_h[array_index]) > max_WEPL )
						max_WEPL = WEPL_h[array_index];
					if( (WEPL_h[array_index]) < min_WEPL )
						min_WEPL = WEPL_h[array_index];*/
				}
				gantry_angle_h[array_index] = static_cast<int>(projection_angle);
				//gantry_angle_h[array_index] = (int(projection_angle) + 270)%360;

			}
			//printf("max_v = %3f\n", max_v );
			//printf("min_v = %3f\n", min_v );
			//printf("max_WEPL = %3f\n", max_WEPL );
			//printf("min_WEPL = %3f\n", min_WEPL );
			data_file.close();
			histories_read += file_histories;
		}
	}
	//printf("gantry_angle_h[0] = %d\n", gantry_angle_h[0] );
	//printf("t_in_1_h[0] = %3f\n", t_in_1_h[0] );
}
void read_data_chunk_v1( const int num_histories, const int start_file_num, const int end_file_num )
{
	/*
	Contains the following headers:
		Magic number identifier: "PCTD" (4-byte string)
		Format version identifier (integer)
		Number of events in file (integer)
		Projection angle (float | degrees)
		Beam energy (float | MeV)
		Acquisition/generation date (integer | Unix time)
		Pre-process date (integer | Unix time)
		Phantom name or description (variable length string)
		Data source (variable length string)
		Prepared by (variable length string)
	* Note on variable length strings: each variable length string should be preceded with an integer containing the number of characters in the string.
	
	Event data:
	Data is be stored with all of one type in a consecutive row, meaning the first entries will be N t0 values, where N is the number of events in the file. Next will be N t1 values, etc. This more closely matches the data structure in memory.
	Detector coordinates in mm relative to a phantom center, given in the detector coordinate system:
		t0 (float * N)
		t1 (float * N)
		t2 (float * N)
		t3 (float * N)
		v0 (float * N)
		v1 (float * N)
		v2 (float * N)
		v3 (float * N)
		u0 (float * N)
		u1 (float * N)
		u2 (float * N)
		u3 (float * N)
		WEPL in mm (float * N)
	*/
	//char user_response[20];
	char data_filename[128];
	//int array_index = 0;
	for( int file_num = start_file_num; file_num <= end_file_num; file_num++ )
	{
		int gantry_position = file_num / NUM_SCANS;
		int gantry_angle = int(gantry_position * GANTRY_ANGLE_INTERVAL);
		int scan_number = file_num % NUM_SCANS + 1;
		//int scan_histories = histories_per_file[file_num];

		printf("Reading File for Gantry Angle %d from Scan Number %d...\n", gantry_angle, scan_number );
		sprintf(data_filename, "%s%s/%s_%03d%s", INPUT_DIRECTORY, INPUT_FROM, INPUT_DATA_BASENAME, gantry_angle, INPUT_DATA_EXTENSION );	
		std::ifstream data_file(data_filename, std::ios::binary);
		if( data_file == NULL )
		{
			fputs( "File not found:  Check that the directories and files are properly named.", stderr ); 
			exit_program_if(true);
		}
		char magic_number[5];
		data_file.read(magic_number, 4);
		magic_number[4] = '\0';
		if( strcmp(magic_number, "PCTD") ) {
			puts("Error: unknown file type (should be PCTD)!\n");
			exit_program_if(true);
		}
		int version_id;
		data_file.read((char*)&version_id, sizeof(int));
		if( version_id == 1 )
		{
			int num_histories;
			data_file.read((char*)&num_histories, sizeof(int));
	
			puts("Reading headers from file...\n");
	
			float projection_angle, beam_energy;
			int generation_date, preprocess_date;
			int phantom_name_size, data_source_size, prepared_by_size;
			char *phantom_name, *data_source, *prepared_by;
	
			data_file.read((char*)&projection_angle, sizeof(float));
			data_file.read((char*)&beam_energy, sizeof(float));
			data_file.read((char*)&generation_date, sizeof(int));
			data_file.read((char*)&preprocess_date, sizeof(int));
			data_file.read((char*)&phantom_name_size, sizeof(int));
			phantom_name = (char*)malloc(phantom_name_size);
			data_file.read(phantom_name, phantom_name_size);
			data_file.read((char*)&data_source_size, sizeof(int));
			data_source = (char*)malloc(data_source_size);
			data_file.read(data_source, data_source_size);
			data_file.read((char*)&prepared_by_size, sizeof(int));
			prepared_by = (char*)malloc(prepared_by_size);
			data_file.read(prepared_by, prepared_by_size);
	
			printf("Loading %d histories from file\n", num_histories);
	
			int data_size = num_histories * sizeof(float);
	
			data_file.read((char*)t_in_1_h, data_size);
			data_file.read((char*)t_in_2_h, data_size);
			data_file.read((char*)t_out_1_h, data_size);
			data_file.read((char*)t_out_2_h, data_size);
			data_file.read((char*)v_in_1_h, data_size);
			data_file.read((char*)v_in_2_h, data_size);
			data_file.read((char*)v_out_1_h, data_size);
			data_file.read((char*)v_out_2_h, data_size);
			data_file.read((char*)u_in_1_h, data_size);
			data_file.read((char*)u_in_2_h, data_size);
			data_file.read((char*)u_out_1_h, data_size);
			data_file.read((char*)u_out_2_h, data_size);
			data_file.read((char*)WEPL_h, data_size);
	
			//float v_data[4], t_data[4], WEPL_data, gantry_angle_data, dummy_data;
			for( unsigned int i = 0; i < num_histories; i++ ) 
			{
				if( DATA_IN_MM )
				{
					// Convert the input data from mm to cm
					v_in_1_h[i]		*= MM_TO_CM;
					v_in_2_h[i]		*= MM_TO_CM;
					v_out_1_h[i]	*= MM_TO_CM;
					v_out_2_h[i]	*= MM_TO_CM;
					t_in_1_h[i]		*= MM_TO_CM;
					t_in_2_h[i]		*= MM_TO_CM; 
					t_out_1_h[i]	*= MM_TO_CM; 
					t_out_2_h[i]	*= MM_TO_CM;
					WEPL_h[i]		*= MM_TO_CM;
					if( WEPL_h[i] < 0 )
						printf("WEPL[%d] = %3f\n", i, WEPL_h[i] );
					u_in_1_h[i]		*= MM_TO_CM;
					u_in_2_h[i]		*= MM_TO_CM;
					u_out_1_h[i]	*= MM_TO_CM;
					u_out_2_h[i]	*= MM_TO_CM;
				}
				gantry_angle_h[i] = int(projection_angle);
			}
			data_file.close();
		}
	}
}
void recon_volume_intersections( const int num_histories )
{
	//printf("There are %d histories in this projection\n", num_histories );
	unsigned int size_floats = sizeof(float) * num_histories;
	unsigned int size_ints = sizeof(int) * num_histories;
	unsigned int size_bool = sizeof(bool) * num_histories;

	// Allocate GPU memory
	cudaMalloc((void**) &t_in_1_d,				size_floats);
	cudaMalloc((void**) &t_in_2_d,				size_floats);
	cudaMalloc((void**) &t_out_1_d,				size_floats);
	cudaMalloc((void**) &t_out_2_d,				size_floats);
	cudaMalloc((void**) &u_in_1_d,				size_floats);
	cudaMalloc((void**) &u_in_2_d,				size_floats);
	cudaMalloc((void**) &u_out_1_d,				size_floats);
	cudaMalloc((void**) &u_out_2_d,				size_floats);
	cudaMalloc((void**) &v_in_1_d,				size_floats);
	cudaMalloc((void**) &v_in_2_d,				size_floats);
	cudaMalloc((void**) &v_out_1_d,				size_floats);
	cudaMalloc((void**) &v_out_2_d,				size_floats);		
	cudaMalloc((void**) &gantry_angle_d,		size_ints);

	cudaMalloc((void**) &x_entry_d,				size_floats);
	cudaMalloc((void**) &y_entry_d,				size_floats);
	cudaMalloc((void**) &z_entry_d,				size_floats);
	cudaMalloc((void**) &x_exit_d,				size_floats);
	cudaMalloc((void**) &y_exit_d,				size_floats);
	cudaMalloc((void**) &z_exit_d,				size_floats);
	cudaMalloc((void**) &xy_entry_angle_d,		size_floats);	
	cudaMalloc((void**) &xz_entry_angle_d,		size_floats);
	cudaMalloc((void**) &xy_exit_angle_d,		size_floats);
	cudaMalloc((void**) &xz_exit_angle_d,		size_floats);
	cudaMalloc((void**) &missed_recon_volume_d,	size_bool);	

	cudaMemcpy(t_in_1_d,		t_in_1_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(t_in_2_d,		t_in_2_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(t_out_1_d,		t_out_1_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(t_out_2_d,		t_out_2_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(u_in_1_d,		u_in_1_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(u_in_2_d,		u_in_2_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(u_out_1_d,		u_out_1_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(u_out_2_d,		u_out_2_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(v_in_1_d,		v_in_1_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(v_in_2_d,		v_in_2_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(v_out_1_d,		v_out_1_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(v_out_2_d,		v_out_2_h,		size_floats, cudaMemcpyHostToDevice) ;
	cudaMemcpy(gantry_angle_d,	gantry_angle_h,	size_ints,   cudaMemcpyHostToDevice) ;

	dim3 dimBlock(THREADS_PER_BLOCK);
	dim3 dimGrid((int)(num_histories/THREADS_PER_BLOCK)+1);
	recon_volume_intersections_GPU<<<dimGrid, dimBlock>>>
	(
		num_histories, gantry_angle_d, missed_recon_volume_d,
		t_in_1_d, t_in_2_d, t_out_1_d, t_out_2_d,
		u_in_1_d, u_in_2_d, u_out_1_d, u_out_2_d,
		v_in_1_d, v_in_2_d, v_out_1_d, v_out_2_d, 	
		x_entry_d, y_entry_d, z_entry_d, x_exit_d, y_exit_d, z_exit_d, 		
		xy_entry_angle_d, xz_entry_angle_d, xy_exit_angle_d, xz_exit_angle_d
	);

	free(t_in_1_h);
	free(t_in_2_h);
	free(t_out_1_h);
	free(t_out_2_h);
	free(v_in_1_h);
	free(v_in_2_h);
	free(v_out_1_h);
	free(v_out_2_h);
	free(u_in_1_h);
	free(u_in_2_h);
	free(u_out_1_h);
	free(u_out_2_h);
	// Host memory not freed


	cudaFree(t_in_1_d);
	cudaFree(t_in_2_d);
	cudaFree(t_out_1_d);
	cudaFree(t_out_2_d);
	cudaFree(v_in_1_d);
	cudaFree(v_in_2_d);
	cudaFree(v_out_1_d);
	cudaFree(v_out_2_d);
	cudaFree(u_in_1_d);
	cudaFree(u_in_2_d);
	cudaFree(u_out_1_d);
	cudaFree(u_out_2_d);	
	cudaFree(gantry_angle_d);
	/* 
		Device memory allocated but not freed here
		x_entry_d;
		y_entry_d;
		z_entry_d;
		x_exit_d;
		y_exit_d;
		z_exit_d;
		xy_entry_angle_d;
		xz_entry_angle_d;
		xy_exit_angle_d;
		xz_exit_angle_d;
		missed_recon_volume_d;
	*/
}
__global__ void recon_volume_intersections_GPU
(
	int num_histories, int* gantry_angle, bool* missed_recon_volume, float* t_in_1, float* t_in_2, float* t_out_1, float* t_out_2, float* u_in_1, float* u_in_2, 
	float* u_out_1, float* u_out_2, float* v_in_1, float* v_in_2, float* v_out_1, float* v_out_2, float* x_entry, float* y_entry, float* z_entry, float* x_exit, 
	float* y_exit, float* z_exit, float* xy_entry_angle, float* xz_entry_angle, float* xy_exit_angle, float* xz_exit_angle
)
{
	/************************************************************************************************************************************************************/
	/*		Determine if the proton path passes through the reconstruction volume (i.e. intersects the reconstruction cylinder twice) and if it does, determine	*/ 
	/*	the x, y, and z positions in the global/object coordinate system where the proton enters and exits the reconstruction volume.  The origin of the object */
	/*	coordinate system is defined to be at the center of the reconstruction cylinder so that its volume is bounded by:										*/
	/*																																							*/
	/*													-RECON_CYL_RADIUS	<= x <= RECON_CYL_RADIUS															*/
	/*													-RECON_CYL_RADIUS	<= y <= RECON_CYL_RADIUS															*/
	/*													-RECON_CYL_HEIGHT/2 <= z <= RECON_CYL_HEIGHT/2															*/																									
	/*																																							*/
	/*		First, the coordinates of the points where the proton path intersected the entry/exit detectors must be calculated.  Since the detectors records	*/ 
	/*	data in the detector coordinate system, data in the utv coordinate system must be converted into the global/object coordinate system.  The coordinate	*/
	/*	transformation can be accomplished using a rotation matrix with an angle of rotation determined by the angle between the two coordinate systems, which  */ 
	/*	is the gantry_angle, in this case:																														*/
	/*																																							*/
	/*	Rotate ut-coordinate system to xy-coordinate system							Rotate xy-coordinate system to ut-coordinate system							*/
	/*		x = cos( gantry_angle ) * u - sin( gantry_angle ) * t						u = cos( gantry_angle ) * x + sin( gantry_angle ) * y					*/
	/*		y = sin( gantry_angle ) * u + cos( gantry_angle ) * t						t = cos( gantry_angle ) * y - sin( gantry_angle ) * x					*/
	/************************************************************************************************************************************************************/
			
	int i = threadIdx.x + blockIdx.x * THREADS_PER_BLOCK;
	if( i < num_histories )
	{
		double rotation_angle_radians = gantry_angle[i] * ANGLE_TO_RADIANS;
		/********************************************************************************************************************************************************/
		/************************************************************ Check entry information *******************************************************************/
		/********************************************************************************************************************************************************/

		/********************************************************************************************************************************************************/
		/* Determine if the proton path enters the reconstruction volume.  The proton path is defined using the angle and position of the proton as it passed	*/
		/* through the SSD closest to the object.  Since the reconstruction cylinder is symmetric about the rotation axis, we find a proton's intersection 		*/
		/* points in the ut plane and then rotate these points into the xy plane.  Since a proton very likely has a small angle in ut plane, this allows us to 	*/
		/* overcome numerical instabilities that occur at near vertical angles which would occur for gantry angles near 90/270 degrees.  However, if a path is 	*/
		/* between [45,135] or [225,315], calculations are performed in a rotated coordinate system to avoid these numerical issues								*/
		/********************************************************************************************************************************************************/
		double ut_entry_angle = atan2( t_in_2[i] - t_in_1[i], u_in_2[i] - u_in_1[i] );
		//ut_entry_angle += PI;
		double u_entry, t_entry;
		
		// Calculate if and where proton enters reconstruction volume; u_entry/t_entry passed by reference so they hold the entry point upon function returns
		bool entered = calculate_intercepts( u_in_2[i], t_in_2[i], ut_entry_angle, u_entry, t_entry );
		
		xy_entry_angle[i] = ut_entry_angle + rotation_angle_radians;

		// Rotate exit detector positions
		x_entry[i] = ( cos( rotation_angle_radians ) * u_entry ) - ( sin( rotation_angle_radians ) * t_entry );
		y_entry[i] = ( sin( rotation_angle_radians ) * u_entry ) + ( cos( rotation_angle_radians ) * t_entry );
		/********************************************************************************************************************************************************/
		/************************************************************* Check exit information *******************************************************************/
		/********************************************************************************************************************************************************/
		double ut_exit_angle = atan2( t_out_2[i] - t_out_1[i], u_out_2[i] - u_out_1[i] );
		double u_exit, t_exit;
		
		// Calculate if and where proton exits reconstruction volume; u_exit/t_exit passed by reference so they hold the exit point upon function returns
		bool exited = calculate_intercepts( u_out_1[i], t_out_1[i], ut_exit_angle, u_exit, t_exit );

		xy_exit_angle[i] = ut_exit_angle + rotation_angle_radians;

		// Rotate exit detector positions
		x_exit[i] = ( cos( rotation_angle_radians ) * u_exit ) - ( sin( rotation_angle_radians ) * t_exit );
		y_exit[i] = ( sin( rotation_angle_radians ) * u_exit ) + ( cos( rotation_angle_radians ) * t_exit );
		/********************************************************************************************************************************************************/
		/************************************************************* Check z(v) information *******************************************************************/
		/********************************************************************************************************************************************************/
		
		// Relevant angles/slopes in radians for entry and exit in the uv plane
		double uv_entry_slope = ( v_in_2[i] - v_in_1[i] ) / ( u_in_2[i] - u_in_1[i] );
		double uv_exit_slope = ( v_out_2[i] - v_out_1[i] ) / ( u_out_2[i] - u_out_1[i] );
		
		xz_entry_angle[i] = atan2( v_in_2[i] - v_in_1[i], u_in_2[i] - u_in_1[i] );
		xz_exit_angle[i] = atan2( v_out_2[i] - v_out_1[i],  u_out_2[i] - u_out_1[i] );

		/********************************************************************************************************************************************************/
		/* Calculate the u coordinate for the entry and exit points of the reconstruction volume and then use the uv slope calculated from the detector entry	*/
		/* and exit positions to determine the z position of the proton as it entered and exited the reconstruction volume, respectively.  The u-coordinate of  */
		/* the entry and exit points of the reconsruction cylinder can be found using the x/y entry/exit points just calculated and the inverse rotation		*/
		/*																																						*/
		/*											u = cos( gantry_angle ) * x + sin( gantry_angle ) * y														*/
		/********************************************************************************************************************************************************/
		u_entry = ( cos( rotation_angle_radians ) * x_entry[i] ) + ( sin( rotation_angle_radians ) * y_entry[i] );
		u_exit = ( cos(rotation_angle_radians) * x_exit[i] ) + ( sin(rotation_angle_radians) * y_exit[i] );
		z_entry[i] = v_in_2[i] + uv_entry_slope * ( u_entry - u_in_2[i] );
		z_exit[i] = v_out_1[i] - uv_exit_slope * ( u_out_1[i] - u_exit );

		/********************************************************************************************************************************************************/
		/* Even if the proton path intersected the circle defining the boundary of the cylinder in xy plane twice, it may not have actually passed through the	*/
		/* reconstruction volume or may have only passed through part way.  If |z_entry|> RECON_CYL_HEIGHT/2, then data is erroneous since the source			*/
		/* is around z=0 and we do not want to use this history.  If |z_entry| < RECON_CYL_HEIGHT/2 and |z_exit| > RECON_CYL_HEIGHT/2 then we want to use the	*/ 
		/* history but the x_exit and y_exit positions need to be calculated again based on how far through the cylinder the proton passed before exiting		*/
		/********************************************************************************************************************************************************/
		if( entered && exited )
		{
			if( ( abs(z_entry[i]) < RECON_CYL_HEIGHT * 0.5 ) && ( abs(z_exit[i]) > RECON_CYL_HEIGHT * 0.5 ) )
			{
				double recon_cyl_fraction = abs( ( ( (z_exit[i] >= 0) - (z_exit[i] < 0) ) * RECON_CYL_HEIGHT * 0.5 - z_entry[i] ) / ( z_exit[i] - z_entry[i] ) );
				x_exit[i] = x_entry[i] + recon_cyl_fraction * ( x_exit[i] - x_entry[i] );
				y_exit[i] = y_entry[i] + recon_cyl_fraction * ( y_exit[i] - y_entry[i] );
				z_exit[i] = ( (z_exit[i] >= 0) - (z_exit[i] < 0) ) * RECON_CYL_HEIGHT * 0.5;
			}
			else if( abs(z_entry[i]) > RECON_CYL_HEIGHT * 0.5 )
			{
				entered = false;
				exited = false;
			}
			if( ( abs(z_entry[i]) > RECON_CYL_HEIGHT * 0.5 ) && ( abs(z_exit[i]) < RECON_CYL_HEIGHT * 0.5 ) )
			{
				double recon_cyl_fraction = abs( ( ( (z_exit[i] >= 0) - (z_exit[i] < 0) ) * RECON_CYL_HEIGHT * 0.5 - z_exit[i] ) / ( z_exit[i] - z_entry[i] ) );
				x_entry[i] = x_exit[i] + recon_cyl_fraction * ( x_exit[i] - x_entry[i] );
				y_entry[i] = y_exit[i] + recon_cyl_fraction * ( y_exit[i] - y_entry[i] );
				z_entry[i] = ( (z_entry[i] >= 0) - (z_entry[i] < 0) ) * RECON_CYL_HEIGHT * 0.5;
			}
			/****************************************************************************************************************************************************/ 
			/* Check the measurement locations. Do not allow more than 5 cm difference in entry and exit in t and v. This gets									*/
			/* rid of spurious events.																															*/
			/****************************************************************************************************************************************************/
			if( ( abs(t_out_1[i] - t_in_2[i]) > 5 ) || ( abs(v_out_1[i] - v_in_2[i]) > 5 ) )
			{
				entered = false;
				exited = false;
			}
		}

		// Proton passed through the reconstruction volume only if it both entered and exited the reconstruction cylinder
		missed_recon_volume[i] = !entered || !exited;
	}	
}
__device__ bool calculate_intercepts( double u, double t, double ut_angle, double& u_intercept, double& t_intercept )
{
	/************************************************************************************************************************************************************/
	/*	If a proton passes through the reconstruction volume, then the line defining its path in the xy-plane will intersect the circle defining the boundary	*/
	/* of the reconstruction cylinder in the xy-plane twice.  We can determine if the proton path passes through the reconstruction volume by equating the		*/
	/* equations of the proton path and the circle.  This produces a second order polynomial which we must solve:												*/
	/*																																							*/
	/* 															 f(x)_proton = f(x)_cylinder																	*/
	/* 																	mx+b = sqrt(r^2 - x^2)																	*/
	/* 													 m^2x^2 + 2mbx + b^2 = r^2 - x^2																		*/
	/* 									   (m^2 + 1)x^2 + 2mbx + (b^2 - r^2) = 0																				*/
	/* 														   ax^2 + bx + c = 0																				*/
	/* 																   =>  a = m^2 + 1																			*/
	/* 																	   b = 2mb																				*/
	/* 																	   c = b^2 - r^2																		*/
	/* 																																							*/
	/* 		We can solve this using the quadratic formula ([-b +/- sqrt(b^2-4ac)]/2a).  If the proton passed through the reconstruction volume, then the		*/
	/* 	determinant will be greater than zero ( b^2-4ac > 0 ) and the quadratic formula will return two unique points of intersection.  The intersection point	*/
	/*	closest to where the proton entry/exit path intersects the entry/exit detector plane is then the entry/exit point.  If the determinant <= 0, then the	*/
	/*	proton path does not go through the reconstruction volume and we need not determine intersection coordinates.											*/
	/*																																							*/
	/* 		If the exit/entry path travels through the cone bounded by y=|x| && y=-|x| the x_coordinates will be small and the difference between the entry and */
	/*	exit x-coordinates will approach zero, causing instabilities in trig functions and slope calculations ( x difference in denominator). To overcome these */ 
	/*	innaccurate calculations, coordinates for these proton paths will be rotated PI/2 radians (90 degrees) prior to calculations and rotated back when they	*/ 
	/*	are completed using a rotation matrix transformation again:																								*/
	/* 																																							*/
	/* 					Positive Rotation By 90 Degrees											Negative Rotation By 90 Degree									*/
	/* 						x' = cos( 90 ) * x - sin( 90 ) * y = -y									x' = cos( 90 ) * x + sin( 90 ) * y = y						*/
	/* 						y' = sin( 90 ) * x + cos( 90 ) * y = x									y' = cos( 90 ) * y - sin( 90 ) * x = -x						*/
	/************************************************************************************************************************************************************/

	// Determine if entry points should be rotated
	bool entry_in_cone = ( (ut_angle > PI_OVER_4) && (ut_angle < THREE_PI_OVER_4) ) || ( (ut_angle > FIVE_PI_OVER_4) && (ut_angle < SEVEN_PI_OVER_4) );


	// Rotate u and t by 90 degrees, if necessary
	double u_temp;
	if( entry_in_cone )
	{
		u_temp = u;	
		u = -t;
		t = u_temp;
		ut_angle += PI_OVER_2;
	}
	double m = tan( ut_angle );											// proton entry path slope
	double b_in = t - m * u;											// proton entry path y-intercept

	// Quadratic formula coefficients
	double a = 1 + pow(m, 2);											// x^2 coefficient 
	double b = 2 * m * b_in;											// x coefficient
	double c = pow(b_in, 2) - pow(RECON_CYL_RADIUS, 2 );				// 1 coefficient
	double entry_discriminant = pow(b, 2) - (4 * a * c);				// Quadratic formula discriminant		
	bool intersected = ( entry_discriminant > 0 );						// Proton path intersected twice

	/************************************************************************************************************************************************************/
	/* Find both intersection points of the circle; closest one to the SSDs is the desired intersection point.  Notice that x_intercept_2 = (-b - sqrt())/2a	*/
	/* has the negative sign pulled out and the proceding equations are modified as necessary, e.g.:															*/
	/*																																							*/
	/*														x_intercept_2 = -x_real_2																			*/
	/*														y_intercept_2 = -y_real_2																			*/
	/*												   squared_distance_2 = sqd_real_2																			*/
	/* since									 (x_intercept_2 + x_in)^2 = (-x_intercept_2 - x_in)^2 = (x_real_2 - x_in)^2 (same for y term)					*/
	/*																																							*/
	/* This negation is also considered when assigning x_entry/y_entry using -x_intercept_2/y_intercept_2 *(TRUE/FALSE = 1/0)									*/
	/************************************************************************************************************************************************************/
	if( intersected )
	{
		double u_intercept_1		= ( sqrt(entry_discriminant) - b ) / ( 2 * a );
		double u_intercept_2		= ( sqrt(entry_discriminant) + b ) / ( 2 * a );
		double t_intercept_1		= m * u_intercept_1 + b_in;
		double t_intercept_2		= m * u_intercept_2 - b_in;
		double squared_distance_1	= pow( u_intercept_1 - u, 2 ) + pow( t_intercept_1 - t, 2 );
		double squared_distance_2	= pow( u_intercept_2 + u, 2 ) + pow( t_intercept_2 + t, 2 );
		u_intercept					= u_intercept_1 * ( squared_distance_1 <= squared_distance_2 ) - u_intercept_2 * ( squared_distance_1 > squared_distance_2 );
		t_intercept					= t_intercept_1 * ( squared_distance_1 <= squared_distance_2 ) - t_intercept_2 * ( squared_distance_1 > squared_distance_2 );
	}
	// Unrotate by 90 degrees, if necessary
	if( entry_in_cone )
	{
		u_temp = u_intercept;
		u_intercept = t_intercept;
		t_intercept = -u_temp;
		ut_angle -= PI_OVER_2;
	}

	return intersected;
}
void binning( const int num_histories )
{
	unsigned int size_floats	= sizeof(float) * num_histories;
	unsigned int size_ints		= sizeof(int) * num_histories;
	unsigned int size_bool		= sizeof(bool) * num_histories;

	missed_recon_volume_h		= (bool*)  calloc( num_histories, sizeof(bool)	);	
	bin_num_h					= (int*)   calloc( num_histories, sizeof(int)   );
	x_entry_h					= (float*) calloc( num_histories, sizeof(float) );
	y_entry_h					= (float*) calloc( num_histories, sizeof(float) );
	z_entry_h					= (float*) calloc( num_histories, sizeof(float) );
	x_exit_h					= (float*) calloc( num_histories, sizeof(float) );
	y_exit_h					= (float*) calloc( num_histories, sizeof(float) );
	z_exit_h					= (float*) calloc( num_histories, sizeof(float) );	
	xy_entry_angle_h			= (float*) calloc( num_histories, sizeof(float) );	
	xz_entry_angle_h			= (float*) calloc( num_histories, sizeof(float) );
	xy_exit_angle_h				= (float*) calloc( num_histories, sizeof(float) );
	xz_exit_angle_h				= (float*) calloc( num_histories, sizeof(float) );

	cudaMalloc((void**) &WEPL_d,	size_floats);
	cudaMalloc((void**) &bin_num_d,	size_ints );

	cudaMemcpy( WEPL_d,		WEPL_h,		size_floats,	cudaMemcpyHostToDevice) ;
	cudaMemcpy( bin_num_d,	bin_num_h,	size_ints,		cudaMemcpyHostToDevice );

	dim3 dimBlock( THREADS_PER_BLOCK );
	dim3 dimGrid( (int)( num_histories/THREADS_PER_BLOCK ) + 1 );
	binning_GPU<<<dimGrid, dimBlock>>>
	( 
		num_histories, bin_counts_d, bin_num_d, missed_recon_volume_d,
		x_entry_d, y_entry_d, z_entry_d, x_exit_d, y_exit_d, z_exit_d, 
		mean_WEPL_d, mean_rel_ut_angle_d, mean_rel_uv_angle_d, WEPL_d, 
		xy_entry_angle_d, xz_entry_angle_d, xy_exit_angle_d, xz_exit_angle_d
	);
	cudaMemcpy( missed_recon_volume_h,		missed_recon_volume_d,		size_bool,		cudaMemcpyDeviceToHost );
	cudaMemcpy( bin_num_h,					bin_num_d,					size_ints,		cudaMemcpyDeviceToHost );
	cudaMemcpy( x_entry_h,					x_entry_d,					size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( y_entry_h,					y_entry_d,					size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( z_entry_h,					z_entry_d,					size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( x_exit_h,					x_exit_d,					size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( y_exit_h,					y_exit_d,					size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( z_exit_h,					z_exit_d,					size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( xy_entry_angle_h,			xy_entry_angle_d,			size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( xz_entry_angle_h,			xz_entry_angle_d,			size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( xy_exit_angle_h,			xy_exit_angle_d,			size_floats,	cudaMemcpyDeviceToHost );
	cudaMemcpy( xz_exit_angle_h,			xz_exit_angle_d,			size_floats,	cudaMemcpyDeviceToHost );

	char data_filename[128];
	if( WRITE_BIN_WEPLS )
	{
		sprintf(data_filename, "%s_%03d%s", "bin_numbers", gantry_angle_h[0], ".txt" );
		array_2_disk( data_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, bin_num_h, COLUMNS, ROWS, SLICES, num_histories, true );
	}

	// Push data from valid histories  (i.e. missed_recon_volume = FALSE) onto the end of each vector
	int offset = 0;
	for( unsigned int i = 0; i < num_histories; i++ )
	{
		if( !missed_recon_volume_h[i] && ( bin_num_h[i] >= 0 ) )
		{
			bin_num_vector.push_back( bin_num_h[i] );
			//gantry_angle_vector.push_back( gantry_angle_h[i] );
			WEPL_vector.push_back( WEPL_h[i] );
			x_entry_vector.push_back( x_entry_h[i] );
			y_entry_vector.push_back( y_entry_h[i] );
			z_entry_vector.push_back( z_entry_h[i] );
			x_exit_vector.push_back( x_exit_h[i] );
			y_exit_vector.push_back( y_exit_h[i] );
			z_exit_vector.push_back( z_exit_h[i] );
			xy_entry_angle_vector.push_back( xy_entry_angle_h[i] );
			xz_entry_angle_vector.push_back( xz_entry_angle_h[i] );
			xy_exit_angle_vector.push_back( xy_exit_angle_h[i] );
			xz_exit_angle_vector.push_back( xz_exit_angle_h[i] );
			offset++;
			recon_vol_histories++;
		}
	}
	//char statement[256];
	percentage_pass_each_intersection_cut = (double) offset / num_histories * 100.0;
	sprintf(print_statement, "=======>%d out of %d (%4.2f%%) histories passed intersection cuts", offset, num_histories, percentage_pass_each_intersection_cut );
	print_colored_text(print_statement, DARK, GREEN );
	
	free( missed_recon_volume_h ); 
	free( bin_num_h );
	free( x_entry_h );
	free( y_entry_h );
	free( z_entry_h );
	free( x_exit_h );
	free( y_exit_h );
	free( z_exit_h );
	free( xy_entry_angle_h );
	free( xz_entry_angle_h );
	free( xy_exit_angle_h );
	free( xz_exit_angle_h );
	/* 
		Host memory allocated but not freed here
		N/A
	*/

	cudaFree( xy_entry_angle_d );
	cudaFree( xz_entry_angle_d );
	cudaFree( xy_exit_angle_d );
	cudaFree( xz_exit_angle_d );
	/* 
		Device memory allocated but not freed here
		WEPL_d;
		bin_num_d;
	*/
}
__global__ void binning_GPU
( 
	int num_histories, int* bin_counts, int* bin_num, bool* missed_recon_volume, 
	float* x_entry, float* y_entry, float* z_entry, float* x_exit, float* y_exit, float* z_exit, 
	float* mean_WEPL, float* mean_rel_ut_angle, float* mean_rel_uv_angle, float* WEPL, 
	float* xy_entry_angle, float* xz_entry_angle, float* xy_exit_angle, float* xz_exit_angle
)
{
	int i = threadIdx.x + blockIdx.x * THREADS_PER_BLOCK;
	if( i < num_histories )
	{		
		/********************************************************************************************************************/ 
		/*	Bin histories according to angle/t/v.  The value of t varies along the path, so use the average value, which	*/
		/*	occurs at the midpoint of the chord connecting the entry and exit of the reconstruction volume since the		*/
		/*	orientation of the chord is symmetric about the midpoint (drawing included in documentation).					*/
		/********************************************************************************************************************/ 
		double x_midpath, y_midpath, z_midpath, path_angle;
		int angle_bin, t_bin, v_bin;
		double angle, t, v;
		double rel_ut_angle, rel_uv_angle;

		// Calculate midpoint of chord connecting entry and exit
		x_midpath = ( x_entry[i] + x_exit[i] ) / 2;
		y_midpath = ( y_entry[i] + y_exit[i] ) / 2;
		z_midpath = ( z_entry[i] + z_exit[i] ) / 2;

		// Calculate path angle and determine which angular bin is closest
		path_angle = atan2( ( y_exit[i] - y_entry[i] ) , ( x_exit[i] - x_entry[i] ) );
		if( path_angle < 0 )
			path_angle += 2*PI;
		angle_bin = int( ( path_angle * RADIANS_TO_ANGLE / ANGULAR_BIN_SIZE ) + 0.5) % ANGULAR_BINS;	
		angle = angle_bin * ANGULAR_BIN_SIZE * ANGLE_TO_RADIANS;

		// Calculate t/v of midpoint and find t/v bin closest to this value
		t = y_midpath * cos(angle) - x_midpath * sin(angle);
		t_bin = int( (t / T_BIN_SIZE ) + T_BINS/2);			
			
		v = z_midpath;
		v_bin = int( (v / V_BIN_SIZE ) + V_BINS/2);
		
		// For histories with valid angular/t/v bin #, calculate bin #, add to its count and WEPL/relative angle sums
		if( (t_bin >= 0) && (v_bin >= 0) && (t_bin < T_BINS) && (v_bin < V_BINS) )
		{
			bin_num[i] = t_bin + angle_bin * T_BINS + v_bin * T_BINS * ANGULAR_BINS;
			if( !missed_recon_volume[i] )
			{
				//xy_entry_angle[i]
				//xz_entry_angle[i]
				//xy_exit_angle[i]
				//xz_exit_angle[i]
				rel_ut_angle = xy_exit_angle[i] - xy_entry_angle[i];
				if( rel_ut_angle > PI )
					rel_ut_angle -= 2 * PI;
				if( rel_ut_angle < -PI )
					rel_ut_angle += 2 * PI;
				rel_uv_angle = xz_exit_angle[i] - xz_entry_angle[i];
				if( rel_uv_angle > PI )
					rel_uv_angle -= 2 * PI;
				if( rel_uv_angle < -PI )
					rel_uv_angle += 2 * PI;
				atomicAdd( &bin_counts[bin_num[i]], 1 );
				atomicAdd( &mean_WEPL[bin_num[i]], WEPL[i] );
				atomicAdd( &mean_rel_ut_angle[bin_num[i]], rel_ut_angle );
				atomicAdd( &mean_rel_uv_angle[bin_num[i]], rel_uv_angle );
				//atomicAdd( &mean_rel_ut_angle[bin_num[i]], relative_ut_angle[i] );
				//atomicAdd( &mean_rel_uv_angle[bin_num[i]], relative_uv_angle[i] );
			}
			//else
				//bin_num[i] = -1;
		}
	}
}
/***********************************************************************************************************************************************************************************************************************/
/******************************************************************************************** Statistical analysis and cuts ********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void calculate_means()
{
	//char statement[] = "Calculating the Mean for Each Bin Before Cuts...";
	sprintf( print_statement, "Calculating the Mean for Each Bin Before Cuts...");
	//puts("Calculating the Mean for Each Bin Before Cuts...");
	//sprintf(print_statement, "\tReading %d histories for gantry angle %d from scan number %d...\n", file_histories, gantry_angle, scan_number );			
	print_colored_text( print_statement, LIGHT, CYAN );	
	//cudaMemcpy( mean_WEPL_h,	mean_WEPL_d,	SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost );
	//	int* empty_parameter;
	//	bins_2_disk( "WEPL_dist_pre_test2", empty_parameter, mean_WEPL_h, NUM_BINS, MEANS, ALL_BINS, BY_BIN );

	dim3 dimBlock( T_BINS );
	dim3 dimGrid( V_BINS, ANGULAR_BINS );   
	calculate_means_GPU<<< dimGrid, dimBlock >>>
	( 
		bin_counts_d, mean_WEPL_d, mean_rel_ut_angle_d, mean_rel_uv_angle_d
	);

	if( WRITE_WEPL_DISTS )
	{
		cudaMemcpy( mean_WEPL_h,	mean_WEPL_d,	SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost );
		//int* empty_parameter; //Warning: declared but not used
		//bins_2_disk( "WEPL_dist_pre_test2", empty_parameter, mean_WEPL_h, NUM_BINS, MEANS, ALL_BINS, BY_BIN );
	}
	bin_counts_h		  = (int*)	 calloc( NUM_BINS, sizeof(int) );
	cudaMemcpy(bin_counts_h, bin_counts_d, SIZE_BINS_INT, cudaMemcpyDeviceToHost) ;
	cudaMemcpy( mean_WEPL_h,	mean_WEPL_d,	SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost );
	cudaMemcpy( mean_rel_ut_angle_h,	mean_rel_ut_angle_d,	SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost );
	cudaMemcpy( mean_rel_uv_angle_h,	mean_rel_uv_angle_d,	SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost );
	
	array_2_disk(BIN_COUNTS_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, bin_counts_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	array_2_disk(MEAN_WEPL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, mean_WEPL_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	array_2_disk(MEAN_REL_UT_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, mean_rel_ut_angle_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	array_2_disk(MEAN_REL_UV_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, mean_rel_uv_angle_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	
	free(bin_counts_h);
	free(mean_WEPL_h);
	free(mean_rel_ut_angle_h);
	free(mean_rel_uv_angle_h);
}
__global__ void calculate_means_GPU( int* bin_counts, float* mean_WEPL, float* mean_rel_ut_angle, float* mean_rel_uv_angle )
{
	int v = blockIdx.x, angle = blockIdx.y, t = threadIdx.x;
	int bin = t + angle * T_BINS + v * T_BINS * ANGULAR_BINS;
	if( bin_counts[bin] > 0 )
	{
		mean_WEPL[bin] /= bin_counts[bin];		
		mean_rel_ut_angle[bin] /= bin_counts[bin];
		mean_rel_uv_angle[bin] /= bin_counts[bin];
	}
}
void sum_squared_deviations( const int start_position, const int num_histories )
{
	unsigned int size_floats = sizeof(float) * num_histories;
	unsigned int size_ints = sizeof(int) * num_histories;

	cudaMalloc((void**) &bin_num_d,				size_ints);
	cudaMalloc((void**) &WEPL_d,				size_floats);
	cudaMalloc((void**) &xy_entry_angle_d,		size_floats);
	cudaMalloc((void**) &xz_entry_angle_d,		size_floats);
	cudaMalloc((void**) &xy_exit_angle_d,		size_floats);
	cudaMalloc((void**) &xz_exit_angle_d,		size_floats);

	cudaMemcpy( bin_num_d,				&bin_num_vector[start_position],			size_ints, cudaMemcpyHostToDevice);
	cudaMemcpy( WEPL_d,					&WEPL_vector[start_position],				size_floats, cudaMemcpyHostToDevice);
	cudaMemcpy( xy_entry_angle_d,		&xy_entry_angle_vector[start_position],		size_floats, cudaMemcpyHostToDevice);
	cudaMemcpy( xz_entry_angle_d,		&xz_entry_angle_vector[start_position],		size_floats, cudaMemcpyHostToDevice);
	cudaMemcpy( xy_exit_angle_d,		&xy_exit_angle_vector[start_position],		size_floats, cudaMemcpyHostToDevice);
	cudaMemcpy( xz_exit_angle_d,		&xz_exit_angle_vector[start_position],		size_floats, cudaMemcpyHostToDevice);

	dim3 dimBlock(THREADS_PER_BLOCK);
	dim3 dimGrid((int)(num_histories/THREADS_PER_BLOCK)+1);
	sum_squared_deviations_GPU<<<dimGrid, dimBlock>>>
	( 
		num_histories, bin_num_d, mean_WEPL_d, mean_rel_ut_angle_d, mean_rel_uv_angle_d, 
		WEPL_d, xy_entry_angle_d, xz_entry_angle_d,  xy_exit_angle_d, xz_exit_angle_d,
		stddev_WEPL_d, stddev_rel_ut_angle_d, stddev_rel_uv_angle_d
	);
	cudaFree( bin_num_d );
	cudaFree( WEPL_d );
	cudaFree( xy_entry_angle_d );
	cudaFree( xz_entry_angle_d );
	cudaFree( xy_exit_angle_d );
	cudaFree( xz_exit_angle_d );
}
__global__ void sum_squared_deviations_GPU
( 
	int num_histories, int* bin_num, float* mean_WEPL, float* mean_rel_ut_angle, float* mean_rel_uv_angle,  
	float* WEPL, float* xy_entry_angle, float* xz_entry_angle, float* xy_exit_angle, float* xz_exit_angle,
	float* stddev_WEPL, float* stddev_rel_ut_angle, float* stddev_rel_uv_angle
)
{
	int i = threadIdx.x + blockIdx.x * THREADS_PER_BLOCK;
	if( i < num_histories )
	{
		double rel_ut_angle = xy_exit_angle[i] - xy_entry_angle[i];
		if( rel_ut_angle > PI )
			rel_ut_angle -= 2 * PI;
		if( rel_ut_angle < -PI )
			rel_ut_angle += 2 * PI;
		double rel_uv_angle = xz_exit_angle[i] - xz_entry_angle[i];
		if( rel_uv_angle > PI )
			rel_uv_angle -= 2 * PI;
		if( rel_uv_angle < -PI )
			rel_uv_angle += 2 * PI;
		double WEPL_difference = WEPL[i] - mean_WEPL[bin_num[i]];
		double rel_ut_angle_difference = rel_ut_angle - mean_rel_ut_angle[bin_num[i]];
		double rel_uv_angle_difference = rel_uv_angle - mean_rel_uv_angle[bin_num[i]];

		atomicAdd( &stddev_WEPL[bin_num[i]], pow( WEPL_difference, 2 ) );
		atomicAdd( &stddev_rel_ut_angle[bin_num[i]], pow( rel_ut_angle_difference, 2 ) );
		atomicAdd( &stddev_rel_uv_angle[bin_num[i]], pow( rel_uv_angle_difference, 2 ) );
	}
}
void calculate_standard_deviations()
{
	//char statement[] = "Calculating standard deviations for each bin...";		
	sprintf( print_statement, "Calculating standard deviations for each bin...");	
	print_colored_text( print_statement, LIGHT, CYAN );	
	dim3 dimBlock( T_BINS );
	dim3 dimGrid( V_BINS, ANGULAR_BINS );   
	calculate_standard_deviations_GPU<<< dimGrid, dimBlock >>>
	( 
		bin_counts_d, stddev_WEPL_d, stddev_rel_ut_angle_d, stddev_rel_uv_angle_d
	);
	cudaMemcpy( stddev_rel_ut_angle_h,	stddev_rel_ut_angle_d,	SIZE_BINS_FLOAT,	cudaMemcpyDeviceToHost );
	cudaMemcpy( stddev_rel_uv_angle_h,	stddev_rel_uv_angle_d,	SIZE_BINS_FLOAT,	cudaMemcpyDeviceToHost );
	cudaMemcpy( stddev_WEPL_h,			stddev_WEPL_d,			SIZE_BINS_FLOAT,	cudaMemcpyDeviceToHost );

	array_2_disk(STDDEV_REL_UT_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, stddev_rel_ut_angle_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	array_2_disk(STDDEV_REL_UV_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, stddev_rel_uv_angle_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	array_2_disk(STDDEV_WEPL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, stddev_WEPL_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	//cudaFree( bin_counts_d );
}
__global__ void calculate_standard_deviations_GPU( int* bin_counts, float* stddev_WEPL, float* stddev_rel_ut_angle, float* stddev_rel_uv_angle )
{
	int v = blockIdx.x, angle = blockIdx.y, t = threadIdx.x;
	int bin = t + angle * T_BINS + v * T_BINS * ANGULAR_BINS;
	if( bin_counts[bin] > 1 )
	{
		// SAMPLE_STD_DEV = true/false = 1/0 => std_dev = SUM{i = 1 -> N} [ ( mu - x_i)^2 / ( N - 1/0 ) ]
		stddev_WEPL[bin] = sqrtf( stddev_WEPL[bin] / ( bin_counts[bin] - SAMPLE_STD_DEV ) );		
		stddev_rel_ut_angle[bin] = sqrtf( stddev_rel_ut_angle[bin] / ( bin_counts[bin] - SAMPLE_STD_DEV ) );
		stddev_rel_uv_angle[bin] = sqrtf( stddev_rel_uv_angle[bin] / ( bin_counts[bin] - SAMPLE_STD_DEV ) );
	}
	syncthreads();
	bin_counts[bin] = 0;
}
void statistical_allocations( const int num_histories)
{
	unsigned int size_floats = sizeof(float) * num_histories;
	unsigned int size_ints = sizeof(int) * num_histories;
	unsigned int size_bools = sizeof(bool) * num_histories;

	failed_cuts_h = (bool*) calloc ( num_histories, sizeof(bool) );
	
	cudaMalloc( (void**) &bin_num_d,			size_ints );
	cudaMalloc( (void**) &WEPL_d,				size_floats );
	cudaMalloc( (void**) &xy_entry_angle_d,		size_floats );
	cudaMalloc( (void**) &xz_entry_angle_d,		size_floats );
	cudaMalloc( (void**) &xy_exit_angle_d,		size_floats );
	cudaMalloc( (void**) &xz_exit_angle_d,		size_floats );
	cudaMalloc( (void**) &failed_cuts_d,		size_bools );

	//char error_statement[] = {"ERROR: reconstruction_cuts GPU array allocations caused...\n"};
	//cudaError_t cudaStatus = CUDA_error_check( error_statement );
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_allocations Error: %s\n", cudaGetErrorString(cudaStatus));
}
void statistical_host_2_device(const int start_position, const int num_histories) 
{
	unsigned int size_ints		= sizeof(int) * num_histories;
	unsigned int size_floats	= sizeof(float) * num_histories;
	unsigned int size_bools		= sizeof(bool) * num_histories;

	cudaMemcpy( bin_num_d,			&bin_num_vector[start_position],			size_ints,		cudaMemcpyHostToDevice );
	cudaMemcpy( WEPL_d,				&WEPL_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_entry_angle_d,	&xy_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_entry_angle_d,	&xz_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_exit_angle_d,	&xy_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_exit_angle_d,	&xz_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( failed_cuts_d,		failed_cuts_h,								size_bools,		cudaMemcpyHostToDevice );

	//cudaMemcpy( bin_num_d,				&bin_num[start_position],			size_ints, cudaMemcpyHostToDevice);
	//cudaMemcpy( WEPL_d,					&WEPL[start_position],				size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xy_entry_angle_d,		&xy_entry_angle[start_position],		size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xz_entry_angle_d,		&xz_entry_angle[start_position],		size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xy_exit_angle_d,		&xy_exit_angle[start_position],		size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xz_exit_angle_d,		&xz_exit_angle[start_position],		size_floats, cudaMemcpyHostToDevice);

	//char error_statement[] = {"ERROR: reconstruction_cuts host->GPU data transfer caused...\n"};
	//cudaError_t cudaStatus =  CUDA_error_check( error_statement );
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_host_2_device Error: %s\n", cudaGetErrorString(cudaStatus));	
}
void statistical_cuts_device_2_host(const int start_position, const int num_histories) 
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_ints			= sizeof(int) * num_histories;
	unsigned int size_bool			= sizeof(bool) * num_histories;

	cudaMemcpy(&first_MLP_voxel_vector[start_position], first_MLP_voxel_d, size_ints, cudaMemcpyDeviceToHost);
	cudaMemcpy(&x_entry_vector[start_position], x_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&y_entry_vector[start_position], y_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&z_entry_vector[start_position], z_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&x_exit_vector[start_position], x_exit_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&y_exit_vector[start_position], y_exit_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&z_exit_vector[start_position], z_exit_d, size_floats, cudaMemcpyDeviceToHost);	
	cudaMemcpy(traversed_hull_h, traversed_hull_d, size_bool, cudaMemcpyDeviceToHost);
	
	//char error_statement[] = {"ERROR: reconstruction_cuts GPU->host data transfer caused...\n"};
	//cudaError_t cudaStatus =  CUDA_error_check( error_statement );
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_device_2_host Error: %s\n", cudaGetErrorString(cudaStatus));
}
void statistical_cuts_deallocations()
{
	cudaFree(bin_num_d);
	cudaFree(WEPL_d);
	cudaFree(xy_entry_angle_d);
	cudaFree(xz_entry_angle_d);
	cudaFree(xy_exit_angle_d);
	cudaFree(xz_exit_angle_d);
	cudaFree(failed_cuts_d);

	free(failed_cuts_h);
	/* 
		Host memory allocated but not freed here
		failed_cuts_h
	*/
	/* 
		Device memory allocated but not freed here
		bin_num_d;
		WEPL_d;
		xy_entry_angle_d
		xz_entry_angle_d
		xy_exit_angle_d
		xz_exit_angle_d
		failed_cuts_d
	*/
	
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_deallocations Error: %s\n", cudaGetErrorString(cudaStatus));
}
void statistical_cuts( const int num_histories )
{
	//char statement[256];
	int remaining_histories = num_histories;
	int start_position = 0, histories_2_process = 0;
	sprintf( print_statement, "Performing statistical cuts...");
	print_colored_text( print_statement, DARK, CYAN );	
	while( remaining_histories > 0 )
	{
		if( remaining_histories > MAX_CUTS_HISTORIES )
			histories_2_process = MAX_CUTS_HISTORIES;
		else
			histories_2_process = remaining_histories;
		statistical_cuts( start_position, histories_2_process );
		remaining_histories -= MAX_CUTS_HISTORIES;
		start_position		+= MAX_CUTS_HISTORIES;
	}
	sprintf( print_statement, "Statistical cuts complete.");
	print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );
		
	percentage_pass_statistical_cuts = (double) post_cut_histories / total_histories * 100;
	sprintf(print_statement, "%d out of %d (%4.2f%%) histories also passed statistical cuts", post_cut_histories, total_histories, percentage_pass_statistical_cuts );
	print_colored_text( print_statement, DARK, GREEN );
}
void statistical_cuts( const int start_position, const int num_histories )
{
	unsigned int size_floats = sizeof(float) * num_histories;
	unsigned int size_ints = sizeof(int) * num_histories;
	unsigned int size_bools = sizeof(bool) * num_histories;

	failed_cuts_h = (bool*) calloc ( num_histories, sizeof(bool) );
	
	cudaMalloc( (void**) &bin_num_d,			size_ints );
	cudaMalloc( (void**) &WEPL_d,				size_floats );
	cudaMalloc( (void**) &xy_entry_angle_d,		size_floats );
	cudaMalloc( (void**) &xz_entry_angle_d,		size_floats );
	cudaMalloc( (void**) &xy_exit_angle_d,		size_floats );
	cudaMalloc( (void**) &xz_exit_angle_d,		size_floats );
	cudaMalloc( (void**) &failed_cuts_d,		size_bools );

	cudaMemcpy( bin_num_d,				&bin_num_vector[start_position],			size_ints,		cudaMemcpyHostToDevice );
	cudaMemcpy( WEPL_d,					&WEPL_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_entry_angle_d,		&xy_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_entry_angle_d,		&xz_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_exit_angle_d,		&xy_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_exit_angle_d,		&xz_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( failed_cuts_d,			failed_cuts_h,								size_bools,		cudaMemcpyHostToDevice );

	//cudaMemcpy( bin_num_d,				&bin_num[start_position],			size_ints, cudaMemcpyHostToDevice);
	//cudaMemcpy( WEPL_d,					&WEPL[start_position],				size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xy_entry_angle_d,		&xy_entry_angle[start_position],		size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xz_entry_angle_d,		&xz_entry_angle[start_position],		size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xy_exit_angle_d,		&xy_exit_angle[start_position],		size_floats, cudaMemcpyHostToDevice);
	//cudaMemcpy( xz_exit_angle_d,		&xz_exit_angle[start_position],		size_floats, cudaMemcpyHostToDevice);

	dim3 dimBlock(THREADS_PER_BLOCK);
	dim3 dimGrid( int( num_histories / THREADS_PER_BLOCK ) + 1 );  
	statistical_cuts_GPU<<< dimGrid, dimBlock >>>
	( 
		num_histories, bin_counts_d, bin_num_d, sinogram_d, WEPL_d, 
		xy_entry_angle_d, xz_entry_angle_d, xy_exit_angle_d, xz_exit_angle_d, 
		mean_WEPL_d, mean_rel_ut_angle_d, mean_rel_uv_angle_d, 
		stddev_WEPL_d, stddev_rel_ut_angle_d, stddev_rel_uv_angle_d, 
		failed_cuts_d
	);
	cudaMemcpy( failed_cuts_h, failed_cuts_d, size_bools, cudaMemcpyDeviceToHost);

	// Shift valid data (i.e. failed_cuts = FALSE) to the left, overwriting data from histories that did not pass through the reconstruction volume
	// 
	for( unsigned int i = 0; i < num_histories; i++ )
	{
		if( !failed_cuts_h[i] )
		{
			bin_num_vector[post_cut_histories] = bin_num_vector[start_position + i];
			//gantry_angle_vector[post_cut_histories] = gantry_angle_vector[start_position + i];
			WEPL_vector[post_cut_histories] = WEPL_vector[start_position + i];
			x_entry_vector[post_cut_histories] = x_entry_vector[start_position + i];
			y_entry_vector[post_cut_histories] = y_entry_vector[start_position + i];
			z_entry_vector[post_cut_histories] = z_entry_vector[start_position + i];
			x_exit_vector[post_cut_histories] = x_exit_vector[start_position + i];
			y_exit_vector[post_cut_histories] = y_exit_vector[start_position + i];
			z_exit_vector[post_cut_histories] = z_exit_vector[start_position + i];
			xy_entry_angle_vector[post_cut_histories] = xy_entry_angle_vector[start_position + i];
			xz_entry_angle_vector[post_cut_histories] = xz_entry_angle_vector[start_position + i];
			xy_exit_angle_vector[post_cut_histories] = xy_exit_angle_vector[start_position + i];
			xz_exit_angle_vector[post_cut_histories] = xz_exit_angle_vector[start_position + i];
			post_cut_histories++;
		}
	}
	
	cudaFree(bin_num_d);
	cudaFree(WEPL_d);
	cudaFree(xy_entry_angle_d);
	cudaFree(xz_entry_angle_d);
	cudaFree(xy_exit_angle_d);
	cudaFree(xz_exit_angle_d);
	cudaFree(failed_cuts_d);

	free(failed_cuts_h);
	/* 
		Host memory allocated but not freed here
		failed_cuts_h
	*/
	/* 
		Device memory allocated but not freed here
		bin_num_d;
		WEPL_d;
		xy_entry_angle_d
		xz_entry_angle_d
		xy_exit_angle_d
		xz_exit_angle_d
		failed_cuts_d
	*/
}
__global__ void statistical_cuts_GPU
( 
	int num_histories, int* bin_counts, int* bin_num, float* sinogram, float* WEPL, 
	float* xy_entry_angle, float* xz_entry_angle, float* xy_exit_angle, float* xz_exit_angle, 
	float* mean_WEPL, float* mean_rel_ut_angle, float* mean_rel_uv_angle,
	float* stddev_WEPL, float* stddev_rel_ut_angle, float* stddev_rel_uv_angle, 
	bool* failed_cuts
)
{
	int i = threadIdx.x + blockIdx.x * THREADS_PER_BLOCK;
	if( i < num_histories )
	{
		double rel_ut_angle = xy_exit_angle[i] - xy_entry_angle[i];
		if( rel_ut_angle > PI )
			rel_ut_angle -= 2 * PI;
		if( rel_ut_angle < -PI )
			rel_ut_angle += 2 * PI;
		double rel_uv_angle = xz_exit_angle[i] - xz_entry_angle[i];
		if( rel_uv_angle > PI )
			rel_uv_angle -= 2 * PI;
		if( rel_uv_angle < -PI )
			rel_uv_angle += 2 * PI;
		bool passed_ut_cut = ( abs( rel_ut_angle - mean_rel_ut_angle[bin_num[i]] ) < ( SIGMAS_TO_KEEP * stddev_rel_ut_angle[bin_num[i]] ) );
		bool passed_uv_cut = ( abs( rel_uv_angle - mean_rel_uv_angle[bin_num[i]] ) < ( SIGMAS_TO_KEEP * stddev_rel_uv_angle[bin_num[i]] ) );
		//bool passed_uv_cut = true;
		bool passed_WEPL_cut = ( abs( mean_WEPL[bin_num[i]] - WEPL[i] ) <= ( SIGMAS_TO_KEEP * stddev_WEPL[bin_num[i]] ) );
		failed_cuts[i] = !passed_ut_cut || !passed_uv_cut || !passed_WEPL_cut;

		if( !failed_cuts[i] )
		{
			atomicAdd( &bin_counts[bin_num[i]], 1 );
			atomicAdd( &sinogram[bin_num[i]], WEPL[i] );			
		}
	}
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************************************* FBP *********************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void initialize_sinogram()
{
	//char statement[] = "Allocating host and GPU memory and initializing sinogram...";		
	sprintf( print_statement, "Allocating host and GPU memory and initializing sinogram...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
	sinogram_h = (float*) calloc( NUM_BINS, sizeof(float) );
	if( sinogram_h == NULL )
	{
		puts("ERROR: Memory allocation for sinogram_filtered_h failed.");
		exit(1);
	}
	cudaMalloc((void**) &sinogram_d, SIZE_BINS_FLOAT );
	cudaMemcpy( sinogram_d ,	sinogram_h,	SIZE_BINS_FLOAT, cudaMemcpyHostToDevice );	
}
void construct_sinogram()
{
	//char statement[] = "Recalculating the mean WEPL for each bin and constructing the sinogram...";		
	sprintf( print_statement, "Allocating host and GPU memory and initializing sinogram...");			
	print_colored_text( print_statement, LIGHT, CYAN );	

	bin_counts_h		  = (int*)	 calloc( NUM_BINS, sizeof(int) );
	cudaMemcpy(bin_counts_h, bin_counts_d, SIZE_BINS_INT, cudaMemcpyDeviceToHost) ;	
	cudaMemcpy(sinogram_h,  sinogram_d, SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost);
	
	array_2_disk(SINOGRAM_PRE_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, sinogram_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	array_2_disk( BIN_COUNTS_PRE_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, bin_counts_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	
	dim3 dimBlock( T_BINS );
	dim3 dimGrid( V_BINS, ANGULAR_BINS );   
	construct_sinogram_GPU<<< dimGrid, dimBlock >>>( bin_counts_d, sinogram_d );

	if( WRITE_WEPL_DISTS )
	{
		cudaMemcpy( sinogram_h,	sinogram_d,	SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost );
		//int* empty_parameter; //Warning: declared but never used
		//bins_2_disk( "WEPL_dist_post_test2", empty_parameter, sinogram_h, NUM_BINS, MEANS, ALL_BINS, BY_BIN );
	}
	cudaMemcpy(sinogram_h,  sinogram_d, SIZE_BINS_FLOAT, cudaMemcpyDeviceToHost);
	cudaMemcpy(bin_counts_h, bin_counts_d, SIZE_BINS_INT, cudaMemcpyDeviceToHost) ;
	
	array_2_disk(SINOGRAM_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, sinogram_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	array_2_disk( BIN_COUNTS_POST_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, bin_counts_h, T_BINS, ANGULAR_BINS, V_BINS, NUM_BINS, true );
	
	cudaFree(bin_counts_d);
}
__global__ void construct_sinogram_GPU( int* bin_counts, float* sinogram )
{
	int v = blockIdx.x, angle = blockIdx.y, t = threadIdx.x;
	int bin = t + angle * T_BINS + v * T_BINS * ANGULAR_BINS;
	if( bin_counts[bin] > 0 )
		sinogram[bin] /= bin_counts[bin];		
}
void FBP()
{
	// Filter the sinogram before backprojecting
	filter();

	free(sinogram_h);
	cudaFree(sinogram_d);
	//char statement[256];
	sprintf(print_statement, "Performing backprojection...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
	
	FBP_image_h = (float*) calloc( NUM_VOXELS, sizeof(float) );
	if( FBP_image_h == NULL ) 
	{
		printf("ERROR: Memory not allocated for FBP_image_h!\n");
		exit_program_if(true);
	}

	free(sinogram_filtered_h);
	cudaMalloc((void**) &FBP_image_d, SIZE_IMAGE_FLOAT );
	cudaMemcpy( FBP_image_d, FBP_image_h, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice );

	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   
	backprojection_GPU<<< dimGrid, dimBlock >>>( sinogram_filtered_d, FBP_image_d );
	cudaFree(sinogram_filtered_d);

	if( WRITE_FBP_IMAGE )
	{
		cudaMemcpy( FBP_image_h, FBP_image_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost );
		array_2_disk( FBP_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, FBP_image_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );	
	}

	if( IMPORT_FILTERED_FBP)
	{
		//char filename[256];
		//char* name = "FBP_med7";		
		//sprintf( filename, "%s%s/%s%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, name, ".bin" );
		//import_image( image, filename );
		float* image = (float*)calloc( NUM_VOXELS, sizeof(float));
		sprintf(IMPORT_FBP_PATH,"%s%s/%s%d%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, IMPORT_FBP_FILENAME, 2*FBP_MED_FILTER_RADIUS+1,".bin" );
		import_image( image, IMPORT_FBP_PATH );
		FBP_image_h = image;
		array_2_disk( FBP_AFTER_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, image, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	}
	else if( AVG_FILTER_FBP )
	{
		//puts("Applying average filter to FBP image...");
		sprintf(print_statement, "Applying average filter to FBP image...");		
		print_colored_text( print_statement, LIGHT, CYAN );	
		//cout << FBP_image_d << endl;
		//float* FBP_image_filtered_d;
		FBP_image_filtered_h = FBP_image_h;
		cudaMalloc((void**) &FBP_image_filtered_d, SIZE_IMAGE_FLOAT );
		cudaMemcpy( FBP_image_filtered_d, FBP_image_filtered_h, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice );

		//averaging_filter( FBP_image_h, FBP_image_filtered_d, FBP_FILTER_RADIUS, false, FBP_FILTER_THRESHOLD );
		averaging_filter( FBP_image_filtered_h, FBP_image_filtered_d, FBP_AVG_FILTER_RADIUS, false, FBP_AVG_FILTER_THRESHOLD );
		//puts("FBP Filtering complete");
		sprintf(print_statement, "FBP Filtering complete");		
		print_colored_text( print_statement, LIGHT, RED );	
		if( WRITE_AVG_FBP )
		{
			//puts("Writing filtered hull to disk...");
			sprintf(print_statement, "Writing filtered FBP to disk...");		
			print_colored_text( print_statement, LIGHT, CYAN );	
			//cudaMemcpy(FBP_image_h, FBP_image_filtered_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost);
			//array_2_disk( "FBP_image_filtered", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, FBP_image_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
			cudaMemcpy(FBP_image_filtered_h, FBP_image_filtered_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost) ;
			//cout << FBP_image_d << endl;
			array_2_disk( FBP_IMAGE_FILTER_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, FBP_image_filtered_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
			//FBP_image_h = FBP_image_filtered_h;
		}
		cudaFree(FBP_image_filtered_d);
	}
	else if( MEDIAN_FILTER_FBP )
	{
		//puts("Applying median filter to FBP image...");
		sprintf(print_statement, "Applying median filter to FBP image...");		
		print_colored_text( print_statement, LIGHT, CYAN );	
		//cout << FBP_image_d << endl;
		//float* FBP_image_filtered_d;
		//FBP_median_filtered_h = FBP_image_h;
		//cudaMalloc((void**) &FBP_median_filtered_d, SIZE_IMAGE_FLOAT );
		//cudaMemcpy( FBP_median_filtered_d, FBP_median_filtered_h, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice );
		FBP_median_filtered_h = (float*)calloc(NUM_VOXELS, sizeof(float));
		//averaging_filter( FBP_image_h, FBP_image_filtered_d, FBP_FILTER_RADIUS, false, FBP_FILTER_THRESHOLD );
		median_filter_2D( FBP_image_h, FBP_median_filtered_h, FBP_MED_FILTER_RADIUS );
		std::copy(FBP_median_filtered_h, FBP_median_filtered_h + NUM_VOXELS, FBP_image_h);
	
		//FBP_image_h = FBP_image_filtered_h;
		//puts("FBP median filtering complete");
		sprintf(print_statement, "FBP median filtering complete");		
		print_colored_text( print_statement, LIGHT, RED );	
		if( WRITE_MEDIAN_FBP )
		{
			//puts("Writing filtered hull to disk...");
			sprintf(print_statement, "Writing filtered hull to disk...");		
			print_colored_text( print_statement, LIGHT, CYAN );	
			//cudaMemcpy(FBP_image_h, FBP_image_filtered_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost);
			//array_2_disk( "FBP_image_filtered", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, FBP_image_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
			//cudaMemcpy(FBP_median_filtered_h, FBP_median_filtered_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost) ;
			//cout << FBP_image_d << endl;
			array_2_disk( FBP_MED_FILTER_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, FBP_median_filtered_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );		
		}
		//cudaFree(FBP_image_filtered_d);
	}	
	// Generate FBP hull by thresholding FBP image
	FBP_image_2_hull();

	// Discard FBP image unless it is to be used as the initial iterate x_0 in iterative image reconstruction
	if( X_0 != FBP_IMAGE && X_0 != HYBRID )
		free(FBP_image_h);

	sprintf(print_statement, "Filtered backprojection complete.");		
	print_colored_text( print_statement, LIGHT, RED );				
}
void filter()
{
	//char statement[] = "Filtering the sinogram...";	
	sprintf( print_statement, "Filtering the sinogram...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
			
	sinogram_filtered_h = (float*) calloc( NUM_BINS, sizeof(float) );
	if( sinogram_filtered_h == NULL )
	{
		puts("ERROR: Memory allocation for sinogram_filtered_h failed.");
		exit(1);
	}
	cudaMalloc((void**) &sinogram_filtered_d, SIZE_BINS_FLOAT);
	cudaMemcpy( sinogram_filtered_d, sinogram_filtered_h, SIZE_BINS_FLOAT, cudaMemcpyHostToDevice);

	dim3 dimBlock( T_BINS );
	dim3 dimGrid( V_BINS, ANGULAR_BINS );   	
	filter_GPU<<< dimGrid, dimBlock >>>( sinogram_d, sinogram_filtered_d );
}
__global__ void filter_GPU( float* sinogram, float* sinogram_filtered )
{		
	int v_bin = blockIdx.x, angle_bin = blockIdx.y, t_bin = threadIdx.x;
	int t_bin_ref, t_bin_sep, strip_index; 
	double filtered, t, scale_factor;
	double v = ( v_bin - V_BINS/2 ) * V_BIN_SIZE + V_BIN_SIZE/2.0;
	
	// Loop over strips for this strip
	for( t_bin_ref = 0; t_bin_ref < T_BINS; t_bin_ref++ )
	{
		t = ( t_bin_ref - T_BINS/2 ) * T_BIN_SIZE + T_BIN_SIZE/2.0;
		t_bin_sep = t_bin - t_bin_ref;
		// scale_factor = r . path = cos(theta_{r,path})
		scale_factor = SOURCE_RADIUS / sqrt( SOURCE_RADIUS * SOURCE_RADIUS + t * t + v * v );
		switch( FBP_FILTER )
		{
			case NONE: 
				break;
			case RAM_LAK:
				if( t_bin_sep == 0 )
					filtered = 1.0 / ( 4.0 * pow( RAM_LAK_TAU, 2.0 ) );
				else if( t_bin_sep % 2 == 0 )
					filtered = 0;
				else
					filtered = -1.0 / ( pow( RAM_LAK_TAU * PI * t_bin_sep, 2.0 ) );	
				break;
			case SHEPP_LOGAN:
				//filtered = pow( pow(T_BIN_SIZE * PI, 2.0) * ( 1.0 - pow(2 * t_bin_sep, 2.0) ), -1.0 );
				filtered = 1/((T_BIN_SIZE * PI*T_BIN_SIZE * PI) * ( 1.0 - (2 * t_bin_sep*2 * t_bin_sep) ));
		}
		strip_index = ( v_bin * ANGULAR_BINS * T_BINS ) + ( angle_bin * T_BINS );
		sinogram_filtered[strip_index + t_bin] += T_BIN_SIZE * sinogram[strip_index + t_bin_ref] * filtered * scale_factor;
	}
}
void backprojection()
{
	//// Check that we don't have any corruptions up until now
	//for( unsigned int i = 0; i < NUM_BINS; i++ )
	//	if( sinogram_filtered_h[i] != sinogram_filtered_h[i] )
	//		printf("We have a nan in bin #%d\n", i);

	double delta = GANTRY_ANGLE_INTERVAL * ANGLE_TO_RADIANS;
	int voxel;
	double x, y, z;
	double u, t, v;
	double detector_number_t, detector_number_v;
	double eta, epsilon;
	double scale_factor;
	int t_bin, v_bin, bin, bin_below;
	// Loop over the voxels
	for( int slice = 0; slice < SLICES; slice++ )
	{
		for( int column = 0; column < COLUMNS; column++ )
		{

			for( int row = 0; row < ROWS; row++ )
			{
				voxel = column +  ( row * COLUMNS ) + ( slice * COLUMNS * ROWS);
				x = -RECON_CYL_RADIUS + ( column + 0.5 )* VOXEL_WIDTH;
				y = RECON_CYL_RADIUS - (row + 0.5) * VOXEL_HEIGHT;
				z = -RECON_CYL_HEIGHT / 2.0 + (slice + 0.5) * SLICE_THICKNESS;
				// If the voxel is outside the cylinder defining the reconstruction volume, set RSP to air
				if( ( x * x + y * y ) > ( RECON_CYL_RADIUS * RECON_CYL_RADIUS ) )
					FBP_image_h[voxel] = RSP_AIR;							
				else
				{	  
					// Sum over projection angles
					for( int angle_bin = 0; angle_bin < ANGULAR_BINS; angle_bin++ )
					{
						// Rotate the pixel position to the beam-detector coordinate system
						u = x * cos( angle_bin * delta ) + y * sin( angle_bin * delta );
						t = -x * sin( angle_bin * delta ) + y * cos( angle_bin * delta );
						v = z;

						// Project to find the detector number
						detector_number_t = ( t - u *( t / ( SOURCE_RADIUS + u ) ) ) / T_BIN_SIZE + T_BINS/2.0;
						t_bin = int( detector_number_t);
						if( t_bin > detector_number_t )
							t_bin -= 1;
						eta = detector_number_t - t_bin;

						// Now project v to get detector number in v axis
						detector_number_v = ( v - u * ( v / ( SOURCE_RADIUS + u ) ) ) / V_BIN_SIZE + V_BINS/2.0;
						v_bin = int( detector_number_v);
						if( v_bin > detector_number_v )
							v_bin -= 1;
						epsilon = detector_number_v - v_bin;

						// Calculate the fan beam scaling factor
						scale_factor = pow( SOURCE_RADIUS / ( SOURCE_RADIUS + u ), 2 );
		  
						// Compute the back-projection
						bin = t_bin + angle_bin * T_BINS + v_bin * ANGULAR_BINS * T_BINS;
						bin_below = bin + ( ANGULAR_BINS * T_BINS );

						// If in last v_vin, there is no bin below so only use adjacent bins
						if( v_bin == V_BINS - 1 || ( bin < 0 ) )
							FBP_image_h[voxel] += scale_factor * ( ( ( 1 - eta ) * sinogram_filtered_h[bin] ) + ( eta * sinogram_filtered_h[bin + 1] ) ) ;
					/*	if( t_bin < T_BINS - 1 )
								FBP_image_h[voxel] += scale_factor * ( ( ( 1 - eta ) * sinogram_filtered_h[bin] ) + ( eta * sinogram_filtered_h[bin + 1] ) );
							if( v_bin < V_BINS - 1 )
								FBP_image_h[voxel] += scale_factor * ( ( ( 1 - epsilon ) * sinogram_filtered_h[bin] ) + ( epsilon * sinogram_filtered_h[bin_below] ) );
							if( t_bin == T_BINS - 1 && v_bin == V_BINS - 1 )
								FBP_image_h[voxel] += scale_factor * sinogram_filtered_h[bin];*/
						else 
						{
							// Technically this is to be multiplied by delta as well, but since delta is constant, it is more accurate numerically to multiply result by delta instead
							FBP_image_h[voxel] += scale_factor * ( ( 1 - eta ) * ( 1 - epsilon ) * sinogram_filtered_h[bin] 
							+ eta * ( 1 - epsilon ) * sinogram_filtered_h[bin + 1]
							+ ( 1 - eta ) * epsilon * sinogram_filtered_h[bin_below]
							+ eta * epsilon * sinogram_filtered_h[bin_below + 1] );
						} 
					}
					FBP_image_h[voxel] *= delta;
				}
			}
		}
	}
}
__global__ void backprojection_GPU( float* sinogram_filtered, float* FBP_image )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = slice * COLUMNS * ROWS + row * COLUMNS + column;	
	if ( voxel < NUM_VOXELS )
	{
		double delta = GANTRY_ANGLE_INTERVAL * ANGLE_TO_RADIANS;
		double u, t, v;
		double detector_number_t, detector_number_v;
		double eta, epsilon;
		double scale_factor;
		int t_bin, v_bin, bin;
		double x = -RECON_CYL_RADIUS + ( column + 0.5 )* VOXEL_WIDTH;
		double y = RECON_CYL_RADIUS - (row + 0.5) * VOXEL_HEIGHT;
		double z = -RECON_CYL_HEIGHT / 2.0 + (slice + 0.5) * SLICE_THICKNESS;

		//// If the voxel is outside a cylinder contained in the reconstruction volume, set to air
		if( ( x * x + y * y ) > ( RECON_CYL_RADIUS * RECON_CYL_RADIUS ) )
			FBP_image[( slice * COLUMNS * ROWS) + ( row * COLUMNS ) + column] = RSP_AIR;							
		else
		{	  
			// Sum over projection angles
			for( int angle_bin = 0; angle_bin < ANGULAR_BINS; angle_bin++ )
			{
				// Rotate the pixel position to the beam-detector coordinate system
				u = x * cos( angle_bin * delta ) + y * sin( angle_bin * delta );
				t = -x * sin( angle_bin * delta ) + y * cos( angle_bin * delta );
				v = z;

				// Project to find the detector number
				detector_number_t = ( t - u *( t / ( SOURCE_RADIUS + u ) ) ) / T_BIN_SIZE + T_BINS/2.0;
				t_bin = int( detector_number_t);
				if( t_bin > detector_number_t )
					t_bin -= 1;
				eta = detector_number_t - t_bin;

				// Now project v to get detector number in v axis
				detector_number_v = ( v - u * ( v / ( SOURCE_RADIUS + u ) ) ) / V_BIN_SIZE + V_BINS/2.0;
				v_bin = int( detector_number_v);
				if( v_bin > detector_number_v )
					v_bin -= 1;
				epsilon = detector_number_v - v_bin;

				// Calculate the fan beam scaling factor
				scale_factor = pow( SOURCE_RADIUS / ( SOURCE_RADIUS + u ), 2 );
		  
				//bin_num[i] = t_bin + angle_bin * T_BINS + v_bin * T_BINS * ANGULAR_BINS;
				// Compute the back-projection
				bin = t_bin + angle_bin * T_BINS + v_bin * ANGULAR_BINS * T_BINS;
				// not sure why this won't compile without calculating the index ahead of time instead inside []s
				//int index = ANGULAR_BINS * T_BINS;

				//if( ( ( bin + ANGULAR_BINS * T_BINS + 1 ) >= NUM_BINS ) || ( bin < 0 ) );
				if( v_bin == V_BINS - 1 || ( bin < 0 ) )
					FBP_image[voxel] += scale_factor * ( ( ( 1 - eta ) * sinogram_filtered[bin] ) + ( eta * sinogram_filtered[bin + 1] ) ) ;
					//printf("The bin selected for this voxel does not exist!\n Slice: %d\n Column: %d\n Row: %d\n", slice, column, row);
				else 
				{
					// not sure why this won't compile without calculating the index ahead of time instead inside []s
					/*FBP_image[voxel] += delta * ( ( 1 - eta ) * ( 1 - epsilon ) * sinogram_filtered[bin] 
					+ eta * ( 1 - epsilon ) * sinogram_filtered[bin + 1]
					+ ( 1 - eta ) * epsilon * sinogram_filtered[bin + ANGULAR_BINS * T_BINS]
					+ eta * epsilon * sinogram_filtered[bin + ANGULAR_BINS * T_BINS + 1] ) * scale_factor;*/

					// Multilpying by the gantry angle interval for each gantry angle is equivalent to multiplying the final answer by 2*PI and is better numerically
					// so multiplying by delta each time should be replaced by FBP_image_h[voxel] *= 2 * PI after all contributions have been made, which is commented out below
					FBP_image[voxel] += scale_factor * ( ( 1 - eta ) * ( 1 - epsilon ) * sinogram_filtered[bin] 
					+ eta * ( 1 - epsilon ) * sinogram_filtered[bin + 1]
					+ ( 1 - eta ) * epsilon * sinogram_filtered[bin + ( ANGULAR_BINS * T_BINS)]
					+ eta * epsilon * sinogram_filtered[bin + ( ANGULAR_BINS * T_BINS) + 1] );
				}				
			}
			FBP_image[voxel] *= delta; 
		}
	}
}
void FBP_image_2_hull()
{
	//char statement[] = "Performing thresholding on FBP image to generate FBP hull...";		
	sprintf( print_statement, "Performing thresholding on FBP image to generate FBP hull...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
	
	FBP_hull_h = (bool*) calloc( COLUMNS * ROWS * SLICES, sizeof(bool) );
	initialize_hull( FBP_hull_h, FBP_hull_d );
	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   
	FBP_image_2_hull_GPU<<< dimGrid, dimBlock >>>( FBP_image_d, FBP_hull_d );	
	cudaMemcpy( FBP_hull_h, FBP_hull_d, SIZE_IMAGE_BOOL, cudaMemcpyDeviceToHost );
	
	if( WRITE_FBP_HULL )
		array_2_disk( FBP_HULL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, FBP_hull_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );

	if( MLP_HULL != FBP_HULL)	
		free(FBP_hull_h);
	
	cudaFree(FBP_hull_d);
	cudaFree(FBP_image_d);
}
__global__ void FBP_image_2_hull_GPU( float* FBP_image, bool* FBP_hull )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = slice * COLUMNS * ROWS + row * COLUMNS + column; 
	double x = -RECON_CYL_RADIUS + ( column + 0.5 )* VOXEL_WIDTH;
	double y = RECON_CYL_RADIUS - (row + 0.5) * VOXEL_HEIGHT;
	double d_squared = pow(x, 2) + pow(y, 2);
	if(FBP_image[voxel] > FBP_HULL_THRESHOLD && (d_squared < pow(RECON_CYL_RADIUS, 2) ) ) 
		FBP_hull[voxel] = true; 
	else
		FBP_hull[voxel] = false; 
}
/******************************w22234567*****************************************************************************************************************************************************************************************/
/*************************************************************************************************** Hull-Detection ****************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void hull_detection( const int histories_2_process)
{
	if( SC_ON  ) 
		SC( histories_2_process );		
	if( MSC_ON )
		MSC( histories_2_process );
	if( SM_ON )
		SM( histories_2_process );   
}
__global__ void carve_differences( int* carve_differences, int* image )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = column + row * COLUMNS + slice * COLUMNS * ROWS;
	if( (row != 0) && (row != ROWS - 1) && (column != 0) && (column != COLUMNS - 1) )
	{
		int difference, max_difference = 0;
		for( int current_row = row - 1; current_row <= row + 1; current_row++ )
		{
			for( int current_column = column - 1; current_column <= column + 1; current_column++ )
			{
				difference = image[voxel] - image[current_column + current_row * COLUMNS + slice * COLUMNS * ROWS];
				if( difference > max_difference )
					max_difference = difference;
			}
		}
		carve_differences[voxel] = max_difference;
	}
}
/***********************************************************************************************************************************************************************************************************************/
void hull_initializations()
{		
	if( SC_ON )
		initialize_hull( SC_hull_h, SC_hull_d );
	if( MSC_ON )
		initialize_hull( MSC_counts_h, MSC_counts_d );
	if( SM_ON )
		initialize_hull( SM_counts_h, SM_counts_d );
}
template<typename T> void initialize_hull( T*& hull_h, T*& hull_d )
{
	/* Allocate memory and initialize hull on the GPU.  Use the image and reconstruction cylinder configurations to determine the location of the perimeter of  */
	/* the reconstruction cylinder, which is centered on the origin (center) of the image.  Assign voxels inside the perimeter of the reconstruction volume */
	/* the value 1 and those outside 0.																														*/

	int image_size = NUM_VOXELS * sizeof(T);
	cudaMalloc((void**) &hull_d, image_size );

	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   
	initialize_hull_GPU<<< dimGrid, dimBlock >>>( hull_d );	
}
template<typename T> __global__ void initialize_hull_GPU( T* hull )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = column + ( row * COLUMNS ) + ( slice * COLUMNS * ROWS );
	double x = ( column - COLUMNS/2 + 0.5) * VOXEL_WIDTH;
	double y = ( ROWS/2 - row - 0.5) * VOXEL_HEIGHT;
	if( pow(x, 2) + pow(y, 2) < pow(RECON_CYL_RADIUS, 2) )
		hull[voxel] = 1;
	else
		hull[voxel] = 0;
}
void SC( const int num_histories )
{
	dim3 dimBlock(THREADS_PER_BLOCK);
	dim3 dimGrid( (int)( num_histories / THREADS_PER_BLOCK ) + 1 );
	SC_GPU<<<dimGrid, dimBlock>>>
	(
		num_histories, SC_hull_d, bin_num_d, missed_recon_volume_d, WEPL_d,
		x_entry_d, y_entry_d, z_entry_d, x_exit_d, y_exit_d, z_exit_d
	);
	//pause_execution();
}
__global__ void SC_GPU
( 
	const int num_histories, bool* SC_hull, int* bin_num, bool* missed_recon_volume, float* WEPL,
	float* x_entry, float* y_entry, float* z_entry, float* x_exit, float* y_exit, float* z_exit
)
{// 15 doubles, 11 integers, 2 booleans
	int i = threadIdx.x + blockIdx.x * THREADS_PER_BLOCK;
	if( (i < num_histories) && !missed_recon_volume[i] && (WEPL[i] <= SC_UPPER_THRESHOLD) && (WEPL[i] >= SC_LOWER_THRESHOLD) )
	{
		/********************************************************************************************/
		/************************** Path Characteristic Parameters **********************************/
		/********************************************************************************************/
		int x_move_direction, y_move_direction, z_move_direction;
		double dy_dx, dz_dx, dz_dy, dx_dy, dx_dz, dy_dz;
		/********************************************************************************************/
		/**************************** Status Tracking Information ***********************************/
		/********************************************************************************************/
		double x = x_entry[i], y = y_entry[i], z = z_entry[i];
		double x_to_go, y_to_go, z_to_go;		
		//double x_extension, y_extension;	
		int voxel_x, voxel_y, voxel_z, voxel;
		int voxel_x_out, voxel_y_out, voxel_z_out, voxel_out; 
		bool end_walk;
		//bool debug_run = false;
		/********************************************************************************************/
		/******************** Initial Conditions and Movement Characteristics ***********************/
		/********************************************************************************************/
		x_move_direction = ( x_entry[i] <= x_exit[i] ) - ( x_entry[i] >= x_exit[i] );
		y_move_direction = ( y_entry[i] <= y_exit[i] ) - ( y_entry[i] >= y_exit[i] );
		z_move_direction = ( z_entry[i] <= z_exit[i] ) - ( z_entry[i] >= z_exit[i] );		

		voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x_entry[i], VOXEL_WIDTH );
		voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_entry[i], VOXEL_HEIGHT );
		voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, z_entry[i], VOXEL_THICKNESS );		
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;

		x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE,	x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH,	 voxel_x );
		y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE,	y, Y_INCREASING_DIRECTION,  y_move_direction, VOXEL_HEIGHT,	 voxel_y );
		z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE,	z, Z_INCREASING_DIRECTION,  z_move_direction, VOXEL_THICKNESS, voxel_z );				
		/********************************************************************************************/
		/***************************** Path and Walk Information ************************************/
		/********************************************************************************************/
		// Slopes corresponging to each possible direction/reference.  Explicitly calculated inverses to avoid 1/# calculations later
		dy_dx = ( y_exit[i] - y_entry[i] ) / ( x_exit[i] - x_entry[i] );
		dz_dx = ( z_exit[i] - z_entry[i] ) / ( x_exit[i] - x_entry[i] );
		dz_dy = ( z_exit[i] - z_entry[i] ) / ( y_exit[i] - y_entry[i] );
		dx_dy = ( x_exit[i] - x_entry[i] ) / ( y_exit[i] - y_entry[i] );
		dx_dz = ( x_exit[i] - x_entry[i] ) / ( z_exit[i] - z_entry[i] );
		dy_dz = ( y_exit[i] - y_entry[i] ) / ( z_exit[i] - z_entry[i] );
		/********************************************************************************************/
		/************************* Initialize and Check Exit Conditions *****************************/
		/********************************************************************************************/
		voxel_x_out = calculate_voxel_GPU( X_ZERO_COORDINATE, x_exit[i], VOXEL_WIDTH );
		voxel_y_out = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_exit[i], VOXEL_HEIGHT );
		voxel_z_out = calculate_voxel_GPU( Z_ZERO_COORDINATE, z_exit[i], VOXEL_THICKNESS );
		voxel_out = voxel_x_out + voxel_y_out * COLUMNS + voxel_z_out * COLUMNS * ROWS;

		end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
		if( !end_walk )
			SC_hull[voxel] = 0;
		/********************************************************************************************/
		/*********************************** Voxel Walk Routine *************************************/
		/********************************************************************************************/
		if( z_move_direction != 0 )
		{
			//printf("z_exit[i] != z_entry[i]\n");
			while( !end_walk )
			{
				take_3D_step_GPU
				( 
					x_move_direction, y_move_direction, z_move_direction,
					dy_dx, dz_dx, dz_dy, 
					dx_dy, dx_dz, dy_dz, 
					x_entry[i], y_entry[i], z_entry[i], 
					x, y, z, 
					voxel_x, voxel_y, voxel_z, voxel,
					x_to_go, y_to_go, z_to_go
				);
				//voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
				end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
				if( !end_walk )
					SC_hull[voxel] = 0;
			}// end !end_walk 
		}
		else
		{
			//printf("z_exit[i] == z_entry[i]\n");
			while( !end_walk )
			{
				take_2D_step_GPU
				( 
					x_move_direction, y_move_direction, z_move_direction,
					dy_dx, dz_dx, dz_dy, 
					dx_dy, dx_dz, dy_dz, 
					x_entry[i], y_entry[i], z_entry[i], 
					x, y, z, 
					voxel_x, voxel_y, voxel_z, voxel,
					x_to_go, y_to_go, z_to_go
				);
				//voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
				end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
				if( !end_walk )
					SC_hull[voxel] = 0;
			}// end: while( !end_walk )
		}//end: else: z_start != z_end => z_start == z_end
	}// end: if( (i < num_histories) && !missed_recon_volume[i] && (WEPL[i] <= SC_THRESHOLD) )
}
/***********************************************************************************************************************************************************************************************************************/
void MSC( const int num_histories )
{
	dim3 dimBlock(THREADS_PER_BLOCK);
	dim3 dimGrid((int)(num_histories/THREADS_PER_BLOCK)+1);
	MSC_GPU<<<dimGrid, dimBlock>>>
	(
		num_histories, MSC_counts_d, bin_num_d, missed_recon_volume_d, WEPL_d,
		x_entry_d, y_entry_d, z_entry_d, x_exit_d, y_exit_d, z_exit_d
	);
}
__global__ void MSC_GPU
( 
	const int num_histories, int* MSC_counts, int* bin_num, bool* missed_recon_volume, float* WEPL,
	float* x_entry, float* y_entry, float* z_entry, float* x_exit, float* y_exit, float* z_exit
)
{
	int i = threadIdx.x + blockIdx.x * THREADS_PER_BLOCK;
	if( (i < num_histories) && !missed_recon_volume[i] && (WEPL[i] <= MSC_UPPER_THRESHOLD) && (WEPL[i] >= MSC_LOWER_THRESHOLD) )
	{
		/********************************************************************************************/
		/************************** Path Characteristic Parameters **********************************/
		/********************************************************************************************/
		int x_move_direction, y_move_direction, z_move_direction;
		double dy_dx, dz_dx, dz_dy, dx_dy, dx_dz, dy_dz;
		/********************************************************************************************/
		/**************************** Status Tracking Information ***********************************/
		/********************************************************************************************/
		double x = x_entry[i], y = y_entry[i], z = z_entry[i];
		double x_to_go, y_to_go, z_to_go;		
		//double x_extension, y_extension;	
		int voxel_x, voxel_y, voxel_z, voxel;
		int voxel_x_out, voxel_y_out, voxel_z_out, voxel_out; 
		bool end_walk;
		//bool debug_run = false;
		/********************************************************************************************/
		/******************** Initial Conditions and Movement Characteristics ***********************/
		/********************************************************************************************/
		x_move_direction = ( x_entry[i] <= x_exit[i] ) - ( x_entry[i] >= x_exit[i] );
		y_move_direction = ( y_entry[i] <= y_exit[i] ) - ( y_entry[i] >= y_exit[i] );
		z_move_direction = ( z_entry[i] <= z_exit[i] ) - ( z_entry[i] >= z_exit[i] );		

		voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x_entry[i], VOXEL_WIDTH );
		voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_entry[i], VOXEL_HEIGHT );
		voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, z_entry[i], VOXEL_THICKNESS );		
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;

		x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE,	x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH,	 voxel_x );
		y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE,	y, Y_INCREASING_DIRECTION,  y_move_direction, VOXEL_HEIGHT,	 voxel_y );
		z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE,	z, Z_INCREASING_DIRECTION,  z_move_direction, VOXEL_THICKNESS, voxel_z );				
		/********************************************************************************************/
		/***************************** Path and Walk Information ************************************/
		/********************************************************************************************/
		// Slopes corresponging to each possible direction/reference.  Explicitly calculated inverses to avoid 1/# calculations later
		dy_dx = ( y_exit[i] - y_entry[i] ) / ( x_exit[i] - x_entry[i] );
		dz_dx = ( z_exit[i] - z_entry[i] ) / ( x_exit[i] - x_entry[i] );
		dz_dy = ( z_exit[i] - z_entry[i] ) / ( y_exit[i] - y_entry[i] );
		dx_dy = ( x_exit[i] - x_entry[i] ) / ( y_exit[i] - y_entry[i] );
		dx_dz = ( x_exit[i] - x_entry[i] ) / ( z_exit[i] - z_entry[i] );
		dy_dz = ( y_exit[i] - y_entry[i] ) / ( z_exit[i] - z_entry[i] );
		/********************************************************************************************/
		/************************* Initialize and Check Exit Conditions *****************************/
		/********************************************************************************************/
		voxel_x_out = calculate_voxel_GPU( X_ZERO_COORDINATE, x_exit[i], VOXEL_WIDTH );
		voxel_y_out = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_exit[i], VOXEL_HEIGHT );
		voxel_z_out = calculate_voxel_GPU( Z_ZERO_COORDINATE, z_exit[i], VOXEL_THICKNESS );
		voxel_out = voxel_x_out + voxel_y_out * COLUMNS + voxel_z_out * COLUMNS * ROWS;

		end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
		if( !end_walk )
			atomicAdd(&MSC_counts[voxel], 1);
		/********************************************************************************************/
		/*********************************** Voxel Walk Routine *************************************/
		/********************************************************************************************/
		if( z_move_direction != 0 )
		{
			//printf("z_exit[i] != z_entry[i]\n");
			while( !end_walk )
			{
				take_3D_step_GPU
				( 
					x_move_direction, y_move_direction, z_move_direction,
					dy_dx, dz_dx, dz_dy, dx_dy, dx_dz, dy_dz, 
					x_entry[i], y_entry[i], z_entry[i], 
					x, y, z, 
					voxel_x, voxel_y, voxel_z, voxel,
					x_to_go, y_to_go, z_to_go
				);
				end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
				if( !end_walk )
					atomicAdd(&MSC_counts[voxel], 1);
			}// end !end_walk 
		}
		else
		{
			//printf("z_exit[i] == z_entry[i]\n");
			while( !end_walk )
			{
				take_2D_step_GPU
				( 
					x_move_direction, y_move_direction, z_move_direction,
					dy_dx, dz_dx, dz_dy, dx_dy, dx_dz, dy_dz, 
					x_entry[i], y_entry[i], z_entry[i], 
					x, y, z, 
					voxel_x, voxel_y, voxel_z, voxel,
					x_to_go, y_to_go, z_to_go
				);				
				end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
				if( !end_walk )
					atomicAdd(&MSC_counts[voxel], 1);
			}// end: while( !end_walk )
		}//end: else: z_start != z_end => z_start == z_end
	}// end: if( (i < num_histories) && !missed_recon_volume[i] && (WEPL[i] <= MSC_UPPER_THRESHOLD) )
}
void MSC_edge_detection()
{
	//puts("Performing edge-detection on MSC_counts...");
	//char statement[256];
	sprintf( print_statement, "Performing edge-detection on MSC_counts...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
	
	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   
	//int* MSC_counts_output_d;
	//cudaMalloc((void**) &MSC_counts_output_d, SIZE_IMAGE_INT );
	//cudaMemcpy(MSC_counts_output_d,  MSC_counts_h, SIZE_IMAGE_INT, cudaMemcpyHostToDevice);
		
	MSC_edge_detection_GPU<<< dimGrid, dimBlock >>>( MSC_counts_d );
	//MSC_edge_detection_GPU<<< dimGrid, dimBlock >>>( MSC_counts_d, MSC_counts_output_d );
	
	//cudaMemcpy(MSC_counts_h,  MSC_counts_output_d, SIZE_IMAGE_INT, cudaMemcpyDeviceToHost);
	//cudaFree(MSC_counts_d);
	//MSC_counts_d = MSC_counts_output_d;
	//cudaFree(MSC_counts_output_d);
	sprintf( print_statement, "MSC hull-detection and edge-detection complete.");	
	print_colored_text( print_statement, LIGHT, RED );	
}
__global__ void MSC_edge_detection_GPU( int* MSC_counts )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = column + row * COLUMNS + slice * COLUMNS * ROWS;
	float x = ( column - COLUMNS/2 + 0.5 ) * VOXEL_WIDTH;
	float y = ( ROWS/2 - row - 0.5 ) * VOXEL_HEIGHT;
	int difference, max_difference = 0;
	if( (row != 0) && (row != ROWS - 1) && (column != 0) && (column != COLUMNS - 1) )
	{		
		for( int current_row = row - 1; current_row <= row + 1; current_row++ )
		{
			for( int current_column = column - 1; current_column <= column + 1; current_column++ )
			{
				difference = MSC_counts[voxel] - MSC_counts[current_column + current_row * COLUMNS + slice * COLUMNS * ROWS];
				if( difference > max_difference )
					max_difference = difference;
			}
		}
	}
	__syncthreads();
	if( max_difference > MSC_DIFF_THRESH || MSC_counts[voxel] > MSC_DIFF_THRESH)
		MSC_counts[voxel] = 0;
	//if( MSC_counts[voxel] > MSC_DIFF_THRESH)
	//	MSC_counts[voxel] = 0;
	//if( max_difference > MSC_DIFF_THRESH )
	//	MSC_counts[voxel] = 0;
	else
		MSC_counts[voxel] = 1;
	if( pow(x, 2) + pow(y, 2) >= pow(RECON_CYL_RADIUS - max(VOXEL_WIDTH, VOXEL_HEIGHT)/2, 2 ) )
		MSC_counts[voxel] = 0;

}
__global__ void MSC_edge_detection_GPU( int* MSC_counts, int* MSC_counts_output )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = column + row * COLUMNS + slice * COLUMNS * ROWS;
	float x = ( column - COLUMNS/2 + 0.5 ) * VOXEL_WIDTH;
	float y = ( ROWS/2 - row - 0.5 ) * VOXEL_HEIGHT;
	int difference, max_difference = 0;
	if( (row != 0) && (row != ROWS - 1) && (column != 0) && (column != COLUMNS - 1) )
	{		
		for( int current_row = row - 1; current_row <= row + 1; current_row++ )
		{
			for( int current_column = column - 1; current_column <= column + 1; current_column++ )
			{
				difference = MSC_counts[voxel] - MSC_counts[current_column + current_row * COLUMNS + slice * COLUMNS * ROWS];
				if( difference > max_difference )
					max_difference = difference;
			}
		}
	}
	__syncthreads();
	if( max_difference > MSC_DIFF_THRESH )
		MSC_counts_output[voxel] = 0;
	else
		MSC_counts_output[voxel] = 1;
	if( pow(x, 2) + pow(y, 2) >= pow(RECON_CYL_RADIUS - max(VOXEL_WIDTH, VOXEL_HEIGHT)/2, 2 ) )
		MSC_counts_output[voxel] = 0;

}
/***********************************************************************************************************************************************************************************************************************/
void SM( const int num_histories)
{
	dim3 dimBlock(THREADS_PER_BLOCK);
	dim3 dimGrid( (int)( num_histories / THREADS_PER_BLOCK ) + 1 );
	SM_GPU <<< dimGrid, dimBlock >>>
	(
		num_histories, SM_counts_d, bin_num_d, missed_recon_volume_d, WEPL_d,
		x_entry_d, y_entry_d, z_entry_d, x_exit_d, y_exit_d, z_exit_d
	);
}
__global__ void SM_GPU
( 
	const int num_histories, int* SM_counts, int* bin_num, bool* missed_recon_volume, float* WEPL,
	float* x_entry, float* y_entry, float* z_entry, float* x_exit, float* y_exit, float* z_exit
)
{
	int i = threadIdx.x + blockIdx.x * THREADS_PER_BLOCK;
	if( (i < num_histories) && !missed_recon_volume[i] && (WEPL[i] >= SM_LOWER_THRESHOLD) )
	{
		/********************************************************************************************/
		/************************** Path Characteristic Parameters **********************************/
		/********************************************************************************************/
		int x_move_direction, y_move_direction, z_move_direction;
		double dy_dx, dz_dx, dz_dy, dx_dy, dx_dz, dy_dz;
		/********************************************************************************************/
		/**************************** Status Tracking Information ***********************************/
		/********************************************************************************************/
		double x = x_entry[i], y = y_entry[i], z = z_entry[i];
		double x_to_go, y_to_go, z_to_go;		
		//double x_extension, y_extension;	
		int voxel_x, voxel_y, voxel_z, voxel;
		int voxel_x_out, voxel_y_out, voxel_z_out, voxel_out; 
		bool end_walk;
		//bool debug_run = false;
		/********************************************************************************************/
		/******************** Initial Conditions and Movement Characteristics ***********************/
		/********************************************************************************************/
		x_move_direction = ( x_entry[i] <= x_exit[i] ) - ( x_entry[i] >= x_exit[i] );
		y_move_direction = ( y_entry[i] <= y_exit[i] ) - ( y_entry[i] >= y_exit[i] );
		z_move_direction = ( z_entry[i] <= z_exit[i] ) - ( z_entry[i] >= z_exit[i] );		

		voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x_entry[i], VOXEL_WIDTH );
		voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_entry[i], VOXEL_HEIGHT );
		voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, z_entry[i], VOXEL_THICKNESS );		
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;

		x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE,	x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH,	 voxel_x );
		y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE,	y, Y_INCREASING_DIRECTION,  y_move_direction, VOXEL_HEIGHT,	 voxel_y );
		z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE,	z, Z_INCREASING_DIRECTION,  z_move_direction, VOXEL_THICKNESS, voxel_z );				
		/********************************************************************************************/
		/***************************** Path and Walk Information ************************************/
		/********************************************************************************************/
		// Slopes corresponging to each possible direction/reference.  Explicitly calculated inverses to avoid 1/# calculations later
		dy_dx = ( y_exit[i] - y_entry[i] ) / ( x_exit[i] - x_entry[i] );
		dz_dx = ( z_exit[i] - z_entry[i] ) / ( x_exit[i] - x_entry[i] );
		dz_dy = ( z_exit[i] - z_entry[i] ) / ( y_exit[i] - y_entry[i] );
		dx_dy = ( x_exit[i] - x_entry[i] ) / ( y_exit[i] - y_entry[i] );
		dx_dz = ( x_exit[i] - x_entry[i] ) / ( z_exit[i] - z_entry[i] );
		dy_dz = ( y_exit[i] - y_entry[i] ) / ( z_exit[i] - z_entry[i] );
		/********************************************************************************************/
		/************************* Initialize and Check Exit Conditions *****************************/
		/********************************************************************************************/
		voxel_x_out = calculate_voxel_GPU( X_ZERO_COORDINATE, x_exit[i], VOXEL_WIDTH );
		voxel_y_out = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_exit[i], VOXEL_HEIGHT );
		voxel_z_out = calculate_voxel_GPU( Z_ZERO_COORDINATE, z_exit[i], VOXEL_THICKNESS );
		voxel_out = voxel_x_out + voxel_y_out * COLUMNS + voxel_z_out * COLUMNS * ROWS;

		end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
		if( !end_walk )
			atomicAdd(&SM_counts[voxel], 1);
		/********************************************************************************************/
		/*********************************** Voxel Walk Routine *************************************/
		/********************************************************************************************/
		if( z_move_direction != 0 )
		{
			//printf("z_exit[i] != z_entry[i]\n");
			while( !end_walk )
			{
				take_3D_step_GPU
				( 
					x_move_direction, y_move_direction, z_move_direction,
					dy_dx, dz_dx, dz_dy, dx_dy, dx_dz, dy_dz, 
					x_entry[i], y_entry[i], z_entry[i], 
					x, y, z, 
					voxel_x, voxel_y, voxel_z, voxel,
					x_to_go, y_to_go, z_to_go
				);
				end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
				if( !end_walk )
					atomicAdd(&SM_counts[voxel], 1);
			}// end !end_walk 
		}
		else
		{
			//printf("z_exit[i] == z_entry[i]\n");
			while( !end_walk )
			{
				take_2D_step_GPU
				( 
					x_move_direction, y_move_direction, z_move_direction,
					dy_dx, dz_dx, dz_dy, dx_dy, dx_dz, dy_dz, 
					x_entry[i], y_entry[i], z_entry[i], 
					x, y, z, 
					voxel_x, voxel_y, voxel_z, voxel,
					x_to_go, y_to_go, z_to_go
				);				
				end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
				if( !end_walk )
					atomicAdd(&SM_counts[voxel], 1);
			}// end: while( !end_walk )
		}//end: else: z_start != z_end => z_start == z_end
	}// end: if( (i < num_histories) && !missed_recon_volume[i] && (WEPL[i] <= MSC_UPPER_THRESHOLD) )
}
void SM_edge_detection()
{
	//char statement[] = "Performing edge-detection on SM_counts...";		
	sprintf( print_statement, "Performing edge-detection on SM_counts...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
	
	/*if( WRITE_SM_COUNTS )
	{
		cudaMemcpy(SM_counts_h,  SM_counts_d,	 SIZE_IMAGE_INT,   cudaMemcpyDeviceToHost);
		array_2_disk("SM_counts", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, SM_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, false );
	}*/

	int* SM_differences_h = (int*) calloc( NUM_VOXELS, sizeof(int) );
	int* SM_differences_d;	
	cudaMalloc((void**) &SM_differences_d, SIZE_IMAGE_INT );
	cudaMemcpy( SM_differences_d, SM_differences_h, SIZE_IMAGE_INT, cudaMemcpyHostToDevice );

	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   
	carve_differences<<< dimGrid, dimBlock >>>( SM_differences_d, SM_counts_d );
	
	cudaMemcpy( SM_differences_h, SM_differences_d, SIZE_IMAGE_INT, cudaMemcpyDeviceToHost );

	int* SM_thresholds_h = (int*) calloc( SLICES, sizeof(int) );
	int voxel;	
	int max_difference = 0;
	for( int slice = 0; slice < SLICES; slice++ )
	{
		for( int pixel = 0; pixel < COLUMNS * ROWS; pixel++ )
		{
			voxel = pixel + slice * COLUMNS * ROWS;
			if( SM_differences_h[voxel] > max_difference )
			{
				max_difference = SM_differences_h[voxel];
				SM_thresholds_h[slice] = SM_counts_h[voxel];
			}
		}
		if( DEBUG_TEXT_ON )
		{
			//printf( "Slice %d : The maximum space_model difference = %d and the space_model threshold = %d\n", slice, max_difference, SM_thresholds_h[slice] );
		}
		max_difference = 0;
	}

	int* SM_thresholds_d;
	unsigned int threshold_size = SLICES * sizeof(int);
	cudaMalloc((void**) &SM_thresholds_d, threshold_size );
	cudaMemcpy( SM_thresholds_d, SM_thresholds_h, threshold_size, cudaMemcpyHostToDevice );

	SM_edge_detection_GPU<<< dimGrid, dimBlock >>>( SM_counts_d, SM_thresholds_d);
	
	//puts("SM hull-detection and edge-detection complete.");
	sprintf(print_statement, "SM hull-detection and edge-detection complete.");		
	print_colored_text( print_statement, LIGHT, RED );	
	
	//cudaMemcpy(SM_counts_h,  SM_counts_d,	 SIZE_IMAGE_INT,   cudaMemcpyDeviceToHost);
	//cudaFree( SM_counts_d );
	cudaFree( SM_differences_d );
	cudaFree( SM_thresholds_d );

	free(SM_differences_h);
	free(SM_thresholds_h);
	
	/*if( WRITE_SM_HULL )
		array_2_disk("x_SM", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, SM_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	if( MLP_HULL != SM_HULL)
		free(SM_counts_h);	*/
}
__global__ void SM_edge_detection_GPU( int* SM_counts, int* SM_threshold )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	float x = ( column - COLUMNS/2 + 0.5 ) * VOXEL_WIDTH;
	float y = ( ROWS/2 - row - 0.5 ) * VOXEL_HEIGHT;
	int voxel = column + row * COLUMNS + slice * COLUMNS * ROWS;
	if( voxel < NUM_VOXELS )
	{
		if( SM_counts[voxel] > SM_SCALE_THRESHOLD * SM_threshold[slice] )
			SM_counts[voxel] = 1;
		else
			SM_counts[voxel] = 0;
		if( pow(x, 2) + pow(y, 2) >= pow(RECON_CYL_RADIUS - max(VOXEL_WIDTH, VOXEL_HEIGHT)/2, 2 ) )
			SM_counts[voxel] = 0;
	}
}
void SM_edge_detection_2()
{
	//char statement[] = "Performing edge-detection on SM_counts...";		
	sprintf( print_statement, "Performing edge-detection on SM_counts...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
	
	// Copy the space modeled image from the GPU to the CPU and write it to file.
	cudaMemcpy(SM_counts_h,  SM_counts_d,	 SIZE_IMAGE_INT,   cudaMemcpyDeviceToHost);
	//array_2_disk(SM_COUNTS_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, SM_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, false );

	int* SM_differences_h = (int*) calloc( NUM_VOXELS, sizeof(int) );
	int* SM_differences_d;
	cudaMalloc((void**) &SM_differences_d, SIZE_IMAGE_INT );
	cudaMemcpy( SM_differences_d, SM_differences_h, SIZE_IMAGE_INT, cudaMemcpyHostToDevice );

	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   

	carve_differences<<< dimGrid, dimBlock >>>( SM_differences_d, SM_counts_d );
	cudaMemcpy( SM_differences_h, SM_differences_d, SIZE_IMAGE_INT, cudaMemcpyDeviceToHost );

	int* SM_thresholds_h = (int*) calloc( SLICES, sizeof(int) );
	int voxel;	
	int max_difference = 0;
	for( int slice = 0; slice < SLICES; slice++ )
	{
		for( int pixel = 0; pixel < COLUMNS * ROWS; pixel++ )
		{
			voxel = pixel + slice * COLUMNS * ROWS;
			if( SM_differences_h[voxel] > max_difference )
			{
				max_difference = SM_differences_h[voxel];
				SM_thresholds_h[slice] = SM_counts_h[voxel];
			}
		}
		printf( "Slice %d : The maximum space_model difference = %d and the space_model threshold = %d\n", slice, max_difference, SM_thresholds_h[slice] );
		max_difference = 0;
	}

	int* SM_thresholds_d;
	unsigned int threshold_size = SLICES * sizeof(int);
	cudaMalloc((void**) &SM_thresholds_d, threshold_size );
	cudaMemcpy( SM_thresholds_d, SM_thresholds_h, threshold_size, cudaMemcpyHostToDevice );

	SM_edge_detection_GPU<<< dimGrid, dimBlock >>>( SM_counts_d, SM_thresholds_d);

	puts("SM hull-detection complete.  Writing results to disk...");

	cudaMemcpy(SM_counts_h,  SM_counts_d,	 SIZE_IMAGE_INT,   cudaMemcpyDeviceToHost);
	cudaFree( SM_counts_d );
	cudaFree( SM_differences_d );
	cudaFree( SM_thresholds_d );

	free(SM_differences_h);
	free(SM_thresholds_h);
	
	//if( WRITE_SM_HULL )
	 	//array_2_disk(SM_HULL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, SM_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	if( MLP_HULL != SM_HULL)
		free(SM_counts_h);	
}
__global__ void SM_edge_detection_GPU_2( int* SM_counts, int* SM_differences )
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = column + row * COLUMNS + slice * COLUMNS * ROWS;
	int difference, max_difference = 0;
	if( (row != 0) && (row != ROWS - 1) && (column != 0) && (column != COLUMNS - 1) )
	{
		for( int current_row = row - 1; current_row <= row + 1; current_row++ )
		{
			for( int current_column = column - 1; current_column <= column + 1; current_column++ )
			{
				difference = SM_counts[voxel] - SM_counts[current_column + current_row * COLUMNS + slice * COLUMNS * ROWS];
				if( difference > max_difference )
					max_difference = difference;
			}
		}
		SM_differences[voxel] = max_difference;
	}
	syncthreads();
	int slice_threshold;
	max_difference = 0;
	for( int pixel = 0; pixel < COLUMNS * ROWS; pixel++ )
	{
		voxel = pixel + slice * COLUMNS * ROWS;
		if( SM_differences[voxel] > max_difference )
		{
			max_difference = SM_differences[voxel];
			slice_threshold = SM_counts[voxel];
		}
	}
	syncthreads();
	float x = ( column - COLUMNS/2 + 0.5 ) * VOXEL_WIDTH;
	float y = ( ROWS/2 - row - 0.5 ) * VOXEL_HEIGHT;
	if( voxel < NUM_VOXELS )
	{
		if( SM_counts[voxel] > SM_SCALE_THRESHOLD * slice_threshold )
			SM_counts[voxel] = 1;
		else
			SM_counts[voxel] = 0;
		if( pow(x, 2) + pow(y, 2) >= pow(RECON_CYL_RADIUS - max(VOXEL_WIDTH, VOXEL_HEIGHT)/2, 2 ) )
			SM_counts[voxel] = 0;
	}
}
void hull_detection_finish()
{
	//char statement[] = "Finishing hull detection and writing resulting images to disk...";
	sprintf( print_statement, "Finishing hull detection and writing resulting images to disk...");		
	print_colored_text( print_statement, LIGHT, CYAN );
	if( SC_ON )
	{
		SC_hull_h = (bool*) calloc( NUM_VOXELS, sizeof(bool) );
		cudaMemcpy(SC_hull_h,  SC_hull_d, SIZE_IMAGE_BOOL, cudaMemcpyDeviceToHost);
		if( WRITE_SC_HULL )
		{
			//puts("Writing SC hull to disk...");
			sprintf(print_statement, "Writing SC hull to disk...");		
			print_colored_text( print_statement, LIGHT, CYAN );	
			array_2_disk(SC_HULL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, SC_hull_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
		}
		if( MLP_HULL != SC_HULL )
			free( SC_hull_h );
		cudaFree(SC_hull_d);
	}
	if( MSC_ON )
	{
		MSC_counts_h = (int*) calloc( NUM_VOXELS, sizeof(int) );
		if( WRITE_MSC_COUNTS )
		{		
			//puts("Writing MSC counts to disk...");		
			sprintf(print_statement, "Writing MSC counts to disk...");		
			print_colored_text( print_statement, LIGHT, CYAN );	
			cudaMemcpy(MSC_counts_h,  MSC_counts_d, SIZE_IMAGE_INT, cudaMemcpyDeviceToHost);
			array_2_disk(MSC_COUNTS_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MSC_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );	
		}
		if( WRITE_MSC_HULL || (MLP_HULL == MSC_HULL) )
		{
			MSC_edge_detection();
			cudaMemcpy(MSC_counts_h,  MSC_counts_d, SIZE_IMAGE_INT, cudaMemcpyDeviceToHost);
			if( WRITE_MSC_HULL )
			{
				//puts("Writing MSC hull to disk...");	
				sprintf(print_statement, "Writing MSC hull to disk...");		
				print_colored_text( print_statement, LIGHT, CYAN );	
				array_2_disk(MSC_HULL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MSC_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );	
			}
			cudaFree(MSC_counts_d);
		}
		if( MLP_HULL != MSC_HULL )
			free( MSC_counts_h );		
	}
	if( SM_ON )
	{
		SM_counts_h = (int*) calloc( NUM_VOXELS, sizeof(int) );
		if( WRITE_SM_COUNTS )
		{		
			//puts("Writing SM counts to disk...");
			sprintf(print_statement, "Writing SM counts to disk...");		
			print_colored_text( print_statement, LIGHT, CYAN );	
			cudaMemcpy(SM_counts_h,  SM_counts_d, SIZE_IMAGE_INT, cudaMemcpyDeviceToHost);
			array_2_disk(SM_COUNTS_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, SM_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );	
		}
		if( WRITE_SM_HULL || (MLP_HULL == SM_HULL) )
		{
			SM_edge_detection();
			cudaMemcpy(SM_counts_h,  SM_counts_d, SIZE_IMAGE_INT, cudaMemcpyDeviceToHost);
			if( WRITE_SM_HULL )
			{
				//puts("Writing SM hull to disk...");	
				sprintf(print_statement, "Writing SM hull to disk...");		
				print_colored_text( print_statement, LIGHT, CYAN );	
				array_2_disk(SM_HULL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, SM_counts_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );	
			}
			cudaFree(SM_counts_d);
		}
		if( MLP_HULL != SM_HULL )
			free( SM_counts_h );
	}
}
void hull_conversion_int_2_bool( int* int_hull )
{
	for( int voxel = 0; voxel < NUM_VOXELS; voxel++ )
	{
		if( int_hull[voxel] == 1 )
			hull_h[voxel] = true;
		else
			hull_h[voxel] = false;
	}
}
void hull_selection()
{
	//puts("Performing hull selection...");
	//char statement[256];
	sprintf(print_statement, "Performing hull selection...");	
	print_colored_text( print_statement, LIGHT, CYAN );	
			
	hull_h = (bool*) calloc( NUM_VOXELS, sizeof(bool) );
	switch( MLP_HULL )
	{
		case SC_HULL  : hull_h = SC_hull_h;																									break;
		case MSC_HULL : hull_conversion_int_2_bool( MSC_counts_h );																			break;
						// std::transform( MSC_counts_h, MSC_counts_h + NUM_VOXELS, MSC_counts_h, hull_h, std::multiplies<int> () );		break;
		case SM_HULL  : hull_conversion_int_2_bool( SM_counts_h );																			break;
						// std::transform( SM_counts_h,  SM_counts_h + NUM_VOXELS,  SM_counts_h,  hull_h, std::multiplies<int> () );		break;
		case FBP_HULL : hull_h = FBP_hull_h;								
	}

	if( WRITE_X_HULL )
	{
		//puts("Writing selected hull to disk...");
		sprintf(print_statement, "Writing selected hull to disk...");		
		print_colored_text( print_statement, LIGHT, CYAN );	
		array_2_disk(HULL_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, hull_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	}
	// Allocate memory for and transfer hull to the GPU
	cudaMalloc((void**) &hull_d, SIZE_IMAGE_BOOL );
	cudaMemcpy( hull_d, hull_h, SIZE_IMAGE_BOOL, cudaMemcpyHostToDevice );

	if( AVG_FILTER_HULL )
	{
		//puts("Filtering hull...");
		sprintf(print_statement, "Average filtering hull...");		
		print_colored_text( print_statement, LIGHT, CYAN );	
		averaging_filter( hull_h, hull_d, HULL_AVG_FILTER_RADIUS, true, HULL_AVG_FILTER_THRESHOLD );
		//puts("Hull Filtering complete");
		sprintf(print_statement, "Average filtering of hull complete");		
		print_colored_text( print_statement, LIGHT, RED );	
		if( WRITE_FILTERED_HULL )
		{
			sprintf(print_statement, "Writing average filtered hull to disk...");		
			print_colored_text( print_statement, LIGHT, CYAN );			
			//puts("Writing filtered hull to disk...");
			cudaMemcpy(hull_h, hull_d, SIZE_IMAGE_BOOL, cudaMemcpyDeviceToHost);
			array_2_disk( HULL_AVG_FILTER_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, hull_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
		}
	}
	sprintf(print_statement, "Hull selection complete.");		
	print_colored_text( print_statement, LIGHT, RED );			
}
/***********************************************************************************************************************************************************************************************************************/
template<typename H, typename D> void averaging_filter( H*& image_h, D*& image_d, int radius, bool perform_threshold, double threshold_value )
{
	//bool is_hull = ( typeid(bool) == typeid(D) );
	D* new_value_d;
	int new_value_size = NUM_VOXELS * sizeof(D);
	cudaMalloc(&new_value_d, new_value_size );

	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   
	averaging_filter_GPU<<< dimGrid, dimBlock >>>( image_d, new_value_d, radius, perform_threshold, threshold_value );
	//apply_averaging_filter_GPU<<< dimGrid, dimBlock >>>( image_d, new_value_d );
	//cudaFree(new_value_d);
	cudaFree(image_d);
	image_d = new_value_d;
}
template<typename D> __global__ void averaging_filter_GPU( D* image, D* new_value, int radius, bool perform_threshold, double threshold_value )
{
	int voxel_x = blockIdx.x;
	int voxel_y = blockIdx.y;	
	int voxel_z = threadIdx.x;
	int voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
	unsigned int left_edge = max( voxel_x - radius, 0 );
	unsigned int right_edge = min( voxel_x + radius, COLUMNS - 1);
	unsigned int top_edge = max( voxel_y - radius, 0 );
	unsigned int bottom_edge = min( voxel_y + radius, ROWS - 1);	
	int neighborhood_voxels = ( right_edge - left_edge + 1 ) * ( bottom_edge - top_edge + 1 );
	double sum_threshold = neighborhood_voxels * threshold_value;
	double sum = 0.0;
	// Determine neighborhood sum for voxels whose neighborhood is completely enclosed in image
	// Strip of size floor(AVG_FILTER_SIZE/2) around image perimeter must be ignored
	for( int column = left_edge; column <= right_edge; column++ )
		for( int row = top_edge; row <= bottom_edge; row++ )
			sum += image[column + (row * COLUMNS) + (voxel_z * COLUMNS * ROWS)];
	if( perform_threshold)
		new_value[voxel] = ( sum > sum_threshold );
	else
		new_value[voxel] = sum / neighborhood_voxels;
}
template<typename T> void median_filter_2D( T*& input_image, unsigned int radius )
{
	T* median_filtered_image = (T*) calloc( NUM_VOXELS, sizeof(T) );

	unsigned int neighborhood_voxels = (2*radius + 1 ) * (2*radius + 1 );
	unsigned int middle = neighborhood_voxels/2;
	unsigned int target_voxel, voxel;
	//T* neighborhood = (T*)calloc( neighborhood_voxels, sizeof(T));
	std::vector<T> neighborhood;
	for( unsigned int target_slice = 0; target_slice < SLICES; target_slice++ )
	{
		for( unsigned int target_column = radius; target_column < COLUMNS - radius; target_column++ )
		{
			for( unsigned int target_row = radius; target_row < ROWS - radius; target_row++ )
			{
				target_voxel = target_column + target_row * COLUMNS + target_slice * COLUMNS * ROWS;
				for( unsigned int column = target_column - radius; column <= target_column + radius; column++ )
				{
					for( unsigned int row = target_row - radius; row <=  target_row + radius; row++ )
					{
						voxel = column + row * COLUMNS + target_slice * COLUMNS * ROWS;
						neighborhood.push_back(input_image[voxel]);
						//neighborhood[i] = image_h[voxel2];
						//i++;
					}
				}
				std::sort( neighborhood.begin(), neighborhood.end());
				median_filtered_image[target_voxel] = neighborhood[middle];
				neighborhood.clear();
			}
		}
	}
	free(input_image);
	input_image = median_filtered_image;
	//input_image = (T*) calloc( NUM_VOXELS, sizeof(T) );
	//std::copy(median_filtered_image, median_filtered_image + NUM_VOXELS, input_image);
	

}
template<typename T> void median_filter_2D( T*& input_image, T*& median_filtered_image, unsigned int radius )
{
	std::copy(median_filtered_image, median_filtered_image + NUM_VOXELS, input_image);
	//T* median_filtered_image = (T*) calloc( configurations.NUM_VOXELS, sizeof(T) );

	unsigned int neighborhood_voxels = (2*radius + 1 ) * (2*radius + 1 );
	unsigned int middle = neighborhood_voxels/2;
	unsigned int target_voxel, voxel;
	//T* neighborhood = (T*)calloc( neighborhood_voxels, sizeof(T));
	std::vector<T> neighborhood;
	for( unsigned int target_slice = 0; target_slice < SLICES; target_slice++ )
	{
		for( unsigned int target_column = radius; target_column < COLUMNS - radius; target_column++ )
		{
			for( unsigned int target_row = radius; target_row < ROWS - radius; target_row++ )
			{
				target_voxel = target_column + target_row * COLUMNS + target_slice * COLUMNS * ROWS;
				for( unsigned int column = target_column - radius; column <= target_column + radius; column++ )
				{
					for( unsigned int row = target_row - radius; row <=  target_row + radius; row++ )
					{
						voxel = column + row * COLUMNS + target_slice * COLUMNS * ROWS;
						neighborhood.push_back(input_image[voxel]);
						//neighborhood[i] = image_h[voxel2];
						//i++;
					}
				}
				std::sort( neighborhood.begin(), neighborhood.end());
				median_filtered_image[target_voxel] = neighborhood[middle];
				neighborhood.clear();
			}
		}
	}
	//free(input_image);
	//input_image = (T*) calloc( configurations.NUM_VOXELS, sizeof(T) );
	//std::copy(median_filtered_image, median_filtered_image + NUM_VOXELS, input_image);
	//input_image = median_filtered_image;
}
template<typename D> __global__ void median_filter_GPU( D* image, D* new_value, int radius, bool perform_threshold, double threshold_value )
{
//	int voxel_x = blockIdx.x;
//	int voxel_y = blockIdx.y;	
//	int voxel_z = threadIdx.x;
//	int voxel = voxel_x + voxel_y * configurations->COLUMNS + voxel_z * configurations->COLUMNS * configurations->ROWS;
//	unsigned int left_edge = max( voxel_x - radius, 0 );
//	unsigned int right_edge = min( voxel_x + radius, configurations->COLUMNS - 1);
//	unsigned int top_edge = max( voxel_y - radius, 0 );
//	unsigned int bottom_edge = min( voxel_y + radius, configurations->ROWS - 1);	
//	int neighborhood_voxels = ( right_edge - left_edge + 1 ) * ( bottom_edge - top_edge + 1 );
//	double sum_threshold = neighborhood_voxels * threshold_value;
//	double sum = 0.0;
//	D new_element = image[voxel];
//	int middle = floor(neighborhood_voxels/2);
//
//	int count_up = 0;
//	int count_down = 0;
//	D current_value;
//	D* sorted = (D*)calloc( neighborhood_voxels, sizeof(D) );
//	//std::sort(
//	// Determine neighborhood sum for voxels whose neighborhood is completely enclosed in image
//	// Strip of size floor(AVG_FILTER_SIZE/2) around image perimeter must be ignored
//	for( int column = left_edge; column <= right_edge; column++ )
//	{
//		for( int row = top_edge; row <= bottom_edge; row++ )
//		{
//			current_value =  image[column + (row * configurations->COLUMNS) + (voxel_z * configurations->COLUMNS * configurations->ROWS)];
//			for( int column2 = left_edge; column2 <= right_edge; column2++ )
//			{
//				for( int row2 = top_edge; row2 <= bottom_edge; row2++ )
//				{
//					if(  image[column2 + (row2 * configurations->COLUMNS) + (voxel_z * configurations->COLUMNS * configurations->ROWS)] < current_value)
//						count++;
//				}
//			}
//			if( count == middle )
//				new_element = current_value;
//			count = 0;
//		}
//	}
//	new_value[voxel] = new_element;
}
template<typename T, typename T2> __global__ void apply_averaging_filter_GPU( T* image, T2* new_value )
{
	int voxel_x = blockIdx.x;
	int voxel_y = blockIdx.y;	
	int voxel_z = threadIdx.x;
	int voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
	image[voxel] = new_value[voxel];
}
/****************************************************************************************************** MLP (host) *****************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
template<typename O> bool find_MLP_endpoints
( 
	O*& image, double x_start, double y_start, double z_start, double xy_angle, double xz_angle, 
	double& x_object, double& y_object, double& z_object, int& voxel_x, int& voxel_y, int& voxel_z, bool entering
)
{	
		//char user_response[20];

		/********************************************************************************************/
		/********************************* Voxel Walk Parameters ************************************/
		/********************************************************************************************/
		int x_move_direction, y_move_direction, z_move_direction;
		double delta_yx, delta_zx, delta_zy;
		/********************************************************************************************/
		/**************************** Status Tracking Information ***********************************/
		/********************************************************************************************/
		double x = x_start, y = y_start, z = z_start;
		double x_to_go, y_to_go, z_to_go;		
		double x_extension, y_extension;	
		//int voxel_x, voxel_y, voxel_z;
		//int voxel_x_out, voxel_y_out, voxel_z_out; 
		int voxel; 
		bool hit_hull = false, end_walk, outside_image;
		// true false
		//bool debug_run = false;
		//bool MLP_image_output = false;
		/********************************************************************************************/
		/******************** Initial Conditions and Movement Characteristics ***********************/
		/********************************************************************************************/	
		if( !entering )
		{
			xy_angle += PI;
		}
		x_move_direction = ( cos(xy_angle) >= 0 ) - ( cos(xy_angle) <= 0 );
		y_move_direction = ( sin(xy_angle) >= 0 ) - ( sin(xy_angle) <= 0 );
		z_move_direction = ( sin(xz_angle) >= 0 ) - ( sin(xz_angle) <= 0 );
		if( x_move_direction < 0 )
		{
			//if( debug_run )
				//puts("z switched");
			z_move_direction *= -1;
		}
		/*if( debug_run )
		{
			cout << "x_move_direction = " << x_move_direction << endl;
			cout << "y_move_direction = " << y_move_direction << endl;
			cout << "z_move_direction = " << z_move_direction << endl;
		}*/
		


		voxel_x = calculate_voxel( X_ZERO_COORDINATE, x, VOXEL_WIDTH );
		voxel_y = calculate_voxel( Y_ZERO_COORDINATE, y, VOXEL_HEIGHT );
		voxel_z = calculate_voxel( Z_ZERO_COORDINATE, z, VOXEL_THICKNESS );

		x_to_go = distance_remaining( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
		y_to_go = distance_remaining( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );	
		z_to_go = distance_remaining( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );

		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
		/********************************************************************************************/
		/***************************** Path and Walk Information ************************************/
		/********************************************************************************************/
		// Lengths/Distances as x is Incremented One Voxel tan( xy_hit_hull_angle )
		delta_yx = fabs(tan(xy_angle));
		delta_zx = fabs(tan(xz_angle));
		delta_zy = fabs( tan(xz_angle)/tan(xy_angle));

		double dy_dx = tan(xy_angle);
		double dz_dx = tan(xz_angle);
		double dz_dy = tan(xz_angle)/tan(xy_angle);

		double dx_dy = pow( tan(xy_angle), -1.0 );
		double dx_dz = pow( tan(xz_angle), -1.0 );
		double dy_dz = tan(xy_angle)/tan(xz_angle);

		//if( debug_run )
		//{
		//	cout << "delta_yx = " << delta_yx << "delta_zx = " << delta_zx << "delta_zy = " << delta_zy << endl;
		//	cout << "dy_dx = " << dy_dx << "dz_dx = " << dz_dx << "dz_dy = " << dz_dy << endl;
		//	cout << "dx_dy = " << dx_dy << "dx_dz = " << dx_dz << "dy_dz = " << dy_dz << endl;
		//}

		/********************************************************************************************/
		/************************* Initialize and Check Exit Conditions *****************************/
		/********************************************************************************************/
		outside_image = (voxel_x >= COLUMNS ) || (voxel_y >= ROWS ) || (voxel_z >= SLICES ) || (voxel_x < 0  ) || (voxel_y < 0 ) || (voxel_z < 0 );		
		if( !outside_image )
		{
			hit_hull = (image[voxel] == 1);		
			//image[voxel] = 4;
		}
		end_walk = outside_image || hit_hull;
		//int j = 0;
		//int j_low_limit = 0;
		//int j_high_limit = 250;
		/*if(debug_run && j <= j_high_limit && j >= j_low_limit )
		{
			printf(" x = %3f y = %3f z = %3f\n",  x, y, z );
			printf(" x_to_go = %3f y_to_go = %3f z_to_go = %3f\n",  x_to_go, y_to_go, z_to_go );
			printf("voxel_x = %d voxel_y = %d voxel_z = %d voxel = %d\n", voxel_x, voxel_y, voxel_z, voxel);
		}*/
		//if( debug_run )
			//fgets(user_response, sizeof(user_response), stdin);
		/********************************************************************************************/
		/*********************************** Voxel Walk Routine *************************************/
		/********************************************************************************************/
		if( z_move_direction != 0 )
		{
			//if(debug_run && j <= j_high_limit && j >= j_low_limit )
				//printf("z_end != z_start\n");
			while( !end_walk )
			{
				// Change in z for Move to Voxel Edge in x and y
				x_extension = delta_zx * x_to_go;
				y_extension = delta_zy * y_to_go;
				//if(debug_run && j <= j_high_limit && j >= j_low_limit )
				//{
				//	printf(" x_extension = %3f y_extension = %3f\n", x_extension, y_extension );
				//	//printf(" x_to_go = %3f y_to_go = %3f z_to_go = %3f\n",  x_to_go, y_to_go, z_to_go );
				//	//printf("voxel_x = %d voxel_y = %d voxel_z = %d voxel = %d\n", voxel_x, voxel_y, voxel_z, voxel);
				//}
				if( (z_to_go <= x_extension  ) && (z_to_go <= y_extension) )
				{
					//printf("z_to_go <= x_extension && z_to_go <= y_extension\n");					
					voxel_z -= z_move_direction;
					
					z = edge_coordinate( Z_ZERO_COORDINATE, voxel_z, VOXEL_THICKNESS, Z_INCREASING_DIRECTION, z_move_direction );					
					x = corresponding_coordinate( dx_dz, z, z_start, x_start );
					y = corresponding_coordinate( dy_dz, z, z_start, y_start );

					/*if(debug_run && j <= j_high_limit && j >= j_low_limit )
					{
						printf(" x = %3f y = %3f z = %3f\n",  x, y, z );
						printf(" x_to_go = %3f y_to_go = %3f z_to_go = %3f\n",  x_to_go, y_to_go, z_to_go );
						printf("voxel_x = %d voxel_y = %d voxel_z = %d voxel = %d\n", voxel_x, voxel_y, voxel_z, voxel);
					}*/

					x_to_go = distance_remaining( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
					y_to_go = distance_remaining( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );	
					z_to_go = VOXEL_THICKNESS;
				}
				//If Next Voxel Edge is in x or xy Diagonal
				else if( x_extension <= y_extension )
				{
					//printf(" x_extension <= y_extension \n");			
					voxel_x += x_move_direction;

					x = edge_coordinate( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
					y = corresponding_coordinate( dy_dx, x, x_start, y_start );
					z = corresponding_coordinate( dz_dx, x, x_start, z_start );

					x_to_go = VOXEL_WIDTH;
					y_to_go = distance_remaining( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
					z_to_go = distance_remaining( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
				}
				// Else Next Voxel Edge is in y
				else
				{
					//printf(" y_extension < x_extension \n");
					voxel_y -= y_move_direction;
					
					y = edge_coordinate( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Y_INCREASING_DIRECTION, y_move_direction );
					x = corresponding_coordinate( dx_dy, y, y_start, x_start );
					z = corresponding_coordinate( dz_dy, y, y_start, z_start );

					x_to_go = distance_remaining( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
					y_to_go = VOXEL_HEIGHT;					
					z_to_go = distance_remaining( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
				}
				// <= VOXEL_ALLOWANCE
				if( x_to_go == 0 )
				{
					x_to_go = VOXEL_WIDTH;
					voxel_x += x_move_direction;
				}
				if( y_to_go == 0 )
				{
					y_to_go = VOXEL_HEIGHT;
					voxel_y -= y_move_direction;
				}
				if( z_to_go == 0 )
				{
					z_to_go = VOXEL_THICKNESS;
					voxel_z -= z_move_direction;
				}
				
				voxel_z = max(voxel_z, 0 );
				voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
				//if(debug_run && j <= j_high_limit && j >= j_low_limit )
				//{
				//	printf(" x = %3f y = %3f z = %3f\n",  x, y, z );
				//	printf(" x_to_go = %3f y_to_go = %3f z_to_go = %3f\n",  x_to_go, y_to_go, z_to_go );
				//	printf("voxel_x = %d voxel_y = %d voxel_z = %d voxel = %d\n", voxel_x, voxel_y, voxel_z, voxel);
				//}
				outside_image = (voxel_x >= COLUMNS ) || (voxel_y >= ROWS ) || (voxel_z >= SLICES ) || (voxel_x < 0  ) || (voxel_y < 0 ) || (voxel_z < 0 );		
				if( !outside_image )
				{
					hit_hull = (image[voxel] == 1);	
					//if( MLP_image_output )
					//{
						//image[voxel] = 4;
					//}
				}
				end_walk = outside_image || hit_hull;
				//j++;
				//if( debug_run )
					//fgets(user_response, sizeof(user_response), stdin);		
			}// end !end_walk 
		}
		else
		{
			//if(debug_run && j <= j_high_limit && j >= j_low_limit )
				//printf("z_end == z_start\n");
			while( !end_walk )
			{
				// Change in x for Move to Voxel Edge in y
				y_extension = y_to_go / delta_yx;
				//If Next Voxel Edge is in x or xy Diagonal
				if( x_to_go <= y_extension )
				{
					//printf(" x_to_go <= y_extension \n");
					voxel_x += x_move_direction;
					
					x = edge_coordinate( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
					y = corresponding_coordinate( dy_dx, x, x_start, y_start );

					x_to_go = VOXEL_WIDTH;
					y_to_go = distance_remaining( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
				}
				// Else Next Voxel Edge is in y
				else
				{
					//printf(" y_extension < x_extension \n");				
					voxel_y -= y_move_direction;

					y = edge_coordinate( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Z_INCREASING_DIRECTION, y_move_direction );
					x = corresponding_coordinate( dx_dy, y, y_start, x_start );

					x_to_go = distance_remaining( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
					y_to_go = VOXEL_HEIGHT;
				}
				// <= VOXEL_ALLOWANCE
				if( x_to_go == 0 )
				{
					x_to_go = VOXEL_WIDTH;
					voxel_x += x_move_direction;
				}
				if( y_to_go == 0 )
				{
					y_to_go = VOXEL_HEIGHT;
					voxel_y -= y_move_direction;
				}
				voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;		
				/*if(debug_run && j <= j_high_limit && j >= j_low_limit )
				{
					printf(" x = %3f y = %3f z = %3f\n",  x, y, z );
					printf(" x_to_go = %3f y_to_go = %3f z_to_go = %3f\n",  x_to_go, y_to_go, z_to_go );
					printf("voxel_x_in = %d voxel_y_in = %d voxel_z_in = %d\n", voxel_x, voxel_y, voxel_z);
				}*/
				outside_image = (voxel_x >= COLUMNS ) || (voxel_y >= ROWS ) || (voxel_z >= SLICES ) || (voxel_x < 0  ) || (voxel_y < 0 ) || (voxel_z < 0 );		
				if( !outside_image )
				{
					hit_hull = (image[voxel] == 1);		
					//if( MLP_image_output )
					//{
						//image[voxel] = 4;
					//}
				}
				end_walk = outside_image || hit_hull;
				//j++;
				//if( debug_run )
					//fgets(user_response, sizeof(user_response), stdin);		
			}// end: while( !end_walk )
			//printf("i = %d", i );
		}//end: else: z_start != z_end => z_start == z_end
		if( hit_hull )
		{
			x_object = x;
			y_object = y;
			z_object = z;
		}
		return hit_hull;
}
unsigned int find_MLP
( 
	unsigned int*& MLP, float*& A_ij, 
	double x_in_object, double y_in_object, double z_in_object, double x_out_object, double y_out_object, double z_out_object, 
	double xy_entry_angle, double xz_entry_angle, double xy_exit_angle, double xz_exit_angle,
	int voxel_x, int voxel_y, int voxel_z
)
{
	//bool debug_output = false, MLP_image_output = false;
	//bool constant_A_ij = true;
	// MLP calculations variables
	int num_intersections = 0;
	double u_0 = 0.0, u_1 = MLP_U_STEP,  u_2 = 0.0;
	double T_0[2] = {0.0, 0.0};
	double T_2[2] = {0.0, 0.0};
	double V_0[2] = {0.0, 0.0};
	double V_2[2] = {0.0, 0.0};
	double R_0[4] = { 1.0, 0.0, 0.0 , 1.0}; //a,b,c,d
	double R_1[4] = { 1.0, 0.0, 0.0 , 1.0}; //a,b,c,d
	double R_1T[4] = { 1.0, 0.0, 0.0 , 1.0};  //a,c,b,d

	double sigma_2_pre_1, sigma_2_pre_2, sigma_2_pre_3;
	double sigma_1_coefficient, sigma_t1, sigma_t1_theta1, sigma_theta1, determinant_Sigma_1, Sigma_1I[4];
	double common_sigma_2_term_1, common_sigma_2_term_2, common_sigma_2_term_3;
	double sigma_2_coefficient, sigma_t2, sigma_t2_theta2, sigma_theta2, determinant_Sigma_2, Sigma_2I[4]; 
	double first_term_common_13_1, first_term_common_13_2, first_term_common_24_1, first_term_common_24_2, first_term[4], determinant_first_term;
	double second_term_common_1, second_term_common_2, second_term_common_3, second_term_common_4, second_term[2];
	double t_1, v_1, x_1, y_1, z_1;
	double first_term_inversion_temp;
	//double theta_1, phi_1;
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//double effective_chord_length = mean_chord_length( u_in_object, t_in_object, v_in_object, u_out_object, t_out_object, v_out_object );
	//double effective_chord_length = VOXEL_WIDTH;

	int voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
	MLP[num_intersections] = voxel;
	//if(!constant_A_ij)
		//A_ij[num_intersections] = VOXEL_WIDTH;
	num_intersections++;
	//MLP_test_image_h[voxel] = 0;

	double u_in_object = ( cos( xy_entry_angle ) * x_in_object ) + ( sin( xy_entry_angle ) * y_in_object );
	double u_out_object = ( cos( xy_entry_angle ) * x_out_object ) + ( sin( xy_entry_angle ) * y_out_object );
	double t_in_object = ( cos( xy_entry_angle ) * y_in_object ) - ( sin( xy_entry_angle ) * x_in_object );
	double t_out_object = ( cos( xy_entry_angle ) * y_out_object ) - ( sin( xy_entry_angle ) * x_out_object );
	double v_in_object = z_in_object;
	double v_out_object = z_out_object;

	if( u_in_object > u_out_object )
	{
		//if( debug_output )
			//cout << "Switched directions" << endl;
		xy_entry_angle += PI;
		xy_exit_angle += PI;
		u_in_object = ( cos( xy_entry_angle ) * x_in_object ) + ( sin( xy_entry_angle ) * y_in_object );
		u_out_object = ( cos( xy_entry_angle ) * x_out_object ) + ( sin( xy_entry_angle ) * y_out_object );
		t_in_object = ( cos( xy_entry_angle ) * y_in_object ) - ( sin( xy_entry_angle ) * x_in_object );
		t_out_object = ( cos( xy_entry_angle ) * y_out_object ) - ( sin( xy_entry_angle ) * x_out_object );
		v_in_object = z_in_object;
		v_out_object = z_out_object;
	}
	T_0[0] = t_in_object;
	T_2[0] = t_out_object;
	T_2[1] = xy_exit_angle - xy_entry_angle;
	V_0[0] = v_in_object;
	V_2[0] = v_out_object;
	V_2[1] = xz_exit_angle - xz_entry_angle;
		
	u_0 = 0.0;
	u_1 = MLP_U_STEP;
	u_2 = abs(u_out_object - u_in_object);		
	//fgets(user_response, sizeof(user_response), stdin);

	//output_file.open(filename);						
				      
	//precalculated u_2 dependent terms (since u_2 does not change inside while loop)
	//u_2 terms
	sigma_2_pre_1 =  pow(u_2, 3.0) * ( A_0_OVER_3 + u_2 * ( A_1_OVER_12 + u_2 * ( A_2_OVER_30 + u_2 * (A_3_OVER_60 + u_2 * ( A_4_OVER_105 + u_2 * A_5_OVER_168 )))));;	//u_2^3 : 1/3, 1/12, 1/30, 1/60, 1/105, 1/168
	sigma_2_pre_2 =  pow(u_2, 2.0) * ( A_0_OVER_2 + u_2 * (A_1_OVER_6 + u_2 * (A_2_OVER_12 + u_2 * ( A_3_OVER_20 + u_2 * (A_4_OVER_30 + u_2 * A_5_OVER_42)))));	//u_2^2 : 1/2, 1/6, 1/12, 1/20, 1/30, 1/42
	sigma_2_pre_3 =  u_2 * ( A_0 +  u_2 * (A_1_OVER_2 +  u_2 * ( A_2_OVER_3 +  u_2 * ( A_3_OVER_4 +  u_2 * ( A_4_OVER_5 + u_2 * A_5_OVER_6 )))));			//u_2 : 1/1, 1/2, 1/3, 1/4, 1/5, 1/6

	while( u_1 < u_2 - MLP_U_STEP)
	//while( u_1 < u_2 - 0.001)
	{
		R_0[1] = u_1;
		R_1[1] = u_2 - u_1;
		R_1T[2] = u_2 - u_1;

		sigma_1_coefficient = pow( E_0 * ( 1 + 0.038 * log( (u_1 - u_0)/X0) ), 2.0 ) / X0;
		sigma_t1 =  sigma_1_coefficient * ( pow(u_1, 3.0) * ( A_0_OVER_3 + u_1 * (A_1_OVER_12 + u_1 * (A_2_OVER_30 + u_1 * (A_3_OVER_60 + u_1 * (A_4_OVER_105 + u_1 * A_5_OVER_168 ) )))) );	//u_1^3 : 1/3, 1/12, 1/30, 1/60, 1/105, 1/168
		sigma_t1_theta1 =  sigma_1_coefficient * ( pow(u_1, 2.0) * ( A_0_OVER_2 + u_1 * (A_1_OVER_6 + u_1 * (A_2_OVER_12 + u_1 * (A_3_OVER_20 + u_1 * (A_4_OVER_30 + u_1 * A_5_OVER_42))))) );	//u_1^2 : 1/2, 1/6, 1/12, 1/20, 1/30, 1/42															
		sigma_theta1 = sigma_1_coefficient * ( u_1 * ( A_0 + u_1 * (A_1_OVER_2 + u_1 * (A_2_OVER_3 + u_1 * (A_3_OVER_4 + u_1 * (A_4_OVER_5 + u_1 * A_5_OVER_6))))) );			//u_1 : 1/1, 1/2, 1/3, 1/4, 1/5, 1/6																	
		determinant_Sigma_1 = sigma_t1 * sigma_theta1 - pow( sigma_t1_theta1, 2 );//ad-bc
			
		Sigma_1I[0] = sigma_theta1 / determinant_Sigma_1;
		Sigma_1I[1] = -sigma_t1_theta1 / determinant_Sigma_1;
		Sigma_1I[2] = -sigma_t1_theta1 / determinant_Sigma_1;
		Sigma_1I[3] = sigma_t1 / determinant_Sigma_1;

		//sigma 2 terms
		sigma_2_coefficient = pow( E_0 * ( 1 + 0.038 * log( (u_2 - u_1)/X0) ), 2.0 ) / X0;
		common_sigma_2_term_1 = u_1 * ( A_0 + u_1 * (A_1_OVER_2 + u_1 * (A_2_OVER_3 + u_1 * (A_3_OVER_4 + u_1 * (A_4_OVER_5 + u_1 * A_5_OVER_6 )))));
		common_sigma_2_term_2 = pow(u_1, 2.0) * ( A_0_OVER_2 + u_1 * (A_1_OVER_3 + u_1 * (A_2_OVER_4 + u_1 * (A_3_OVER_5 + u_1 * (A_4_OVER_6 + u_1 * A_5_OVER_7 )))));
		common_sigma_2_term_3 = pow(u_1, 3.0) * ( A_0_OVER_3 + u_1 * (A_1_OVER_4 + u_1 * (A_2_OVER_5 + u_1 * (A_3_OVER_6 + u_1 * (A_4_OVER_7 + u_1 * A_5_OVER_8 )))));
		sigma_t2 =  sigma_2_coefficient * ( sigma_2_pre_1 - pow(u_2, 2.0) * common_sigma_2_term_1 + 2 * u_2 * common_sigma_2_term_2 - common_sigma_2_term_3 );
		sigma_t2_theta2 =  sigma_2_coefficient * ( sigma_2_pre_2 - u_2 * common_sigma_2_term_1 + common_sigma_2_term_2 );
		sigma_theta2 =  sigma_2_coefficient * ( sigma_2_pre_3 - common_sigma_2_term_1 );				
		determinant_Sigma_2 = sigma_t2 * sigma_theta2 - pow( sigma_t2_theta2, 2 );//ad-bc

		Sigma_2I[0] = sigma_theta2 / determinant_Sigma_2;
		Sigma_2I[1] = -sigma_t2_theta2 / determinant_Sigma_2;
		Sigma_2I[2] = -sigma_t2_theta2 / determinant_Sigma_2;
		Sigma_2I[3] = sigma_t2 / determinant_Sigma_2;

		// first_term_common_ij_k: i,j = rows common to, k = 1st/2nd of last 2 terms of 3 term summation in first_term calculation below
		first_term_common_13_1 = Sigma_2I[0] * R_1[0] + Sigma_2I[1] * R_1[2];
		first_term_common_13_2 = Sigma_2I[2] * R_1[0] + Sigma_2I[3] * R_1[2];
		first_term_common_24_1 = Sigma_2I[0] * R_1[1] + Sigma_2I[1] * R_1[3];
		first_term_common_24_2 = Sigma_2I[2] * R_1[1] + Sigma_2I[3] * R_1[3];

		first_term[0] = Sigma_1I[0] + R_1T[0] * first_term_common_13_1 + R_1T[1] * first_term_common_13_2;
		first_term[1] = Sigma_1I[1] + R_1T[0] * first_term_common_24_1 + R_1T[1] * first_term_common_24_2;
		first_term[2] = Sigma_1I[2] + R_1T[2] * first_term_common_13_1 + R_1T[3] * first_term_common_13_2;
		first_term[3] = Sigma_1I[3] + R_1T[2] * first_term_common_24_1 + R_1T[3] * first_term_common_24_2;


		determinant_first_term = first_term[0] * first_term[3] - first_term[1] * first_term[2];
		first_term_inversion_temp = first_term[0];
		first_term[0] = first_term[3] / determinant_first_term;
		first_term[1] = -first_term[1] / determinant_first_term;
		first_term[2] = -first_term[2] / determinant_first_term;
		first_term[3] = first_term_inversion_temp / determinant_first_term;

		// second_term_common_i: i = # of term of 4 term summation it is common to in second_term calculation below
		second_term_common_1 = R_0[0] * T_0[0] + R_0[1] * T_0[1];
		second_term_common_2 = R_0[2] * T_0[0] + R_0[3] * T_0[1];
		second_term_common_3 = Sigma_2I[0] * T_2[0] + Sigma_2I[1] * T_2[1];
		second_term_common_4 = Sigma_2I[2] * T_2[0] + Sigma_2I[3] * T_2[1];

		second_term[0] = Sigma_1I[0] * second_term_common_1 
						+ Sigma_1I[1] * second_term_common_2 
						+ R_1T[0] * second_term_common_3 
						+ R_1T[1] * second_term_common_4;
		second_term[1] = Sigma_1I[2] * second_term_common_1 
						+ Sigma_1I[3] * second_term_common_2 
						+ R_1T[2] * second_term_common_3 
						+ R_1T[3] * second_term_common_4;

		t_1 = first_term[0] * second_term[0] + first_term[1] * second_term[1];
		//cout << "t_1 = " << t_1 << endl;
		//double theta_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];

		// Do v MLP Now
		second_term_common_1 = R_0[0] * V_0[0] + R_0[1] * V_0[1];
		second_term_common_2 = R_0[2] * V_0[0] + R_0[3] * V_0[1];
		second_term_common_3 = Sigma_2I[0] * V_2[0] + Sigma_2I[1] * V_2[1];
		second_term_common_4 = Sigma_2I[2] * V_2[0] + Sigma_2I[3] * V_2[1];

		second_term[0]	= Sigma_1I[0] * second_term_common_1
						+ Sigma_1I[1] * second_term_common_2
						+ R_1T[0] * second_term_common_3
						+ R_1T[1] * second_term_common_4;
		second_term[1]	= Sigma_1I[2] * second_term_common_1
						+ Sigma_1I[3] * second_term_common_2
						+ R_1T[2] * second_term_common_3
						+ R_1T[3] * second_term_common_4;
		v_1 = first_term[0] * second_term[0] + first_term[1] * second_term[1];
		//double phi_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];

		// Rotate Coordinate From utv to xyz Coordinate System and Determine Which Voxel this Point on the MLP Path is in
		x_1 = ( cos( xy_entry_angle ) * (u_in_object + u_1) ) - ( sin( xy_entry_angle ) * t_1 );
		y_1 = ( sin( xy_entry_angle ) * (u_in_object + u_1) ) + ( cos( xy_entry_angle ) * t_1 );
		z_1 = v_1;

		voxel_x = calculate_voxel( X_ZERO_COORDINATE, x_1, VOXEL_WIDTH );
		voxel_y = calculate_voxel( Y_ZERO_COORDINATE, y_1, VOXEL_HEIGHT );
		voxel_z = calculate_voxel( Z_ZERO_COORDINATE, z_1, VOXEL_THICKNESS);
				
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
		//cout << "voxel_x = " << voxel_x << "voxel_y = " << voxel_y << "voxel_z = " << voxel_z << "voxel = " << voxel <<endl;
		//fgets(user_response, sizeof(user_response), stdin);

		if( voxel != MLP[num_intersections - 1] )
		{
			MLP[num_intersections] = voxel;
			//MLP_test_image_h[voxel] = 0;
			//if(!constant_A_ij)
				//A_ij[num_intersections] = effective_chord_length;						
			num_intersections++;
		}
		u_1 += MLP_U_STEP;
	}
	return num_intersections;
}
void generate_error_for_MLP(double*& a_i, unsigned int a_i_size, double mu, double sigma)
{
	for(unsigned int i = 0 ; i < a_i_size; i++) 
	{
		double error = randn(mu,sigma);
		a_i[i] = error;
	}
}
void collect_MLP_endpoints()
{
	/*************************************************************************************************************************************************************************/
	/***************************************************************** Variable Declarations and Instantiations **************************************************************/
	/*************************************************************************************************************************************************************************/
	double x_in_object, y_in_object, z_in_object, x_out_object, y_out_object, z_out_object;	
	int voxel_x, voxel_y, voxel_z, voxel_x_int, voxel_y_int, voxel_z_int;
	bool entered_object = false, exited_object = false;

	cout << "vector histories = " << (unsigned int)x_entry_vector.size() << endl;
	cout << "post_cut_histories = " << post_cut_histories << endl;
	/*************************************************************************************************************************************************************************/
	/******************************************************************** Perform MLP endpoint calculations ******************************************************************/
	/*************************************************************************************************************************************************************************/
	for( unsigned int i = 0; i < post_cut_histories; i++ )
	{		
		/********************************************************************************************************************************************************************/
		/***************************************** Determine if proton entered and exited object and if so, where these occurred ********************************************/
		/********************************************************************************************************************************************************************/
		entered_object = find_MLP_endpoints( hull_h, x_entry_vector[i], y_entry_vector[i], z_entry_vector[i], xy_entry_angle_vector[i], xz_entry_angle_vector[i], x_in_object, y_in_object, z_in_object, voxel_x, voxel_y, voxel_z, true);	
		exited_object = find_MLP_endpoints( hull_h, x_exit_vector[i], y_exit_vector[i], z_exit_vector[i], xy_exit_angle_vector[i], xz_exit_angle_vector[i], x_out_object, y_out_object, z_out_object, voxel_x_int, voxel_y_int, voxel_z_int, false);
		/********************************************************************************************************************************************************************/
		/***************************************************** Shift data down if proton entered and exited object **********************************************************/
		/********************************************************************************************************************************************************************/		
		if( entered_object && exited_object )
		{			
			voxel_x_vector.push_back(voxel_x);
			voxel_y_vector.push_back(voxel_y);
			voxel_z_vector.push_back(voxel_z);
			bin_num_vector[reconstruction_histories] = bin_num_vector[i];
			WEPL_vector[reconstruction_histories] = WEPL_vector[i];
			x_entry_vector[reconstruction_histories] = x_in_object;
			y_entry_vector[reconstruction_histories] = y_in_object;
			z_entry_vector[reconstruction_histories] = z_in_object;
			x_exit_vector[reconstruction_histories] = x_out_object;
			y_exit_vector[reconstruction_histories] = y_out_object;
			z_exit_vector[reconstruction_histories] = z_out_object;
			xy_entry_angle_vector[reconstruction_histories] = xy_entry_angle_vector[i];
			xz_entry_angle_vector[reconstruction_histories] = xz_entry_angle_vector[i];
			xy_exit_angle_vector[reconstruction_histories] = xy_exit_angle_vector[i];
			xz_exit_angle_vector[reconstruction_histories] = xz_exit_angle_vector[i];
			reconstruction_histories++;
		}
	}
	resize_vectors( reconstruction_histories );
	//shrink_vectors( reconstruction_histories );

	//if( WRITE_MLP_ENDPOINTS )
	write_MLP_endpoints();
}
void write_MLP_endpoints()
{
	puts("Writing MLP endpoints to disk...");
	char endpoints_filename[256];
	sprintf(endpoints_filename, "%s%s/%s_r=%d.bin", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_ENDPOINTS_FILENAME, HULL_AVG_FILTER_RADIUS );
	//sprintf(endpoints_filename, "%s%s/%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_ENDPOINTS_FILENAME );
	FILE* write_MLP_endpoints = fopen(endpoints_filename, "wb");
	fwrite( &reconstruction_histories, sizeof(unsigned int), 1, write_MLP_endpoints );
	fwrite( &voxel_x_vector[0], sizeof(int), voxel_x_vector.size(), write_MLP_endpoints );
	fwrite( &voxel_y_vector[0], sizeof(int), voxel_y_vector.size(), write_MLP_endpoints);
	fwrite( &voxel_z_vector[0], sizeof(int), voxel_z_vector.size(), write_MLP_endpoints );
	fwrite( &bin_num_vector[0], sizeof(int), bin_num_vector.size(), write_MLP_endpoints );
	fwrite( &WEPL_vector[0], sizeof(float), WEPL_vector.size(), write_MLP_endpoints );
	fwrite( &x_entry_vector[0], sizeof(float), x_entry_vector.size(), write_MLP_endpoints);
	fwrite( &y_entry_vector[0], sizeof(float), y_entry_vector.size(), write_MLP_endpoints);
	fwrite( &z_entry_vector[0], sizeof(float), z_entry_vector.size(), write_MLP_endpoints);
	fwrite( &x_exit_vector[0], sizeof(float), x_exit_vector.size(), write_MLP_endpoints );
	fwrite( &y_exit_vector[0], sizeof(float), y_exit_vector.size(), write_MLP_endpoints );
	fwrite( &z_exit_vector[0], sizeof(float), z_exit_vector.size(), write_MLP_endpoints );
	fwrite( &xy_entry_angle_vector[0], sizeof(float), xy_entry_angle_vector.size(), write_MLP_endpoints );
	fwrite( &xz_entry_angle_vector[0], sizeof(float), xz_entry_angle_vector.size(), write_MLP_endpoints );
	fwrite( &xy_exit_angle_vector[0], sizeof(float), xy_exit_angle_vector.size(), write_MLP_endpoints );
	fwrite( &xz_exit_angle_vector[0], sizeof(float), xz_exit_angle_vector.size(), write_MLP_endpoints );
	fclose(write_MLP_endpoints);
	puts("Finished writing MLP endpoints to disk.");
}
unsigned int read_MLP_endpoints()
{
	char endpoints_filename[256];
	//sprintf(endpoints_filename, "%s%s/%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_ENDPOINTS_FILENAME );
	sprintf(endpoints_filename, "%s%s/%s_r=%d.bin", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_ENDPOINTS_FILENAME, HULL_AVG_FILTER_RADIUS );
	FILE* read_MLP_endpoints = fopen(endpoints_filename, "rb");
	//puts("MLP endpoint file opened!\n");
	unsigned int histories;
	fread( &histories, sizeof(unsigned int), 1, read_MLP_endpoints );
	
	resize_vectors( histories );
	//shrink_vectors( histories );
	voxel_x_vector.resize(histories);
	voxel_y_vector.resize(histories);
	voxel_z_vector.resize(histories);

	//fread( &reconstruction_histories, sizeof(unsigned int), 1, read_MLP_endpoints );
	fread( &voxel_x_vector[0], sizeof(int), voxel_x_vector.size(), read_MLP_endpoints );
	fread( &voxel_y_vector[0], sizeof(int), voxel_y_vector.size(), read_MLP_endpoints);
	fread( &voxel_z_vector[0], sizeof(int), voxel_z_vector.size(), read_MLP_endpoints );
	fread( &bin_num_vector[0], sizeof(int), bin_num_vector.size(), read_MLP_endpoints );
	fread( &WEPL_vector[0], sizeof(float), WEPL_vector.size(), read_MLP_endpoints );
	fread( &x_entry_vector[0], sizeof(float), x_entry_vector.size(), read_MLP_endpoints);
	fread( &y_entry_vector[0], sizeof(float), y_entry_vector.size(), read_MLP_endpoints);
	fread( &z_entry_vector[0], sizeof(float), z_entry_vector.size(), read_MLP_endpoints);
	fread( &x_exit_vector[0], sizeof(float), x_exit_vector.size(), read_MLP_endpoints );
	fread( &y_exit_vector[0], sizeof(float), y_exit_vector.size(), read_MLP_endpoints );
	fread( &z_exit_vector[0], sizeof(float), z_exit_vector.size(), read_MLP_endpoints );
	fread( &xy_entry_angle_vector[0], sizeof(float), xy_entry_angle_vector.size(), read_MLP_endpoints );
	fread( &xz_entry_angle_vector[0], sizeof(float), xz_entry_angle_vector.size(), read_MLP_endpoints );
	fread( &xy_exit_angle_vector[0], sizeof(float), xy_exit_angle_vector.size(), read_MLP_endpoints );
	fread( &xz_exit_angle_vector[0], sizeof(float), xz_exit_angle_vector.size(), read_MLP_endpoints );
	fclose(read_MLP_endpoints);
	//puts("MLP endpoint file closed!\n");
	return histories;
}
void write_MLP( FILE* MLP_file, unsigned int*& MLP, unsigned int num_intersections)
{
    fwrite(&num_intersections, sizeof(unsigned int), 1, MLP_file);
    fwrite(MLP, sizeof(unsigned int), num_intersections, MLP_file);
}
unsigned int read_MLP(FILE* MLP_file, unsigned int*& MLP)
{
    unsigned int num_intersections;
	fread(&num_intersections, sizeof(unsigned int), 1, MLP_file);
    fread(MLP, sizeof(unsigned int), num_intersections, MLP_file);
    return num_intersections;
}
void read_MLP_error(FILE* MLP_error_file, float*& MLP_error, unsigned int num_intersections) {

    fread(MLP_error, sizeof(float), num_intersections, MLP_error_file);
}
void export_hull()
{
//	puts("Writing image reconstruction hull to disk...");
//	char input_hull_filename[256];
//	sprintf(input_hull_filename, "%s%s/%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, INPUT_HULL_FILENAME );
//	FILE* write_input_hull = fopen(input_hull_filename, "wb");
//	fwrite( &hull_h, sizeof(bool), NUM_VOXELS, write_input_hull );
//	fclose(write_input_hull);
//	puts("Finished writing image reconstruction hull to disk.");
}
void import_hull()
{
//	puts("Reading image reconstruction hull from disk...");
//	char input_hull_filename[256];
//	sprintf(input_hull_filename, "%s%s/%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, INPUT_HULL_FILENAME );
//	FILE* read_input_hull = fopen(input_hull_filename, "rb");
//	hull_h = (bool*)calloc( NUM_VOXELS, sizeof(bool) );
//	fwrite( &hull_h, sizeof(bool), NUM_VOXELS, read_input_hull );
//	fclose(read_input_hull);
//	puts("Finished reading image reconstruction hull from disk.");
}
/**************************************************************************************************************************************************************************/
/**************************************************************************** MLP Endpoints Routines **********************************************************************/
/**************************************************************************************************************************************************************************/
template<typename O> __device__ bool find_MLP_endpoints_GPU
(
	O* image, double x_start, double y_start, double z_start, double xy_angle, double xz_angle, 
	double& x_object, double& y_object, double& z_object, int& voxel_x, int& voxel_y, int& voxel_z, bool entering
)
{
	/********************************************************************************************/
	/********************************* Voxel Walk Parameters ************************************/
	/********************************************************************************************/
	int x_move_direction, y_move_direction, z_move_direction;
	double delta_yx, delta_zx, delta_zy;
	/********************************************************************************************/
	/**************************** Status Tracking Information ***********************************/
	/********************************************************************************************/
	double x = x_start, y = y_start, z = z_start;
	double x_to_go, y_to_go, z_to_go;		
	double x_extension, y_extension;	
	int voxel; 
	bool hit_hull = false, end_walk, outside_image;
	/********************************************************************************************/
	/******************** Initial Conditions and Movement Characteristics ***********************/
	/********************************************************************************************/	
	if( !entering )
	{
		xy_angle += PI;
	}
	x_move_direction = ( cos(xy_angle) >= 0 ) - ( cos(xy_angle) <= 0 );
	y_move_direction = ( sin(xy_angle) >= 0 ) - ( sin(xy_angle) <= 0 );
	z_move_direction = ( sin(xz_angle) >= 0 ) - ( sin(xz_angle) <= 0 );
	if( x_move_direction < 0 )
		z_move_direction *= -1;

	voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x, VOXEL_WIDTH );
	voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y, VOXEL_HEIGHT );
	voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, z, VOXEL_THICKNESS );

	x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
	y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );	
	z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );

	voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
	/********************************************************************************************/
	/***************************** Path and Walk Information ************************************/
	/********************************************************************************************/
	// Lengths/Distances as x is Incremented One Voxel tan( xy_hit_hull_angle )
	delta_yx = fabs(tan(xy_angle));
	delta_zx = fabs(tan(xz_angle));
	delta_zy = fabs( tan(xz_angle)/tan(xy_angle));

	double dy_dx = tan(xy_angle);
	double dz_dx = tan(xz_angle);
	double dz_dy = tan(xz_angle)/tan(xy_angle);

	double dx_dy = powf( tan(xy_angle), -1.0 );
	double dx_dz = powf( tan(xz_angle), -1.0 );
	double dy_dz = tanf(xy_angle)/tan(xz_angle);
	/********************************************************************************************/
	/************************* Initialize and Check Exit Conditions *****************************/
	/********************************************************************************************/
	outside_image = (voxel_x >= COLUMNS ) || (voxel_y >= ROWS ) || (voxel_z >= SLICES ) || (voxel_x < 0  ) || (voxel_y < 0 ) || (voxel_z < 0 );		
	if( !outside_image )
		hit_hull = (image[voxel] == 1);		
	end_walk = outside_image || hit_hull;
	/********************************************************************************************/
	/*********************************** Voxel Walk Routine *************************************/
	/********************************************************************************************/
	if( z_move_direction != 0 )
	{
		//printf("z_end != z_start\n");
		while( !end_walk )
		{
			// Change in z for Move to Voxel Edge in x and y
			x_extension = delta_zx * x_to_go;
			y_extension = delta_zy * y_to_go;
			if( (z_to_go <= x_extension  ) && (z_to_go <= y_extension) )
			{
				//printf("z_to_go <= x_extension && z_to_go <= y_extension\n");					
				voxel_z -= z_move_direction;
					
				z = edge_coordinate_GPU( Z_ZERO_COORDINATE, voxel_z, VOXEL_THICKNESS, Z_INCREASING_DIRECTION, z_move_direction );					
				x = corresponding_coordinate_GPU( dx_dz, z, z_start, x_start );
				y = corresponding_coordinate_GPU( dy_dz, z, z_start, y_start );

				x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
				y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );	
				z_to_go = VOXEL_THICKNESS;
			}
			//If Next Voxel Edge is in x or xy Diagonal
			else if( x_extension <= y_extension )
			{
				//printf(" x_extension <= y_extension \n");			
				voxel_x += x_move_direction;

				x = edge_coordinate_GPU( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
				y = corresponding_coordinate_GPU( dy_dx, x, x_start, y_start );
				z = corresponding_coordinate_GPU( dz_dx, x, x_start, z_start );

				x_to_go = VOXEL_WIDTH;
				y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
				z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
			}
			// Else Next Voxel Edge is in y
			else
			{
				//printf(" y_extension < x_extension \n");
				voxel_y -= y_move_direction;
					
				y = edge_coordinate_GPU( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Y_INCREASING_DIRECTION, y_move_direction );
				x = corresponding_coordinate_GPU( dx_dy, y, y_start, x_start );
				z = corresponding_coordinate_GPU( dz_dy, y, y_start, z_start );

				x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
				y_to_go = VOXEL_HEIGHT;					
				z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
			}
			// <= VOXEL_ALLOWANCE
			if( x_to_go == 0 )
			{
				x_to_go = VOXEL_WIDTH;
				voxel_x += x_move_direction;
			}
			if( y_to_go == 0 )
			{
				y_to_go = VOXEL_HEIGHT;
				voxel_y -= y_move_direction;
			}
			if( z_to_go == 0 )
			{
				z_to_go = VOXEL_THICKNESS;
				voxel_z -= z_move_direction;
			}
				
			voxel_z = max(voxel_z, 0 );
			voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;

			outside_image = (voxel_x >= COLUMNS ) || (voxel_y >= ROWS ) || (voxel_z >= SLICES ) || (voxel_x < 0  ) || (voxel_y < 0 ) || (voxel_z < 0 );		
			if( !outside_image )
				hit_hull = (image[voxel] == 1);	
			end_walk = outside_image || hit_hull;	
		}// end !end_walk 
	}
	else
	{
		//printf("z_end == z_start\n");
		while( !end_walk )
		{
			// Change in x for Move to Voxel Edge in y
			y_extension = y_to_go / delta_yx;
			//If Next Voxel Edge is in x or xy Diagonal
			if( x_to_go <= y_extension )
			{
				//printf(" x_to_go <= y_extension \n");
				voxel_x += x_move_direction;
					
				x = edge_coordinate_GPU( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
				y = corresponding_coordinate_GPU( dy_dx, x, x_start, y_start );

				x_to_go = VOXEL_WIDTH;
				y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
			}
			// Else Next Voxel Edge is in y
			else
			{
				//printf(" y_extension < x_extension \n");				
				voxel_y -= y_move_direction;

				y = edge_coordinate_GPU( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Z_INCREASING_DIRECTION, y_move_direction );
				x = corresponding_coordinate_GPU( dx_dy, y, y_start, x_start );

				x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
				y_to_go = VOXEL_HEIGHT;
			}
			// <= VOXEL_ALLOWANCE
			if( x_to_go == 0 )
			{
				x_to_go = VOXEL_WIDTH;
				voxel_x += x_move_direction;
			}
			if( y_to_go == 0 )
			{
				y_to_go = VOXEL_HEIGHT;
				voxel_y -= y_move_direction;
			}
			voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;		
			outside_image = (voxel_x >= COLUMNS ) || (voxel_y >= ROWS ) || (voxel_z >= SLICES ) || (voxel_x < 0  ) || (voxel_y < 0 ) || (voxel_z < 0 );		
			if( !outside_image )
				hit_hull = (image[voxel] == 1);		
			end_walk = outside_image || hit_hull;	
		}// end: while( !end_walk )
	}//end: else: z_start != z_end => z_start == z_end
	if( hit_hull )
	{
		x_object = x;
		y_object = y;
		z_object = z;
	}
	return hit_hull;
}
__global__ void collect_MLP_endpoints_GPU
(
	bool* traversed_hull, unsigned int* first_MLP_voxel, bool* hull, float* x_entry, float* y_entry, float* z_entry, float* xy_entry_angle, float* xz_entry_angle, 
	float* x_exit, float* y_exit, float* z_exit, float* xy_exit_angle, float* xz_exit_angle, int start_proton_id, int num_histories
) 
{
  
	bool entered_object = false, exited_object = false;
	int voxel_x = 0, voxel_y = 0, voxel_z = 0, voxel_x_int = 0, voxel_y_int = 0, voxel_z_int = 0;
	double x_in_object = 0.0, y_in_object = 0.0, z_in_object = 0.0, x_out_object = 0.0, y_out_object = 0.0, z_out_object = 0.0;

	int proton_id = start_proton_id + threadIdx.x * ENDPOINTS_PER_THREAD + blockIdx.x * ENDPOINTS_PER_BLOCK* ENDPOINTS_PER_THREAD;
	if( proton_id < num_histories ) 
	{
		for( int history = 0; history < ENDPOINTS_PER_THREAD; history++)
		{
			if( proton_id < num_histories ) 
			{
	
				/*exited_object = find_MLP_endpoints_GPU( hull, x_exit[proton_id], y_exit[proton_id], z_exit[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], x_out_object, y_out_object, z_out_object, voxel_x_int, voxel_y_int, voxel_z_int, false);
				if( exited_object ) 
					entered_object = find_MLP_endpoints_GPU( hull, x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], x_in_object, y_in_object, z_in_object, voxel_x, voxel_y, voxel_z, true);	
				*/
				entered_object = find_MLP_endpoints_GPU( hull, x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], x_in_object, y_in_object, z_in_object, voxel_x, voxel_y, voxel_z, true);	
				if( entered_object ) 
					exited_object = find_MLP_endpoints_GPU( hull, x_exit[proton_id], y_exit[proton_id], z_exit[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], x_out_object, y_out_object, z_out_object, voxel_x_int, voxel_y_int, voxel_z_int, false);
				
				//__syncthreads();
				if( entered_object && exited_object ) 
				{
		  
					traversed_hull[proton_id] = true;
					first_MLP_voxel[proton_id] = voxel_x + COLUMNS * voxel_y + ROWS * COLUMNS * voxel_z;
					x_entry[proton_id] = x_in_object;
					y_entry[proton_id] = y_in_object;
					z_entry[proton_id] = z_in_object;
					x_exit[proton_id] = x_out_object;
					y_exit[proton_id] = y_out_object;
					z_exit[proton_id] = z_out_object;
				}	  
				else
				{
					traversed_hull[proton_id] = false;
					first_MLP_voxel[proton_id] = NUM_VOXELS;			
				}
			}
			proton_id++;
		}
	}
}
__global__ void collect_MLP_endpoints_GPU_nobool
(
	unsigned int* first_MLP_voxel, bool* hull, float* x_entry, float* y_entry, float* z_entry, float* xy_entry_angle, float* xz_entry_angle, 
	float* x_exit, float* y_exit, float* z_exit, float* xy_exit_angle, float* xz_exit_angle, int start_proton_id, int num_histories
) 
{
	bool entered_object = false, exited_object = false;
	int voxel_x = 0, voxel_y = 0, voxel_z = 0, voxel_x_int = 0, voxel_y_int = 0, voxel_z_int = 0;
	double x_in_object = 0.0, y_in_object = 0.0, z_in_object = 0.0, x_out_object = 0.0, y_out_object = 0.0, z_out_object = 0.0;
	//float x_in_object = 0.0, y_in_object = 0.0, z_in_object = 0.0, x_out_object = 0.0, y_out_object = 0.0, z_out_object = 0.0;
	//int proton_id = start_proton_id + threadIdx.x * ENDPOINTS_PER_THREAD + blockIdx.x * ENDPOINTS_PER_BLOCK;
	int proton_id = start_proton_id + threadIdx.x * ENDPOINTS_PER_THREAD + blockIdx.x * ENDPOINTS_PER_BLOCK* ENDPOINTS_PER_THREAD;
	
	for( int history = 0; history < ENDPOINTS_PER_THREAD; history++)
	{
		if( proton_id < num_histories ) 
		{
			//entered_object = find_MLP_endpoints_GPU( hull, x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], x_in_object, y_in_object, z_in_object, voxel_x, voxel_y, voxel_z, true);	
			//if( entered_object ) 
			//	exited_object = find_MLP_endpoints_GPU( hull, x_exit[proton_id], y_exit[proton_id], z_exit[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], x_out_object, y_out_object, z_out_object, voxel_x_int, voxel_y_int, voxel_z_int, false);
			exited_object = find_MLP_endpoints_GPU( hull, x_exit[proton_id], y_exit[proton_id], z_exit[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], x_out_object, y_out_object, z_out_object, voxel_x_int, voxel_y_int, voxel_z_int, false);
			if( exited_object ) 
				entered_object = find_MLP_endpoints_GPU( hull, x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], x_in_object, y_in_object, z_in_object, voxel_x, voxel_y, voxel_z, true);	
			
			if( entered_object && exited_object ) 
			{
				first_MLP_voxel[proton_id] = voxel_x + COLUMNS * voxel_y + ROWS * COLUMNS * voxel_z;
				x_entry[proton_id] = x_in_object;
				y_entry[proton_id] = y_in_object;
				z_entry[proton_id] = z_in_object;
				x_exit[proton_id] = x_out_object;
				y_exit[proton_id] = y_out_object;
				z_exit[proton_id] = z_out_object;
			}
			else
				first_MLP_voxel[proton_id] = NUM_VOXELS;			  
		}
		proton_id++;
	}
}
void reconstruction_cuts_hull_transfer()
{
	cudaFree(hull_d);
	cudaMalloc( (void**) &hull_d, SIZE_IMAGE_BOOL);	
	cudaMemcpy( hull_d, hull_h, SIZE_IMAGE_BOOL, cudaMemcpyHostToDevice );
}
void reconstruction_cuts_allocations( const int num_histories)
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_ints			= sizeof(int) * num_histories;
	unsigned int size_bool			= sizeof(bool) * num_histories;

	traversed_hull_h = (bool*)calloc( num_histories, sizeof(bool) );
	
	cudaMalloc( (void**) &x_entry_d,			size_floats );
	cudaMalloc( (void**) &y_entry_d,			size_floats );
	cudaMalloc( (void**) &z_entry_d,			size_floats );
	cudaMalloc( (void**) &x_exit_d,				size_floats );
	cudaMalloc( (void**) &y_exit_d,				size_floats );
	cudaMalloc( (void**) &z_exit_d,				size_floats );
	cudaMalloc( (void**) &xy_entry_angle_d,			size_floats );
	cudaMalloc( (void**) &xz_entry_angle_d,			size_floats );
	cudaMalloc( (void**) &xy_exit_angle_d,			size_floats );
	cudaMalloc( (void**) &xz_exit_angle_d,			size_floats );
	cudaMalloc( (void**) &traversed_hull_d, 		size_bool );
	cudaMalloc( (void**) &first_MLP_voxel_d, 		size_ints );

	//char error_statement[] = {"ERROR: reconstruction_cuts GPU array allocations caused...\n"};
	//cudaError_t cudaStatus = CUDA_error_check( error_statement );
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_allocations Error: %s\n", cudaGetErrorString(cudaStatus));
}
void reconstruction_cuts_host_2_device(const int start_position, const int num_histories) 
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_bool			= sizeof(bool) * num_histories;

	cudaMemcpy( traversed_hull_d, 	traversed_hull_h, 						size_bool,		cudaMemcpyHostToDevice );  
	cudaMemcpy( x_entry_d,				&x_entry_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( y_entry_d,				&y_entry_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( z_entry_d,				&z_entry_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( x_exit_d,				&x_exit_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( y_exit_d,				&y_exit_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( z_exit_d,				&z_exit_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_entry_angle_d,		&xy_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_entry_angle_d,		&xz_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_exit_angle_d,		&xy_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_exit_angle_d,		&xz_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );	

	//char error_statement[] = {"ERROR: reconstruction_cuts host->GPU data transfer caused...\n"};
	//cudaError_t cudaStatus =  CUDA_error_check( error_statement );
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_host_2_device Error: %s\n", cudaGetErrorString(cudaStatus));	
}
void reconstruction_cuts_device_2_host(const int start_position, const int num_histories) 
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_ints			= sizeof(int) * num_histories;
	unsigned int size_bool			= sizeof(bool) * num_histories;

	cudaMemcpy(&first_MLP_voxel_vector[start_position], first_MLP_voxel_d, size_ints, cudaMemcpyDeviceToHost);
	cudaMemcpy(&x_entry_vector[start_position], x_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&y_entry_vector[start_position], y_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&z_entry_vector[start_position], z_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&x_exit_vector[start_position], x_exit_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&y_exit_vector[start_position], y_exit_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&z_exit_vector[start_position], z_exit_d, size_floats, cudaMemcpyDeviceToHost);	
	cudaMemcpy(traversed_hull_h, traversed_hull_d, size_bool, cudaMemcpyDeviceToHost);
	
	//char error_statement[] = {"ERROR: reconstruction_cuts GPU->host data transfer caused...\n"};
	//cudaError_t cudaStatus =  CUDA_error_check( error_statement );
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_device_2_host Error: %s\n", cudaGetErrorString(cudaStatus));
}
void reconstruction_cuts_deallocations()
{
	cudaFree( x_entry_d);
	cudaFree( y_entry_d);
	cudaFree( z_entry_d);
	cudaFree( x_exit_d);
	cudaFree( y_exit_d);
	cudaFree( z_exit_d);
	cudaFree( xy_entry_angle_d);
	cudaFree( xz_entry_angle_d);
	cudaFree( xy_exit_angle_d);
	cudaFree( xz_exit_angle_d );
	cudaFree( traversed_hull_d );
	cudaFree( first_MLP_voxel_d);

	free(traversed_hull_h);
	
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("reconstruction_cuts_deallocations Error: %s\n", cudaGetErrorString(cudaStatus));
}
void reconstruction_cuts_full_tx( const int num_histories )
{
	// ENDPOINTS_TX_MODE = FULL_TX, ENDPOINTS_ALG = USE_BOOL_ARRAY
	cudaError_t cudaStatus;
	reconstruction_histories = 0;
	int remaining_histories = num_histories, histories_2_process, start_position = 0;
	//int num_blocks = static_cast<int>( (MAX_ENDPOINTS_HISTORIES - 1 + ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD) / (ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD));
	int num_blocks;
	while( remaining_histories > 0 )
	{
		if( remaining_histories > MAX_ENDPOINTS_HISTORIES )
			histories_2_process = MAX_ENDPOINTS_HISTORIES;
		else
			histories_2_process = remaining_histories;	

		num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
		collect_MLP_endpoints_GPU<<< num_blocks, ENDPOINTS_PER_BLOCK >>>
		( 
			traversed_hull_d, first_MLP_voxel_d, hull_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, 
			x_exit_d, y_exit_d, z_exit_d, xy_exit_angle_d, xz_exit_angle_d, start_position, num_histories
		);		
		cudaStatus = cudaGetLastError();
		if (cudaStatus != cudaSuccess) 
			printf("Error: %s\n", cudaGetErrorString(cudaStatus));

		cudaStatus = cudaDeviceSynchronize();
		if (cudaStatus != cudaSuccess)
			fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);

		remaining_histories -= MAX_ENDPOINTS_HISTORIES;
		start_position		+= MAX_ENDPOINTS_HISTORIES;
	}
	reconstruction_cuts_device_2_host(0, num_histories);	    
	for( int i = 0; i < num_histories; i++ ) 
	{    
		if( traversed_hull_h[i] ) 
		{
			first_MLP_voxel_vector[reconstruction_histories] = first_MLP_voxel_vector[i];
			data_shift_vectors( i, reconstruction_histories );
			reconstruction_histories++;
		}
	}
}
void reconstruction_cuts_partial_tx(const int start_position, const int num_histories) 
{
	// ENDPOINTS_TX_MODE = PARTIAL_TX, ENDPOINTS_ALG = USE_BOOL_ARRAY
	reconstruction_cuts_allocations(num_histories);
	reconstruction_cuts_host_2_device( start_position, num_histories);

	dim3 dimBlock(ENDPOINTS_PER_BLOCK);
	int num_blocks = static_cast<int>( (num_histories - 1 + ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD ) / (ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD)  );
	collect_MLP_endpoints_GPU<<< num_blocks, dimBlock >>>
	( 
		traversed_hull_d, first_MLP_voxel_d, hull_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d,  
		x_exit_d, y_exit_d, z_exit_d, xy_exit_angle_d, xz_exit_angle_d, 0, num_histories 
	);

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Endpoints kernel Error: %s\n", cudaGetErrorString(cudaStatus));						  
	
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess)
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);

	reconstruction_cuts_device_2_host(start_position, num_histories);
	for( int i = 0; i < num_histories; i++ ) 
	{    
		if( traversed_hull_h[i] ) 
		{
			first_MLP_voxel_vector[reconstruction_histories] = first_MLP_voxel_vector[ i + start_position ];
			data_shift_vectors( i + start_position, reconstruction_histories );
			reconstruction_histories++;
		}
	}	
	reconstruction_cuts_deallocations();
}
void reconstruction_cuts_partial_tx_preallocated(const int start_position, const int num_histories) 
{ 
	// ENDPOINTS_TX_MODE = PARTIAL_TX_PREALLOCATED, ENDPOINTS_ALG = USE_BOOL_ARRAY
	reconstruction_cuts_host_2_device( start_position, num_histories);
	int num_blocks = static_cast<int>( (num_histories - 1 + ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD ) / (ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD)  );
	dim3 dimBlock(ENDPOINTS_PER_BLOCK);
	collect_MLP_endpoints_GPU<<< num_blocks, dimBlock >>>
	( 
		traversed_hull_d, first_MLP_voxel_d, hull_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, 
		x_exit_d, y_exit_d, z_exit_d, xy_exit_angle_d, xz_exit_angle_d, 0, num_histories 
	);
		
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error: %s\n", cudaGetErrorString(cudaStatus));						  
	
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess)
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);						

	reconstruction_cuts_device_2_host(start_position, num_histories);
	for( int i = 0; i < num_histories; i++ ) 
	{	    
		if( traversed_hull_h[i] ) 
		{
			first_MLP_voxel_vector[reconstruction_histories] = first_MLP_voxel_vector[ i + start_position ];
			data_shift_vectors( i + start_position, reconstruction_histories );
			reconstruction_histories++;
		}
	}	
}
void reconstruction_cuts_allocations_nobool( const int num_histories)
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_ints			= sizeof(int) * num_histories;

	cudaMalloc( (void**) &x_entry_d,			size_floats );
	cudaMalloc( (void**) &y_entry_d,			size_floats );
	cudaMalloc( (void**) &z_entry_d,			size_floats );
	cudaMalloc( (void**) &x_exit_d,				size_floats );
	cudaMalloc( (void**) &y_exit_d,				size_floats );
	cudaMalloc( (void**) &z_exit_d,				size_floats );
	cudaMalloc( (void**) &xy_entry_angle_d,			size_floats );
	cudaMalloc( (void**) &xz_entry_angle_d,			size_floats );
	cudaMalloc( (void**) &xy_exit_angle_d,			size_floats );
	cudaMalloc( (void**) &xz_exit_angle_d,			size_floats );
	cudaMalloc( (void**) &first_MLP_voxel_d, 		size_ints );
}
void reconstruction_cuts_host_2_device_nobool(const int start_position, const int num_histories) 
{
	unsigned int size_floats		= sizeof(float) * num_histories;

	cudaMemcpy( x_entry_d,				&x_entry_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( y_entry_d,				&y_entry_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( z_entry_d,				&z_entry_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( x_exit_d,				&x_exit_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( y_exit_d,				&y_exit_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( z_exit_d,				&z_exit_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_entry_angle_d,			&xy_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_entry_angle_d,			&xz_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_exit_angle_d,			&xy_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_exit_angle_d,			&xz_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );	

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
			printf("Error: %s\n", cudaGetErrorString(cudaStatus));

	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess)
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);
}
void reconstruction_cuts_device_2_host_nobool(const int start_position, const int num_histories) 
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_ints			= sizeof(int) * num_histories;
  
	cudaMemcpy(&first_MLP_voxel_vector[start_position], first_MLP_voxel_d, size_ints, cudaMemcpyDeviceToHost);
	cudaMemcpy(&x_entry_vector[start_position], x_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&y_entry_vector[start_position], y_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&z_entry_vector[start_position], z_entry_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&x_exit_vector[start_position], x_exit_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&y_exit_vector[start_position], y_exit_d, size_floats, cudaMemcpyDeviceToHost);
	cudaMemcpy(&z_exit_vector[start_position], z_exit_d, size_floats, cudaMemcpyDeviceToHost);	

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error: %s\n", cudaGetErrorString(cudaStatus));

	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess)
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);
}
void reconstruction_cuts_deallocations_nobool()
{
	cudaFree( x_entry_d);
	cudaFree( y_entry_d);
	cudaFree( z_entry_d);
	cudaFree( x_exit_d);
	cudaFree( y_exit_d);
	cudaFree( z_exit_d);
	cudaFree( xy_entry_angle_d);
	cudaFree( xz_entry_angle_d);
	cudaFree( xy_exit_angle_d);
	cudaFree( xz_exit_angle_d );
	cudaFree( first_MLP_voxel_d);
}
void reconstruction_cuts_full_tx_nobool( const int num_histories )
{
	// ENDPOINTS_TX_MODE = FULL_TX, ENDPOINTS_ALG = NO_BOOL_ARRAY 
	cudaError_t cudaStatus;
	reconstruction_histories = 0;
	int remaining_histories = num_histories, histories_2_process, start_position = 0;
	//int num_blocks = static_cast<int>( (MAX_ENDPOINTS_HISTORIES - 1 + ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD) / (ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD));
	int num_blocks;
	while( remaining_histories > 0 )
	{
		if( remaining_histories > MAX_ENDPOINTS_HISTORIES )
			histories_2_process = MAX_ENDPOINTS_HISTORIES;
		else
			histories_2_process = remaining_histories;	

		num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
		collect_MLP_endpoints_GPU_nobool<<< num_blocks, ENDPOINTS_PER_BLOCK >>>
		( 
			first_MLP_voxel_d, hull_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, 
			x_exit_d, y_exit_d, z_exit_d, xy_exit_angle_d, xz_exit_angle_d, start_position, num_histories
		);		
		cudaStatus = cudaGetLastError();
		if (cudaStatus != cudaSuccess) 
			printf("Error: %s\n", cudaGetErrorString(cudaStatus));

		cudaStatus = cudaDeviceSynchronize();
		if (cudaStatus != cudaSuccess)
			fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);

		remaining_histories -= MAX_ENDPOINTS_HISTORIES;
		start_position		+= MAX_ENDPOINTS_HISTORIES;
		//cout << "start_position = " << start_position << endl;
		//cout << "remaining_histories = " << remaining_histories << endl;	
	}
	reconstruction_cuts_device_2_host_nobool(0, num_histories);	    
	for( int i = 0; i < num_histories; i++ ) 
	{    
		if( first_MLP_voxel_vector[i] != NUM_VOXELS ) 
		{
			first_MLP_voxel_vector[reconstruction_histories] = first_MLP_voxel_vector[i];
			data_shift_vectors( i, reconstruction_histories );
			reconstruction_histories++;
		}
	}
}
void reconstruction_cuts_partial_tx_nobool(const int start_position, const int num_histories) 
{ 
	// ENDPOINTS_TX_MODE = PARTIAL_TX, ENDPOINTS_ALG = NO_BOOL_ARRAY
	reconstruction_cuts_allocations_nobool(num_histories);
	reconstruction_cuts_host_2_device_nobool( start_position, num_histories);
			
	int num_blocks = static_cast<int>( (num_histories - 1 + ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD ) / (ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD)  );
	dim3 dimBlock(ENDPOINTS_PER_BLOCK);
	collect_MLP_endpoints_GPU_nobool<<< num_blocks, dimBlock >>>
	( 
		first_MLP_voxel_d, hull_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d, xy_exit_angle_d, xz_exit_angle_d, 0, num_histories 
	);
		
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error: %s\n", cudaGetErrorString(cudaStatus));						  
	
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess)
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);
	

	reconstruction_cuts_device_2_host_nobool(start_position, num_histories);
	for( int i = 0; i < num_histories; i++ ) 
	{    
		if( first_MLP_voxel_vector[i + start_position] != NUM_VOXELS ) 
		{
			first_MLP_voxel_vector[reconstruction_histories] = first_MLP_voxel_vector[i + start_position];
			data_shift_vectors( i + start_position, reconstruction_histories );
			reconstruction_histories++;
		}
	}	
	reconstruction_cuts_deallocations_nobool();
}
void reconstruction_cuts_partial_tx_preallocated_nobool(const int start_position, const int num_histories) 
{
	// ENDPOINTS_TX_MODE = PARTIAL_TX_PREALLOCATED, ENDPOINTS_ALG = NO_BOOL_ARRAY
	reconstruction_cuts_host_2_device_nobool( start_position, num_histories);
	int num_blocks = static_cast<int>( (num_histories - 1 + ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD ) / (ENDPOINTS_PER_BLOCK*ENDPOINTS_PER_THREAD)  );
	dim3 dimBlock(ENDPOINTS_PER_BLOCK);
	collect_MLP_endpoints_GPU_nobool<<< num_blocks, dimBlock >>>
	( 
		first_MLP_voxel_d, hull_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d, xy_exit_angle_d, xz_exit_angle_d, 0, num_histories 
	);
	
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error: %s\n", cudaGetErrorString(cudaStatus));						  
	
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess)
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Kernel!\n", cudaStatus);
	
	reconstruction_cuts_device_2_host_nobool(start_position, num_histories);	
	for( int i = 0; i < num_histories; i++ ) 
	{  
		if( first_MLP_voxel_vector[i + start_position] != NUM_VOXELS ) 
		{
			first_MLP_voxel_vector.at(reconstruction_histories) = first_MLP_voxel_vector.at( i + start_position );
			data_shift_vectors( i + start_position, reconstruction_histories );
			reconstruction_histories++;
		}
	}	
}
/***********************************************************************************************************************************************************************************************************************/
/****************************************************************************************** Generate/Export/Import MLP Lookup Tables ***********************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void generate_trig_tables()
{
	//printf("TRIG_TABLE_ELEMENTS = %d\n", TRIG_TABLE_ELEMENTS );
	double sin_term, cos_term, val;
	
	sin_table_h = (double*) calloc( TRIG_TABLE_ELEMENTS + 1, sizeof(double) );
	cos_table_h = (double*) calloc( TRIG_TABLE_ELEMENTS + 1, sizeof(double) );
	
	sin_table_file = fopen( SIN_TABLE_FILENAME, "wb" );
	cos_table_file = fopen( COS_TABLE_FILENAME, "wb" );
	/*for( float i = TRIG_TABLE_MIN; i <= TRIG_TABLE_MAX; i+= TRIG_TABLE_STEP )
	{
		sin_term = sin(i);
		cos_term = cos(i);
		fwrite( &sin_term, sizeof(float), 1, sin_table_file );
		fwrite( &cos_term, sizeof(float), 1, cos_table_file );
	}*/
	for( int i = 0; i <= TRIG_TABLE_ELEMENTS; i++ )
	{
		val =  TRIG_TABLE_MIN + i * TRIG_TABLE_STEP;
		sin_term = sin(val);
		cos_term = cos(val);
		sin_table_h[i] = sin_term;
		cos_table_h[i] = cos_term;
		fwrite( &sin_term, sizeof(double), 1, sin_table_file );
		fwrite( &cos_term, sizeof(double), 1, cos_table_file );
	}
	fclose(sin_table_file);
	fclose(cos_table_file);
}
void generate_scattering_coefficient_table()
{
	double scattering_coefficient;
	scattering_table_file = fopen( COEFFICIENT_FILENAME, "wb" );
	int i = 0;
	double depth = 0.0;
	scattering_table_h = (double*)calloc( COEFF_TABLE_ELEMENTS + 1, sizeof(double));
	for( int step_num = 0; step_num <= COEFF_TABLE_ELEMENTS; step_num++ )
	{
		depth = step_num * COEFF_TABLE_STEP;
		scattering_coefficient = pow( E_0 * ( 1 + 0.038 * log(depth / X0) ), 2.0 ) / X0;
		scattering_table_h[i] = scattering_coefficient;
		//fwrite( &scattering_coefficient, sizeof(float), 1, scattering_table_file );
		i++;
	}
	//for( float depth = 0.0; depth <= COEFF_TABLE_RANGE; depth+= COEFF_TABLE_STEP )
	//{
	//	scattering_coefficient = pow( E_0 * ( 1 + 0.038 * log(depth / X0) ), 2.0 ) / X0;
	//	scattering_table_h[i] = scattering_coefficient;
	//	//fwrite( &scattering_coefficient, sizeof(float), 1, scattering_table_file );
	//	i++;
	//}
	fwrite(scattering_table_h, sizeof(double), COEFF_TABLE_ELEMENTS + 1, scattering_table_file );
	fclose(scattering_table_file);
	//for( int step_num = 0; step_num <= COEFF_TABLE_ELEMENTS; step_num++ )
	//	cout << scattering_table_h[step_num] << endl;
	//cout << "elements = " << i << endl;
	//cout << "COEFF_TABLE_ELEMENTS = " << COEFF_TABLE_ELEMENTS << endl;
	//cout << scattering_table_h[i-1] << endl;
	//cout << (pow( E_0 * ( 1 + 0.038 * log(COEFF_TABLE_RANGE / X0) ), 2.0 ) / X0) << endl;
	
}
void generate_polynomial_tables()
{
	int i = 0;
	double du;
	//float poly_1_2_val, poly_2_3_val, poly_3_4_val, poly_2_6_val, poly_3_12_val;
	poly_1_2_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_2_3_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_3_4_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_2_6_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_3_12_h = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );

	poly_1_2_file  = fopen( POLY_1_2_FILENAME,  "wb" );
	poly_2_3_file  = fopen( POLY_2_3_FILENAME,  "wb" );
	poly_3_4_file  = fopen( POLY_3_4_FILENAME,  "wb" );
	poly_2_6_file  = fopen( POLY_2_6_FILENAME,  "wb" );
	poly_3_12_file = fopen( POLY_3_12_FILENAME, "wb" );
	for( int step_num = 0; step_num <= POLY_TABLE_ELEMENTS; step_num++ )
	{
		du = step_num * POLY_TABLE_STEP;
		//poly_1_2_val = A_0		   + du * (A_1_OVER_2  + du * (A_2_OVER_3  + du * (A_3_OVER_4  + du * (A_4_OVER_5   + du * A_5_OVER_6   ))));	// 1, 2, 3, 4, 5, 6
		//poly_2_3_val = A_0_OVER_2 + du * (A_1_OVER_3  + du * (A_2_OVER_4  + du * (A_3_OVER_5  + du * (A_4_OVER_6   + du * A_5_OVER_7   ))));	// 2, 3, 4, 5, 6, 7
		//poly_3_4_val = A_0_OVER_3 + du * (A_1_OVER_4  + du * (A_2_OVER_5  + du * (A_3_OVER_6  + du * (A_4_OVER_7   + du * A_5_OVER_8   ))));	// 3, 4, 5, 6, 7, 8
		//poly_2_6_val = A_0_OVER_2 + du * (A_1_OVER_6  + du * (A_2_OVER_12 + du * (A_3_OVER_20 + du * (A_4_OVER_30  + du * A_5_OVER_42  ))));	// 2, 6, 12, 20, 30, 42
		//poly_3_12_val = A_0_OVER_3 + du * (A_1_OVER_12 + du * (A_2_OVER_30 + du * (A_3_OVER_60 + du * (A_4_OVER_105 + du * A_5_OVER_168 ))));	// 3, 12, 30, 60, 105, 168		
		poly_1_2_h[step_num]  = du * ( A_0		   + du * (A_1_OVER_2  + du * (A_2_OVER_3  + du * (A_3_OVER_4  + du * (A_4_OVER_5   + du * A_5_OVER_6   )))) );	// 1, 2, 3, 4, 5, 6
		poly_2_3_h[step_num]  = pow(du, 2) * ( A_0_OVER_2 + du * (A_1_OVER_3  + du * (A_2_OVER_4  + du * (A_3_OVER_5  + du * (A_4_OVER_6   + du * A_5_OVER_7   )))) );	// 2, 3, 4, 5, 6, 7
		poly_3_4_h[step_num]  = pow(du, 3) * ( A_0_OVER_3 + du * (A_1_OVER_4  + du * (A_2_OVER_5  + du * (A_3_OVER_6  + du * (A_4_OVER_7   + du * A_5_OVER_8   )))) );	// 3, 4, 5, 6, 7, 8
		poly_2_6_h[step_num]  = pow(du, 2) * ( A_0_OVER_2 + du * (A_1_OVER_6  + du * (A_2_OVER_12 + du * (A_3_OVER_20 + du * (A_4_OVER_30  + du * A_5_OVER_42  )))) );	// 2, 6, 12, 20, 30, 42
		poly_3_12_h[step_num] = pow(du, 3) * ( A_0_OVER_3 + du * (A_1_OVER_12 + du * (A_2_OVER_30 + du * (A_3_OVER_60 + du * (A_4_OVER_105 + du * A_5_OVER_168 )))) );	// 3, 12, 30, 60, 105, 168		
		
		/*fwrite( &poly_1_2_h[step_num],  sizeof(float), 1, poly_1_2_file  );
		fwrite( &poly_2_3_h[step_num],  sizeof(float), 1, poly_2_3_file  ); 
		fwrite( &poly_3_4_h[step_num],  sizeof(float), 1, poly_3_4_file  );
		fwrite( &poly_2_6_h[step_num],  sizeof(float), 1, poly_2_6_file  );
		fwrite( &poly_3_12_h[step_num], sizeof(float), 1, poly_3_12_file );*/
		i++;
	}
	fwrite( poly_1_2_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_1_2_file  );
	fwrite( poly_2_3_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_2_3_file  );
	fwrite( poly_3_4_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_3_4_file  );
	fwrite( poly_2_6_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_2_6_file  );
	fwrite( poly_3_12_h, sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_3_12_file );

	fclose( poly_1_2_file  );
	fclose( poly_2_3_file  );
	fclose( poly_3_4_file  );
	fclose( poly_2_6_file  );
	fclose( poly_3_12_file );
	//cout << "i = " << i << endl;														
	//cout << "POLY_TABLE_ELEMENTS = " << POLY_TABLE_ELEMENTS << endl;			
}
void import_trig_tables()
{
	sin_table_h = (double*) calloc( TRIG_TABLE_ELEMENTS + 1, sizeof(double) );
	cos_table_h = (double*) calloc( TRIG_TABLE_ELEMENTS + 1, sizeof(double) );

	sin_table_file = fopen( SIN_TABLE_FILENAME, "rb" );
	cos_table_file = fopen( COS_TABLE_FILENAME, "rb" );
	
	fread(sin_table_h, sizeof(double), TRIG_TABLE_ELEMENTS + 1, sin_table_file );
	fread(cos_table_h, sizeof(double), TRIG_TABLE_ELEMENTS + 1, cos_table_file );
	
	fclose(sin_table_file);
	fclose(cos_table_file);
}
void import_scattering_coefficient_table()
{
	scattering_table_h = (double*)calloc( COEFF_TABLE_ELEMENTS + 1, sizeof(double));
	scattering_table_file = fopen( COEFFICIENT_FILENAME, "rb" );
	fread(scattering_table_h, sizeof(double), COEFF_TABLE_ELEMENTS + 1, scattering_table_file );
	fclose(scattering_table_file);
}
void import_polynomial_tables()
{
	poly_1_2_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_2_3_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_3_4_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_2_6_h  = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );
	poly_3_12_h = (double*) calloc( POLY_TABLE_ELEMENTS + 1, sizeof(double) );

	poly_1_2_file  = fopen( POLY_1_2_FILENAME,  "rb" );
	poly_2_3_file  = fopen( POLY_2_3_FILENAME,  "rb" );
	poly_3_4_file  = fopen( POLY_3_4_FILENAME,  "rb" );
	poly_2_6_file  = fopen( POLY_2_6_FILENAME,  "rb" );
	poly_3_12_file = fopen( POLY_3_12_FILENAME, "rb" );

	fread( poly_1_2_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_1_2_file  );
	fread( poly_2_3_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_2_3_file  );
	fread( poly_3_4_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_3_4_file  );
	fread( poly_2_6_h,  sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_2_6_file  );
	fread( poly_3_12_h, sizeof(double), POLY_TABLE_ELEMENTS + 1, poly_3_12_file );

	fclose( poly_1_2_file  );
	fclose( poly_2_3_file  );
	fclose( poly_3_4_file  );
	fclose( poly_2_6_file  );
	fclose( poly_3_12_file );
}
void MLP_lookup_table_2_GPU()
{
	unsigned int size_trig_tables			= ( TRIG_TABLE_ELEMENTS	 + 1 ) * sizeof(double);
	unsigned int size_coefficient_tables	= ( COEFF_TABLE_ELEMENTS + 1 ) * sizeof(double);
	unsigned int size_poly_tables			= ( POLY_TABLE_ELEMENTS  + 1 ) * sizeof(double);

	cudaMalloc( (void**) &sin_table_d,			size_trig_tables		);
	cudaMalloc( (void**) &cos_table_d,			size_trig_tables		);
	cudaMalloc( (void**) &scattering_table_d,	size_coefficient_tables );
	cudaMalloc( (void**) &poly_1_2_d,			size_poly_tables		);
	cudaMalloc( (void**) &poly_2_3_d,			size_poly_tables		);
	cudaMalloc( (void**) &poly_3_4_d,			size_poly_tables		);	
	cudaMalloc( (void**) &poly_2_6_d,			size_poly_tables		);
	cudaMalloc( (void**) &poly_3_12_d,			size_poly_tables		);

	cudaMemcpy( sin_table_d,		sin_table_h,		size_trig_tables,			cudaMemcpyHostToDevice );
	cudaMemcpy( cos_table_d,		cos_table_h,		size_trig_tables,			cudaMemcpyHostToDevice );
	cudaMemcpy( scattering_table_d, scattering_table_h, size_coefficient_tables,	cudaMemcpyHostToDevice );
	cudaMemcpy( poly_1_2_d,			poly_1_2_h,			size_poly_tables,			cudaMemcpyHostToDevice );
	cudaMemcpy( poly_2_3_d,			poly_2_3_h,			size_poly_tables,			cudaMemcpyHostToDevice );
	cudaMemcpy( poly_3_4_d,			poly_3_4_h,			size_poly_tables,			cudaMemcpyHostToDevice );
	cudaMemcpy( poly_2_6_d,			poly_2_6_h,			size_poly_tables,			cudaMemcpyHostToDevice );
	cudaMemcpy( poly_3_12_d,		poly_3_12_h,		size_poly_tables,			cudaMemcpyHostToDevice );
}
void generate_MLP_lookup_tables()
{
	generate_trig_tables();
	generate_scattering_coefficient_table();
	generate_polynomial_tables();
	MLP_lookup_table_2_GPU();
}
void free_MLP_lookup_tables()
{
	free( sin_table_h);
	free( cos_table_h);
	free( scattering_table_h);
	free( poly_1_2_h);
	free( poly_2_3_h);
	free( poly_3_4_h);
	free( poly_2_6_h);
	free( poly_3_12_h);

	cudaFree( sin_table_d);
	cudaFree( cos_table_d);
	cudaFree( scattering_table_d);
	cudaFree( poly_1_2_d);
	cudaFree( poly_2_3_d);
	cudaFree( poly_3_4_d);
	cudaFree( poly_2_6_d);
	cudaFree( poly_3_12_d);

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("free_MLP_lookup_tables Error: %s\n", cudaGetErrorString(cudaStatus));
	
}
/***********************************************************************************************************************************************************************************************************************/
/************************************************************************************************** Generate initial iterate *******************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void create_hull_image_hybrid()
{
	dim3 dimBlock( SLICES );
	dim3 dimGrid( COLUMNS, ROWS );   

	create_hull_image_hybrid_GPU<<< dimGrid, dimBlock >>>( hull_d, FBP_image_d );
	cudaMemcpy( x_h, FBP_image_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost );
}
__global__ void create_hull_image_hybrid_GPU( bool*& hull, float*& FBP_image)
{
	int row = blockIdx.y, column = blockIdx.x, slice = threadIdx.x;
	int voxel = column + row * COLUMNS + slice * COLUMNS * ROWS;
	FBP_image[voxel] *= hull[voxel];
}
void export_initial_iterate()
{
//	puts("Writing image reconstruction hull to disk...");
//	char input_hull_filename[256];
//	sprintf(endpoints_filename, "%s%s/%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, INPUT_HULL_FILENAME );
//	FILE* write_input_hull = fopen(input_hull_filename, "wb");
//	fwrite( &hull_h, sizeof(bool), NUM_VOXELS, write_input_hull );
//	fclose(write_input_hull);
//	puts("Finished writing image reconstruction hull to disk.");
}
void import_initial_iterate()
{
//	puts("Reading image reconstruction hull from disk...");
//	char input_hull_filename[256];
//	sprintf(endpoints_filename, "%s%s/%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, INPUT_HULL_FILENAME );
//	FILE* read_input_hull = fopen(input_hull_filename, "rb");
//	hull_h = (bool*)calloc( NUM_VOXELS, sizeof(bool) );
//	fwrite( &hull_h, sizeof(bool), NUM_VOXELS, read_input_hull );
//	fclose(read_input_hull);
//	puts("Finished reading image reconstruction hull from disk.");
}
void initial_iterate_generate_hybrid()
{
	for( int voxel = 0; voxel < NUM_VOXELS; voxel++ )
	{
		if( hull_h[voxel] == true )
			x_h[voxel] = FBP_image_h[voxel];
		else
			x_h[voxel] = 0.0;
	}
}
void define_initial_iterate()
{
	//char statement[] = "Generating initial iterate...";	
	sprintf( print_statement, "Generating initial iterate...");		
	print_colored_text( print_statement, LIGHT, CYAN );	
	
	x_h = (float*) calloc( NUM_VOXELS, sizeof(float) );

	switch( X_0 )
	{
		case X_HULL		:	std::copy( hull_h, hull_h + NUM_VOXELS, x_h );															break;
		case FBP_IMAGE	:	x_h = FBP_image_h;																						break;
		case HYBRID		:	initial_iterate_generate_hybrid();																		break;
							//std::transform(FBP_image_h, FBP_image_h + NUM_VOXELS, hull_h, x_h, std::multiplies<float>() );		break;
		case IMPORT		:	sprintf( INPUT_ITERATE_PATH, "%s%s/%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, INPUT_ITERATE_FILENAME );
							import_image( x_h, INPUT_ITERATE_PATH );																break;
		case ZEROS		:	break;
		default			:	puts("ERROR: Invalid initial iterate selected");
							exit(1);
	}

	//if( AVG_FILTER_ITERATE )
	//{
	//	puts("Filtering initial iterate...");
	//	cudaMalloc((void**) &x_d, SIZE_IMAGE_FLOAT );
	//	cudaMemcpy( x_d, x_h, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice );
	//	averaging_filter( x_h, x_d, ITERATE_AVG_FILTER_RADIUS, true, ITERATE_AVG_FILTER_THRESHOLD );
	//	puts("Hull Filtering complete");
	//	if( WRITE_FILTERED_HULL )
	//	{
	//		puts("Writing filtered hull to disk...");
	//		cudaMemcpy(x_h, x_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost) ;
	//		array_2_disk( "hull_filtered", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, hull_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	//	}
	//}

	if( WRITE_X_0 ) 
		array_2_disk(X_0_FILENAME, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	//cudaMalloc((void**) &x_d, SIZE_IMAGE_FLOAT );
	//cudaMemcpy( x_d, x_h, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice );
}
/***********************************************************************************************************************************************************************************************************************/
/******************************************************************************************* Generate history ordering for reconstruction ******************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void generate_history_sequence(ULL N, ULL offset_prime, ULL* history_sequence )
{
    history_sequence[0] = 0;
    for( ULL i = 1; i < N; i++ )
        history_sequence[i] = ( history_sequence[i-1] + offset_prime ) % N;
}
void verify_history_sequence(ULL N, ULL offset_prime, ULL* history_sequence )
{
	for( ULL i = 1; i < N; i++ )
    {
        if(history_sequence[i] == 1)
        {
            printf("repeats at i = %llu\n", i);
            printf("sequence[i] = %llu\n", history_sequence[i]);
            break;
        }
        if(history_sequence[i] > N)
        {
            printf("exceeds at i = %llu\n", i);
            printf("sequence[i] = %llu\n", history_sequence[i]);
            break;
        }
    }
}
void print_history_sequence(ULL* history_sequence, ULL print_start, ULL print_end )
{
    for( ULL i = print_start; i < print_end; i++ )
		printf("history_sequence[i] = %llu\n", history_sequence[i]);
}
/**************************************************************************************************************************************************************************/
/******************************************* MLP and image update calculations/applications Image Reconstruction Routines *************************************************/
/**************************************************************************************************************************************************************************/
// Return index of blob for given lattice coordinate (x,y,z)
int BlobIndex(int x, int y, int z)
{
    if(x >= 0 && y >= 0 && z >= 0)
        if( x < COLUMNS && y < ROWS && z < SLICES)
            return x + y * COLUMNS + z * COLUMNS * ROWS;

    return -1;
}
__device__ int BlobIndex_GPU(int x, int y, int z)
{
    if(x >= 0 && y >= 0 && z >= 0)
        if( x < COLUMNS && y < ROWS && z < SLICES)
            return x + y * COLUMNS + z * COLUMNS * ROWS;

    return -1;
}
__device__ double EffectiveChordLength_GPU(double abs_angle_t, double abs_angle_v)
{
	
	double eff_angle_t,eff_angle_v;
	
	eff_angle_t=abs_angle_t-((int)(abs_angle_t/(PI/2)))*(PI/2);
	
	eff_angle_v=fabs(abs_angle_v);
	
	// Get the effective chord in the t-u plane
	double step_fraction=MLP_U_STEP/VOXEL_WIDTH;
	double chord_length_2D=(1/3.0)*((step_fraction*step_fraction*sinf(2*eff_angle_t)-6)/(step_fraction*sinf(2*eff_angle_t)-2*(cosf(eff_angle_t)+sinf(eff_angle_t))) + step_fraction*step_fraction*sinf(2*eff_angle_t)/(2*(cosf(eff_angle_t)+sinf(eff_angle_t))));
	
	// Multiply this by the effective chord in the v-u plane
	double mean_pixel_width=VOXEL_WIDTH/(cosf(eff_angle_t)+sinf(eff_angle_t));
	double height_fraction=VOXEL_THICKNESS/mean_pixel_width;
	step_fraction=MLP_U_STEP/mean_pixel_width;
	double chord_length_3D=(1/3.0)*((step_fraction*step_fraction*sinf(2*eff_angle_v)-6*height_fraction)/(step_fraction*sinf(2*eff_angle_v)-2*(height_fraction*cosf(eff_angle_v)+sinf(eff_angle_v))) + step_fraction*step_fraction*sinf(2*eff_angle_v)/(2*(height_fraction*cosf(eff_angle_v)+sinf(eff_angle_v))));
	
	return VOXEL_WIDTH*chord_length_2D*chord_length_3D;
	 
}
__device__ int find_MLP_GPU 
(
	float* x, double b_i, unsigned int first_MLP_voxel_number, double x_in_object, double y_in_object, double z_in_object, 
	double x_out_object, double y_out_object, double z_out_object, double xy_entry_angle, double xz_entry_angle, double xy_exit_angle, double xz_exit_angle,
	double lambda, unsigned int* MLP, double effective_chord_length, double& a_i_dot_x_k, double& a_i_dot_a_i
) 
{
  
	//bool debug_output = false, MLP_image_output = false;
	//bool constant_A_ij = true;
	// MLP calculations variables
	int number_of_intersections = 0;
	double u_0 = 0.0, u_1 = MLP_U_STEP,  u_2 = 0.0;
	double T_0[2] = {0.0, 0.0};
	double T_2[2] = {0.0, 0.0};
	double V_0[2] = {0.0, 0.0};
	double V_2[2] = {0.0, 0.0};
	double R_0[4] = { 1.0, 0.0, 0.0 , 1.0}; //a,b,c,d
	double R_1[4] = { 1.0, 0.0, 0.0 , 1.0}; //a,b,c,d
	double R_1T[4] = { 1.0, 0.0, 0.0 , 1.0};  //a,c,b,d

	double sigma_2_pre_1, sigma_2_pre_2, sigma_2_pre_3;
	double sigma_1_coefficient, sigma_t1, sigma_t1_theta1, sigma_theta1, determinant_Sigma_1, Sigma_1I[4];
	double common_sigma_2_term_1, common_sigma_2_term_2, common_sigma_2_term_3;
	double sigma_2_coefficient, sigma_t2, sigma_t2_theta2, sigma_theta2, determinant_Sigma_2, Sigma_2I[4]; 
	double first_term_common_13_1, first_term_common_13_2, first_term_common_24_1, first_term_common_24_2, first_term[4], determinant_first_term;
	double second_term_common_1, second_term_common_2, second_term_common_3, second_term_common_4, second_term[2];
	double t_1, v_1, x_1, y_1, z_1;
	double first_term_inversion_temp;
	
	//double a_i_dot_x_k = 0.0;
	//double a_i_dot_a_i = 0.0;
	
	//double theta_1, phi_1;
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle + xy_exit_angle ) / 2.0, ( xz_entry_angle + xz_exit_angle) / 2.0 );
	//double a_j_times_a_j = effective_chord_length * effective_chord_length;
	
	//double effective_chord_length = mean_chord_length( u_in_object, t_in_object, v_in_object, u_out_object, t_out_object, v_out_object );
	//double effective_chord_length = VOXEL_WIDTH;

	int voxel_x = 0, voxel_y = 0, voxel_z = 0;
	
	int voxel = first_MLP_voxel_number;
	
	MLP[number_of_intersections] = voxel;
	//MLP[number_of_intersections] = voxel;
	a_i_dot_x_k = x[voxel];
	//a_i_dot_a_i += a_j_times_a_j;
	a_i_dot_a_i = pow(effective_chord_length, 2);
	//atomicAdd(S[voxel], 1);
	//if(!constant_A_ij)
		//A_ij[num_intersections] = VOXEL_WIDTH;
	number_of_intersections++;
	//MLP_test_image_h[voxel] = 0;

	double u_in_object = ( cos( xy_entry_angle ) * x_in_object ) + ( sin( xy_entry_angle ) * y_in_object );
	double u_out_object = ( cos( xy_entry_angle ) * x_out_object ) + ( sin( xy_entry_angle ) * y_out_object );
	double t_in_object = ( cos( xy_entry_angle ) * y_in_object ) - ( sin( xy_entry_angle ) * x_in_object );
	double t_out_object = ( cos( xy_entry_angle ) * y_out_object ) - ( sin( xy_entry_angle ) * x_out_object );
	double v_in_object = z_in_object;
	double v_out_object = z_out_object;

	if( u_in_object > u_out_object )
	{
		//if( debug_output )
			//cout << "Switched directions" << endl;
		xy_entry_angle += PI;
		xy_exit_angle += PI;
		u_in_object = ( cos( xy_entry_angle ) * x_in_object ) + ( sin( xy_entry_angle ) * y_in_object );
		u_out_object = ( cos( xy_entry_angle ) * x_out_object ) + ( sin( xy_entry_angle ) * y_out_object );
		t_in_object = ( cos( xy_entry_angle ) * y_in_object ) - ( sin( xy_entry_angle ) * x_in_object );
		t_out_object = ( cos( xy_entry_angle ) * y_out_object ) - ( sin( xy_entry_angle ) * x_out_object );
		v_in_object = z_in_object;
		v_out_object = z_out_object;
	}
	T_0[0] = t_in_object;
	T_2[0] = t_out_object;
	T_2[1] = xy_exit_angle - xy_entry_angle;
	V_0[0] = v_in_object;
	V_2[0] = v_out_object;
	V_2[1] = xz_exit_angle - xz_entry_angle;
		
	u_0 = 0.0;
	u_1 = MLP_U_STEP;
	u_2 = abs(u_out_object - u_in_object);		
	//fgets(user_response, sizeof(user_response), stdin);

	//output_file.open(filename);						
				      
	//precalculated u_2 dependent terms (since u_2 does not change inside while loop)
	//u_2 terms
	sigma_2_pre_1 =  u_2*u_2*u_2 * ( A_0_OVER_3 + u_2 * ( A_1_OVER_12 + u_2 * ( A_2_OVER_30 + u_2 * (A_3_OVER_60 + u_2 * ( A_4_OVER_105 + u_2 * A_5_OVER_168 )))));;	//u_2^3 : 1/3, 1/12, 1/30, 1/60, 1/105, 1/168
	sigma_2_pre_2 =  u_2*u_2 * ( A_0_OVER_2 + u_2 * (A_1_OVER_6 + u_2 * (A_2_OVER_12 + u_2 * ( A_3_OVER_20 + u_2 * (A_4_OVER_30 + u_2 * A_5_OVER_42)))));	//u_2^2 : 1/2, 1/6, 1/12, 1/20, 1/30, 1/42
	sigma_2_pre_3 =  u_2 * ( A_0 +  u_2 * (A_1_OVER_2 +  u_2 * ( A_2_OVER_3 +  u_2 * ( A_3_OVER_4 +  u_2 * ( A_4_OVER_5 + u_2 * A_5_OVER_6 )))));			//u_2 : 1/1, 1/2, 1/3, 1/4, 1/5, 1/6

	while( u_1 < u_2 - MLP_U_STEP)
	//while( u_1 < u_2 - 0.001)
	{
		R_0[1] = u_1;
		R_1[1] = u_2 - u_1;
		R_1T[2] = u_2 - u_1;

		sigma_1_coefficient = pow( E_0 * ( 1 + 0.038 * log( (u_1 - u_0)/X0) ), 2.0 ) / X0;
		sigma_t1 =  sigma_1_coefficient * ( pow(u_1, 3.0) * ( A_0_OVER_3 + u_1 * (A_1_OVER_12 + u_1 * (A_2_OVER_30 + u_1 * (A_3_OVER_60 + u_1 * (A_4_OVER_105 + u_1 * A_5_OVER_168 ) )))) );	//u_1^3 : 1/3, 1/12, 1/30, 1/60, 1/105, 1/168
		sigma_t1_theta1 =  sigma_1_coefficient * ( pow(u_1, 2.0) * ( A_0_OVER_2 + u_1 * (A_1_OVER_6 + u_1 * (A_2_OVER_12 + u_1 * (A_3_OVER_20 + u_1 * (A_4_OVER_30 + u_1 * A_5_OVER_42))))) );	//u_1^2 : 1/2, 1/6, 1/12, 1/20, 1/30, 1/42															
		sigma_theta1 = sigma_1_coefficient * ( u_1 * ( A_0 + u_1 * (A_1_OVER_2 + u_1 * (A_2_OVER_3 + u_1 * (A_3_OVER_4 + u_1 * (A_4_OVER_5 + u_1 * A_5_OVER_6))))) );			//u_1 : 1/1, 1/2, 1/3, 1/4, 1/5, 1/6																	
		determinant_Sigma_1 = sigma_t1 * sigma_theta1 - pow( sigma_t1_theta1, 2 );//ad-bc
			
		Sigma_1I[0] = sigma_theta1 / determinant_Sigma_1;
		Sigma_1I[1] = -sigma_t1_theta1 / determinant_Sigma_1;
		Sigma_1I[2] = -sigma_t1_theta1 / determinant_Sigma_1;
		Sigma_1I[3] = sigma_t1 / determinant_Sigma_1;

		//sigma 2 terms
		sigma_2_coefficient = pow( E_0 * ( 1 + 0.038 * log( (u_2 - u_1)/X0) ), 2.0 ) / X0;
		common_sigma_2_term_1 = u_1 * ( A_0 + u_1 * (A_1_OVER_2 + u_1 * (A_2_OVER_3 + u_1 * (A_3_OVER_4 + u_1 * (A_4_OVER_5 + u_1 * A_5_OVER_6 )))));
		common_sigma_2_term_2 = pow(u_1, 2.0) * ( A_0_OVER_2 + u_1 * (A_1_OVER_3 + u_1 * (A_2_OVER_4 + u_1 * (A_3_OVER_5 + u_1 * (A_4_OVER_6 + u_1 * A_5_OVER_7 )))));
		common_sigma_2_term_3 = pow(u_1, 3.0) * ( A_0_OVER_3 + u_1 * (A_1_OVER_4 + u_1 * (A_2_OVER_5 + u_1 * (A_3_OVER_6 + u_1 * (A_4_OVER_7 + u_1 * A_5_OVER_8 )))));
		sigma_t2 =  sigma_2_coefficient * ( sigma_2_pre_1 - pow(u_2, 2.0) * common_sigma_2_term_1 + 2 * u_2 * common_sigma_2_term_2 - common_sigma_2_term_3 );
		sigma_t2_theta2 =  sigma_2_coefficient * ( sigma_2_pre_2 - u_2 * common_sigma_2_term_1 + common_sigma_2_term_2 );
		sigma_theta2 =  sigma_2_coefficient * ( sigma_2_pre_3 - common_sigma_2_term_1 );				
		determinant_Sigma_2 = sigma_t2 * sigma_theta2 - pow( sigma_t2_theta2, 2 );//ad-bc

		Sigma_2I[0] = sigma_theta2 / determinant_Sigma_2;
		Sigma_2I[1] = -sigma_t2_theta2 / determinant_Sigma_2;
		Sigma_2I[2] = -sigma_t2_theta2 / determinant_Sigma_2;
		Sigma_2I[3] = sigma_t2 / determinant_Sigma_2;

		// first_term_common_ij_k: i,j = rows common to, k = 1st/2nd of last 2 terms of 3 term summation in first_term calculation below
		first_term_common_13_1 = Sigma_2I[0] * R_1[0] + Sigma_2I[1] * R_1[2];
		first_term_common_13_2 = Sigma_2I[2] * R_1[0] + Sigma_2I[3] * R_1[2];
		first_term_common_24_1 = Sigma_2I[0] * R_1[1] + Sigma_2I[1] * R_1[3];
		first_term_common_24_2 = Sigma_2I[2] * R_1[1] + Sigma_2I[3] * R_1[3];

		first_term[0] = Sigma_1I[0] + R_1T[0] * first_term_common_13_1 + R_1T[1] * first_term_common_13_2;
		first_term[1] = Sigma_1I[1] + R_1T[0] * first_term_common_24_1 + R_1T[1] * first_term_common_24_2;
		first_term[2] = Sigma_1I[2] + R_1T[2] * first_term_common_13_1 + R_1T[3] * first_term_common_13_2;
		first_term[3] = Sigma_1I[3] + R_1T[2] * first_term_common_24_1 + R_1T[3] * first_term_common_24_2;


		determinant_first_term = first_term[0] * first_term[3] - first_term[1] * first_term[2];
		first_term_inversion_temp = first_term[0];
		first_term[0] = first_term[3] / determinant_first_term;
		first_term[1] = -first_term[1] / determinant_first_term;
		first_term[2] = -first_term[2] / determinant_first_term;
		first_term[3] = first_term_inversion_temp / determinant_first_term;

		// second_term_common_i: i = # of term of 4 term summation it is common to in second_term calculation below
		second_term_common_1 = R_0[0] * T_0[0] + R_0[1] * T_0[1];
		second_term_common_2 = R_0[2] * T_0[0] + R_0[3] * T_0[1];
		second_term_common_3 = Sigma_2I[0] * T_2[0] + Sigma_2I[1] * T_2[1];
		second_term_common_4 = Sigma_2I[2] * T_2[0] + Sigma_2I[3] * T_2[1];

		second_term[0] = Sigma_1I[0] * second_term_common_1 
						+ Sigma_1I[1] * second_term_common_2 
						+ R_1T[0] * second_term_common_3 
						+ R_1T[1] * second_term_common_4;
		second_term[1] = Sigma_1I[2] * second_term_common_1 
						+ Sigma_1I[3] * second_term_common_2 
						+ R_1T[2] * second_term_common_3 
						+ R_1T[3] * second_term_common_4;

		t_1 = first_term[0] * second_term[0] + first_term[1] * second_term[1];
		//cout << "t_1 = " << t_1 << endl;
		//double theta_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];

		// Do v MLP Now
		second_term_common_1 = R_0[0] * V_0[0] + R_0[1] * V_0[1];
		second_term_common_2 = R_0[2] * V_0[0] + R_0[3] * V_0[1];
		second_term_common_3 = Sigma_2I[0] * V_2[0] + Sigma_2I[1] * V_2[1];
		second_term_common_4 = Sigma_2I[2] * V_2[0] + Sigma_2I[3] * V_2[1];

		second_term[0]	= Sigma_1I[0] * second_term_common_1
						+ Sigma_1I[1] * second_term_common_2
						+ R_1T[0] * second_term_common_3
						+ R_1T[1] * second_term_common_4;
		second_term[1]	= Sigma_1I[2] * second_term_common_1
						+ Sigma_1I[3] * second_term_common_2
						+ R_1T[2] * second_term_common_3
						+ R_1T[3] * second_term_common_4;
		v_1 = first_term[0] * second_term[0] + first_term[1] * second_term[1];
		//double phi_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];

		// Rotate Coordinate From utv to xyz Coordinate System and Determine Which Voxel this Point on the MLP Path is in
		x_1 = ( cos( xy_entry_angle ) * (u_in_object + u_1) ) - ( sin( xy_entry_angle ) * t_1 );
		y_1 = ( sin( xy_entry_angle ) * (u_in_object + u_1) ) + ( cos( xy_entry_angle ) * t_1 );
		z_1 = v_1;

		voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x_1, VOXEL_WIDTH );
		voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_1, VOXEL_HEIGHT );
		voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, z_1, VOXEL_THICKNESS);
				
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
		//cout << "voxel_x = " << voxel_x << "voxel_y = " << voxel_y << "voxel_z = " << voxel_z << "voxel = " << voxel <<endl;
		//fgets(user_response, sizeof(user_response), stdin);


		if( voxel != MLP[number_of_intersections - 1] )
		{
			//MLP[number_of_intersections] = voxel;
			MLP[number_of_intersections] = voxel;
			a_i_dot_x_k += x[voxel];
			//a_i_dot_a_i += a_j_times_a_j;
			//atomicAdd(S[voxel], 1);
			//MLP_test_image_h[voxel] = 0;
			//if(!constant_A_ij)
				//A_ij[num_intersections] = effective_chord_length;						
			number_of_intersections++;
		}
		u_1 += MLP_U_STEP;
	}	
	a_i_dot_x_k *= effective_chord_length;
	a_i_dot_a_i *= number_of_intersections;
	//update_value_history = effective_chord_length * (( b_i - a_i_dot_x_k ) /  a_i_dot_a_i) * lambda;
	//return update_value;
	return number_of_intersections;
}
__device__ int find_MLP_GPU_tabulated
(
	float* x, double b_i, unsigned int first_MLP_voxel_number, double x_in_object, double y_in_object, double z_in_object, 
	double x_out_object, double y_out_object, double z_out_object, double xy_entry_angle, double xz_entry_angle, double xy_exit_angle, double xz_exit_angle,
	double lambda, unsigned int* MLP, double effective_chord_length, double& a_i_dot_x_k, double& a_i_dot_a_i,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{
	double sigma_t1, sigma_t1_theta1, sigma_theta1, determinant_Sigma_1, Sigma_1I[3];
	double sigma_t2, sigma_t2_theta2, sigma_theta2, determinant_Sigma_2, Sigma_2I[3]; 
	double first_term_common_24_1, first_term[4], determinant_first_term;
	double second_term_common_3, second_term[2];
	double t_1, v_1, x_1, y_1;
	int voxel_x = 0, voxel_y = 0, voxel_z = 0;

	unsigned int trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
	double sin_term = sin_table[trig_table_index];
	double cos_term = cos_table[trig_table_index];
	 
	double u_in_object = cos_term * x_in_object + sin_term * y_in_object;
	double u_out_object = cos_term * x_out_object + sin_term * y_out_object;

	if( u_in_object > u_out_object )
	{
		xy_entry_angle += PI;
		xy_exit_angle += PI;
		trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
		sin_term = sin_table[trig_table_index];
		cos_term = cos_table[trig_table_index];
		u_in_object = cos_term * x_in_object + sin_term * y_in_object;
		u_out_object = cos_term * x_out_object + sin_term * y_out_object;
	}
	double t_in_object = cos_term * y_in_object  - sin_term * x_in_object;
	double t_out_object = cos_term * y_out_object - sin_term * x_out_object;
	
	double T_2[2] = {t_out_object, xy_exit_angle - xy_entry_angle};
	double V_2[2] = {z_out_object, xz_exit_angle - xz_entry_angle};
	double u_1 = MLP_U_STEP;
	double u_2 = abs(u_out_object - u_in_object);
	double depth_2_go = u_2 - u_1;
	double u_shifted = u_in_object;	
	//unsigned int step_number = 1;

	// Scattering Coefficient tables indices
	unsigned int sigma_table_index_step = static_cast<unsigned int>( MLP_U_STEP / COEFF_TABLE_STEP + 0.5 );
	unsigned int sigma_1_coefficient_index = sigma_table_index_step;
	unsigned int sigma_2_coefficient_index = static_cast<unsigned int>( depth_2_go / COEFF_TABLE_STEP + 0.5 );
	
	// Scattering polynomial indices
	unsigned int poly_table_index_step = static_cast<unsigned int>( MLP_U_STEP / POLY_TABLE_STEP + 0.5 );
	unsigned int u_1_poly_index = poly_table_index_step;
	unsigned int u_2_poly_index = static_cast<unsigned int>( u_2 / POLY_TABLE_STEP + 0.5 );

	//precalculated u_2 dependent terms (since u_2 does not change inside while loop)
	double u_2_poly_3_12 = poly_3_12[u_2_poly_index];
	double u_2_poly_2_6 = poly_2_6[u_2_poly_index];
	double u_2_poly_1_2 = poly_1_2[u_2_poly_index];
	double u_1_poly_1_2, u_1_poly_2_3;

	int voxel = first_MLP_voxel_number;
	int number_of_intersections = 0;
	MLP[number_of_intersections] = voxel;
	number_of_intersections++;

	//effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle + xy_exit_angle ) / 2.0, ( xz_entry_angle + xz_exit_angle) / 2.0 );
	//double effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle + xy_exit_angle ) / 2.0, ( xz_entry_angle + xz_exit_angle) / 2.0 );
	//double a_j_times_a_j = effective_chord_length * effective_chord_length;
	a_i_dot_x_k = x[voxel];
	a_i_dot_a_i = pow(effective_chord_length, 2.0);
	//double a_i_dot_x_k = x[voxel] * effective_chord_length;
	//double a_i_dot_a_i = a_j_times_a_j;

	//while( u_1 < u_2 - configurations.MLP_U_STEP)
	while( depth_2_go > MLP_U_STEP )
	{
		u_1_poly_1_2 = poly_1_2[u_1_poly_index];
		u_1_poly_2_3 = poly_2_3[u_1_poly_index];

		sigma_t1 = poly_3_12[u_1_poly_index];										// poly_3_12(u_1)
		sigma_t1_theta1 =  poly_2_6[u_1_poly_index];								// poly_2_6(u_1) 
		sigma_theta1 = u_1_poly_1_2;												// poly_1_2(u_1)

		sigma_t2 =  u_2_poly_3_12 - pow(u_2, 2.0) * u_1_poly_1_2 + 2 * u_2 * u_1_poly_2_3 - poly_3_4[u_1_poly_index];	// poly_3_12(u_2) - u_2^2 * poly_1_2(u_1) +2u_2*(u_1) - poly_3_4(u_1)
		sigma_t2_theta2 =  u_2_poly_2_6 - u_2 * u_1_poly_1_2 + u_1_poly_2_3;											// poly_2_6(u_2) - u_2*poly_1_2(u_1) + poly_2_3(u_1)
		sigma_theta2 =  u_2_poly_1_2 - u_1_poly_1_2;																	// poly_1_2(u_2) - poly_1_2(u_1)	

		determinant_Sigma_1 = scattering_table[sigma_1_coefficient_index] * ( sigma_t1 * sigma_theta1 - pow( sigma_t1_theta1, 2 ) );//ad-bc
		Sigma_1I[0] = sigma_theta1 / determinant_Sigma_1;
		Sigma_1I[1] = sigma_t1_theta1 / determinant_Sigma_1;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_1I[2] = sigma_t1 / determinant_Sigma_1;			
			
		determinant_Sigma_2 = scattering_table[sigma_2_coefficient_index] * ( sigma_t2 * sigma_theta2 - pow( sigma_t2_theta2, 2 ) );//ad-bc
		Sigma_2I[0] = sigma_theta2 / determinant_Sigma_2;
		Sigma_2I[1] = sigma_t2_theta2 / determinant_Sigma_2;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_2I[2] = sigma_t2 / determinant_Sigma_2;
		/**********************************************************************************************************************************************************/
		first_term_common_24_1 = Sigma_2I[0] * depth_2_go - Sigma_2I[1];
		first_term[0] = Sigma_1I[0] + Sigma_2I[0];
		first_term[1] = first_term_common_24_1 - Sigma_1I[1];
		first_term[2] = depth_2_go * Sigma_2I[0] - Sigma_1I[1] - Sigma_2I[1];
		first_term[3] = Sigma_1I[2] + Sigma_2I[2] + depth_2_go * ( first_term_common_24_1 - Sigma_2I[1]);	
		determinant_first_term = first_term[0] * first_term[3] - first_term[1] * first_term[2];
		
		// Calculate MLP t coordinate
		second_term_common_3 = Sigma_2I[0] * t_out_object - Sigma_2I[1] * T_2[1];	
		second_term[0] = Sigma_1I[0] * t_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * T_2[1] - Sigma_2I[1] * t_out_object - Sigma_1I[1] * t_in_object;	
		t_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double theta_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Calculate MLP v coordinate
		second_term_common_3 = Sigma_2I[0] * z_out_object - Sigma_2I[1] * V_2[1];
		second_term[0] = Sigma_1I[0] * z_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * V_2[1] - Sigma_2I[1] * z_out_object - Sigma_1I[1] * z_in_object;
		v_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double phi_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Rotate Coordinate From utv to xyz Coordinate System and Determine Which Voxel this Point on the MLP Path is in
		u_shifted += MLP_U_STEP;
		//u_shifted = u_in_object + u_1;

		x_1 = cos_term * u_shifted - sin_term * t_1;
		y_1 = sin_term * u_shifted + cos_term * t_1;

		voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x_1, VOXEL_WIDTH );
		voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_1, VOXEL_HEIGHT );
		voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, v_1, VOXEL_THICKNESS);			
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;

		//if( voxel != MLP[num_intersections] )
		//{
		//	MLP[++num_intersections] = voxel;	
		//	a_i_dot_x_k += x[voxel] * effective_chord_length;
		//	//a_i_dot_x_k += x[voxel];
		//	a_i_dot_a_i += a_j_times_a_j;
		//}
		if( voxel != MLP[number_of_intersections-1] )
		{
			MLP[number_of_intersections] = voxel;	
			//a_i_dot_x_k += x[voxel] * effective_chord_length;
			a_i_dot_x_k += x[voxel];
			//a_i_dot_a_i += a_j_times_a_j;
			number_of_intersections++;
		}
		u_1 += MLP_U_STEP;
		depth_2_go -= MLP_U_STEP;
		//step_number++;
		//u_1 = step_number * MLP_U_STEP;
		//depth_2_go = u_2 - u_1;
		sigma_1_coefficient_index += sigma_table_index_step;
		sigma_2_coefficient_index -= sigma_table_index_step;
		u_1_poly_index += poly_table_index_step;
	}
	//++num_intersections;
	//a_i_dot_x_k *= effective_chord_length;
	//a_i_dot_a_i *= num_intersections;
	a_i_dot_x_k *= effective_chord_length;
	a_i_dot_a_i *= number_of_intersections;
	//update_value_history = effective_chord_length * (( b_i - a_i_dot_x_k ) /  a_i_dot_a_i) * lambda;
	return number_of_intersections;
}
__device__ int find_MLP_GPU_tabulated_exact
(
	float* x, double b_i, unsigned int first_MLP_voxel_number, double x_in_object, double y_in_object, double z_in_object, 
	double x_out_object, double y_out_object, double z_out_object, double xy_entry_angle, double xz_entry_angle, double xy_exit_angle, double xz_exit_angle,
	double lambda, unsigned int* MLP, float* a_i, double& a_i_dot_x_k, double& a_i_dot_a_i,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{
	double sigma_t1, sigma_t1_theta1, sigma_theta1, determinant_Sigma_1, Sigma_1I[3];
	double sigma_t2, sigma_t2_theta2, sigma_theta2, determinant_Sigma_2, Sigma_2I[3]; 
	double first_term_common_24_1, first_term[4], determinant_first_term;
	double second_term_common_3, second_term[2];
	double t_1, v_1, x_1, y_1;
	int voxel_x = 0, voxel_y = 0, voxel_z = 0;

	unsigned int trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
	double sin_term = sin_table[trig_table_index];
	double cos_term = cos_table[trig_table_index];
	 
	double u_in_object = cos_term * x_in_object + sin_term * y_in_object;
	double u_out_object = cos_term * x_out_object + sin_term * y_out_object;

	if( u_in_object > u_out_object )
	{
		xy_entry_angle += PI;
		xy_exit_angle += PI;
		trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
		sin_term = sin_table[trig_table_index];
		cos_term = cos_table[trig_table_index];
		u_in_object = cos_term * x_in_object + sin_term * y_in_object;
		u_out_object = cos_term * x_out_object + sin_term * y_out_object;
	}
	double t_in_object = cos_term * y_in_object  - sin_term * x_in_object;
	double t_out_object = cos_term * y_out_object - sin_term * x_out_object;
	
	double T_2[2] = {t_out_object, xy_exit_angle - xy_entry_angle};
	double V_2[2] = {z_out_object, xz_exit_angle - xz_entry_angle};
	double u_1 = MLP_U_STEP;
	double u_2 = abs(u_out_object - u_in_object);
	double depth_2_go = u_2 - u_1;
	double u_shifted = u_in_object;	
	//unsigned int step_number = 1;

	// Scattering Coefficient tables indices
	unsigned int sigma_table_index_step = static_cast<unsigned int>( MLP_U_STEP / COEFF_TABLE_STEP + 0.5 );
	unsigned int sigma_1_coefficient_index = sigma_table_index_step;
	unsigned int sigma_2_coefficient_index = static_cast<unsigned int>( depth_2_go / COEFF_TABLE_STEP + 0.5 );
	
	// Scattering polynomial indices
	unsigned int poly_table_index_step = static_cast<unsigned int>( MLP_U_STEP / POLY_TABLE_STEP + 0.5 );
	unsigned int u_1_poly_index = poly_table_index_step;
	unsigned int u_2_poly_index = static_cast<unsigned int>( u_2 / POLY_TABLE_STEP + 0.5 );

	//precalculated u_2 dependent terms (since u_2 does not change inside while loop)
	double u_2_poly_3_12 = poly_3_12[u_2_poly_index];
	double u_2_poly_2_6 = poly_2_6[u_2_poly_index];
	double u_2_poly_1_2 = poly_1_2[u_2_poly_index];
	double u_1_poly_1_2, u_1_poly_2_3;

	int voxel = first_MLP_voxel_number;
	int number_of_intersections = 0;
	double effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle + xy_exit_angle ) / 2.0, ( xz_entry_angle + xz_exit_angle) / 2.0 );
	MLP[number_of_intersections] = voxel;
	a_i[number_of_intersections] = effective_chord_length;
	a_i_dot_x_k = effective_chord_length * x[voxel];
	a_i_dot_a_i = pow(effective_chord_length, 2.0);
	number_of_intersections++;

	//while( u_1 < u_2 - configurations.MLP_U_STEP)
	while( depth_2_go > MLP_U_STEP )
	{
		u_1_poly_1_2 = poly_1_2[u_1_poly_index];
		u_1_poly_2_3 = poly_2_3[u_1_poly_index];

		sigma_t1 = poly_3_12[u_1_poly_index];										// poly_3_12(u_1)
		sigma_t1_theta1 =  poly_2_6[u_1_poly_index];								// poly_2_6(u_1) 
		sigma_theta1 = u_1_poly_1_2;												// poly_1_2(u_1)

		sigma_t2 =  u_2_poly_3_12 - pow(u_2, 2.0) * u_1_poly_1_2 + 2 * u_2 * u_1_poly_2_3 - poly_3_4[u_1_poly_index];	// poly_3_12(u_2) - u_2^2 * poly_1_2(u_1) +2u_2*(u_1) - poly_3_4(u_1)
		sigma_t2_theta2 =  u_2_poly_2_6 - u_2 * u_1_poly_1_2 + u_1_poly_2_3;											// poly_2_6(u_2) - u_2*poly_1_2(u_1) + poly_2_3(u_1)
		sigma_theta2 =  u_2_poly_1_2 - u_1_poly_1_2;																	// poly_1_2(u_2) - poly_1_2(u_1)	

		determinant_Sigma_1 = scattering_table[sigma_1_coefficient_index] * ( sigma_t1 * sigma_theta1 - pow( sigma_t1_theta1, 2 ) );//ad-bc
		Sigma_1I[0] = sigma_theta1 / determinant_Sigma_1;
		Sigma_1I[1] = sigma_t1_theta1 / determinant_Sigma_1;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_1I[2] = sigma_t1 / determinant_Sigma_1;			
			
		determinant_Sigma_2 = scattering_table[sigma_2_coefficient_index] * ( sigma_t2 * sigma_theta2 - pow( sigma_t2_theta2, 2 ) );//ad-bc
		Sigma_2I[0] = sigma_theta2 / determinant_Sigma_2;
		Sigma_2I[1] = sigma_t2_theta2 / determinant_Sigma_2;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_2I[2] = sigma_t2 / determinant_Sigma_2;
		/**********************************************************************************************************************************************************/
		first_term_common_24_1 = Sigma_2I[0] * depth_2_go - Sigma_2I[1];
		first_term[0] = Sigma_1I[0] + Sigma_2I[0];
		first_term[1] = first_term_common_24_1 - Sigma_1I[1];
		first_term[2] = depth_2_go * Sigma_2I[0] - Sigma_1I[1] - Sigma_2I[1];
		first_term[3] = Sigma_1I[2] + Sigma_2I[2] + depth_2_go * ( first_term_common_24_1 - Sigma_2I[1]);	
		determinant_first_term = first_term[0] * first_term[3] - first_term[1] * first_term[2];
		
		// Calculate MLP t coordinate
		second_term_common_3 = Sigma_2I[0] * t_out_object - Sigma_2I[1] * T_2[1];	
		second_term[0] = Sigma_1I[0] * t_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * T_2[1] - Sigma_2I[1] * t_out_object - Sigma_1I[1] * t_in_object;	
		t_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double theta_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Calculate MLP v coordinate
		second_term_common_3 = Sigma_2I[0] * z_out_object - Sigma_2I[1] * V_2[1];
		second_term[0] = Sigma_1I[0] * z_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * V_2[1] - Sigma_2I[1] * z_out_object - Sigma_1I[1] * z_in_object;
		v_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double phi_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Rotate Coordinate From utv to xyz Coordinate System and Determine Which Voxel this Point on the MLP Path is in
		u_shifted += MLP_U_STEP;
		//u_shifted = u_in_object + u_1;

		x_1 = cos_term * u_shifted - sin_term * t_1;
		y_1 = sin_term * u_shifted + cos_term * t_1;

		voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x_1, VOXEL_WIDTH );
		voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_1, VOXEL_HEIGHT );
		voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, v_1, VOXEL_THICKNESS);			
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;

		//if( voxel != MLP[num_intersections] )
		//{
		//	MLP[++num_intersections] = voxel;	
		//	a_i_dot_x_k += x[voxel] * effective_chord_length;
		//	//a_i_dot_x_k += x[voxel];
		//	a_i_dot_a_i += a_j_times_a_j;
		//}
		if( voxel != MLP[number_of_intersections-1] )
		{
			MLP[number_of_intersections] = voxel;	
			a_i[number_of_intersections] = effective_chord_length;
			a_i_dot_x_k += x[voxel] * effective_chord_length;
			a_i_dot_a_i += pow(effective_chord_length, 2);
			number_of_intersections++;
		}
		u_1 += MLP_U_STEP;
		depth_2_go -= MLP_U_STEP;
		//step_number++;
		//u_1 = step_number * MLP_U_STEP;
		//depth_2_go = u_2 - u_1;
		sigma_1_coefficient_index += sigma_table_index_step;
		sigma_2_coefficient_index -= sigma_table_index_step;
		u_1_poly_index += poly_table_index_step;
	}
	//++num_intersections;
	//update_value_history = effective_chord_length * (( b_i - a_i_dot_x_k ) /  a_i_dot_a_i) * lambda;
	return number_of_intersections;
}
__device__ int find_MLP_GPU_tabulated_exact2
(
	float* x, double b_i, unsigned int first_MLP_voxel_number, double x_in_object, double y_in_object, double z_in_object, 
	double x_out_object, double y_out_object, double z_out_object, double xy_entry_angle, double xz_entry_angle, double xy_exit_angle, double xz_exit_angle,
	double lambda, float* a_i, double& a_i_dot_x_k, double& a_i_dot_a_i,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{
	double sigma_t1, sigma_t1_theta1, sigma_theta1, determinant_Sigma_1, Sigma_1I[3];
	double sigma_t2, sigma_t2_theta2, sigma_theta2, determinant_Sigma_2, Sigma_2I[3]; 
	double first_term_common_24_1, first_term[4], determinant_first_term;
	double second_term_common_3, second_term[2];
	double t_1, v_1, x_1, y_1;
	int voxel_x = 0, voxel_y = 0, voxel_z = 0;

	unsigned int trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
	double sin_term = sin_table[trig_table_index];
	double cos_term = cos_table[trig_table_index];
	 
	double u_in_object = cos_term * x_in_object + sin_term * y_in_object;
	double u_out_object = cos_term * x_out_object + sin_term * y_out_object;

	if( u_in_object > u_out_object )
	{
		xy_entry_angle += PI;
		xy_exit_angle += PI;
		trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
		sin_term = sin_table[trig_table_index];
		cos_term = cos_table[trig_table_index];
		u_in_object = cos_term * x_in_object + sin_term * y_in_object;
		u_out_object = cos_term * x_out_object + sin_term * y_out_object;
	}
	double t_in_object = cos_term * y_in_object  - sin_term * x_in_object;
	double t_out_object = cos_term * y_out_object - sin_term * x_out_object;
	
	double T_2[2] = {t_out_object, xy_exit_angle - xy_entry_angle};
	double V_2[2] = {z_out_object, xz_exit_angle - xz_entry_angle};
	double u_1 = MLP_U_STEP;
	double u_2 = abs(u_out_object - u_in_object);
	double depth_2_go = u_2 - u_1;
	double u_shifted = u_in_object;	
	//unsigned int step_number = 1;

	// Scattering Coefficient tables indices
	unsigned int sigma_table_index_step = static_cast<unsigned int>( MLP_U_STEP / COEFF_TABLE_STEP + 0.5 );
	unsigned int sigma_1_coefficient_index = sigma_table_index_step;
	unsigned int sigma_2_coefficient_index = static_cast<unsigned int>( depth_2_go / COEFF_TABLE_STEP + 0.5 );
	
	// Scattering polynomial indices
	unsigned int poly_table_index_step = static_cast<unsigned int>( MLP_U_STEP / POLY_TABLE_STEP + 0.5 );
	unsigned int u_1_poly_index = poly_table_index_step;
	unsigned int u_2_poly_index = static_cast<unsigned int>( u_2 / POLY_TABLE_STEP + 0.5 );

	//precalculated u_2 dependent terms (since u_2 does not change inside while loop)
	double u_2_poly_3_12 = poly_3_12[u_2_poly_index];
	double u_2_poly_2_6 = poly_2_6[u_2_poly_index];
	double u_2_poly_1_2 = poly_1_2[u_2_poly_index];
	double u_1_poly_1_2, u_1_poly_2_3;

	int voxel = first_MLP_voxel_number;
	int previous_voxel = voxel;
	int number_of_intersections = 0;
	double effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle + xy_exit_angle ) / 2.0, ( xz_entry_angle + xz_exit_angle) / 2.0 );
	a_i[number_of_intersections++] = voxel + effective_chord_length;
	a_i_dot_x_k = effective_chord_length * x[voxel];
	a_i_dot_a_i = pow(effective_chord_length, 2.0);

	//while( u_1 < u_2 - configurations.MLP_U_STEP)
	while( depth_2_go > MLP_U_STEP )
	{
		u_1_poly_1_2 = poly_1_2[u_1_poly_index];
		u_1_poly_2_3 = poly_2_3[u_1_poly_index];

		sigma_t1 = poly_3_12[u_1_poly_index];										// poly_3_12(u_1)
		sigma_t1_theta1 =  poly_2_6[u_1_poly_index];								// poly_2_6(u_1) 
		sigma_theta1 = u_1_poly_1_2;												// poly_1_2(u_1)

		sigma_t2 =  u_2_poly_3_12 - pow(u_2, 2.0) * u_1_poly_1_2 + 2 * u_2 * u_1_poly_2_3 - poly_3_4[u_1_poly_index];	// poly_3_12(u_2) - u_2^2 * poly_1_2(u_1) +2u_2*(u_1) - poly_3_4(u_1)
		sigma_t2_theta2 =  u_2_poly_2_6 - u_2 * u_1_poly_1_2 + u_1_poly_2_3;											// poly_2_6(u_2) - u_2*poly_1_2(u_1) + poly_2_3(u_1)
		sigma_theta2 =  u_2_poly_1_2 - u_1_poly_1_2;																	// poly_1_2(u_2) - poly_1_2(u_1)	

		determinant_Sigma_1 = scattering_table[sigma_1_coefficient_index] * ( sigma_t1 * sigma_theta1 - pow( sigma_t1_theta1, 2 ) );//ad-bc
		Sigma_1I[0] = sigma_theta1 / determinant_Sigma_1;
		Sigma_1I[1] = sigma_t1_theta1 / determinant_Sigma_1;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_1I[2] = sigma_t1 / determinant_Sigma_1;			
			
		determinant_Sigma_2 = scattering_table[sigma_2_coefficient_index] * ( sigma_t2 * sigma_theta2 - pow( sigma_t2_theta2, 2 ) );//ad-bc
		Sigma_2I[0] = sigma_theta2 / determinant_Sigma_2;
		Sigma_2I[1] = sigma_t2_theta2 / determinant_Sigma_2;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_2I[2] = sigma_t2 / determinant_Sigma_2;
		/**********************************************************************************************************************************************************/
		first_term_common_24_1 = Sigma_2I[0] * depth_2_go - Sigma_2I[1];
		first_term[0] = Sigma_1I[0] + Sigma_2I[0];
		first_term[1] = first_term_common_24_1 - Sigma_1I[1];
		first_term[2] = depth_2_go * Sigma_2I[0] - Sigma_1I[1] - Sigma_2I[1];
		first_term[3] = Sigma_1I[2] + Sigma_2I[2] + depth_2_go * ( first_term_common_24_1 - Sigma_2I[1]);	
		determinant_first_term = first_term[0] * first_term[3] - first_term[1] * first_term[2];
		
		// Calculate MLP t coordinate
		second_term_common_3 = Sigma_2I[0] * t_out_object - Sigma_2I[1] * T_2[1];	
		second_term[0] = Sigma_1I[0] * t_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * T_2[1] - Sigma_2I[1] * t_out_object - Sigma_1I[1] * t_in_object;	
		t_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double theta_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Calculate MLP v coordinate
		second_term_common_3 = Sigma_2I[0] * z_out_object - Sigma_2I[1] * V_2[1];
		second_term[0] = Sigma_1I[0] * z_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * V_2[1] - Sigma_2I[1] * z_out_object - Sigma_1I[1] * z_in_object;
		v_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double phi_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Rotate Coordinate From utv to xyz Coordinate System and Determine Which Voxel this Point on the MLP Path is in
		u_shifted += MLP_U_STEP;
		//u_shifted = u_in_object + u_1;

		x_1 = cos_term * u_shifted - sin_term * t_1;
		y_1 = sin_term * u_shifted + cos_term * t_1;

		voxel_x = calculate_voxel_GPU( X_ZERO_COORDINATE, x_1, VOXEL_WIDTH );
		voxel_y = calculate_voxel_GPU( Y_ZERO_COORDINATE, y_1, VOXEL_HEIGHT );
		voxel_z = calculate_voxel_GPU( Z_ZERO_COORDINATE, v_1, VOXEL_THICKNESS);			
		voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;

		//if( voxel != MLP[num_intersections] )
		//{
		//	MLP[++num_intersections] = voxel;	
		//	a_i_dot_x_k += x[voxel] * effective_chord_length;
		//	//a_i_dot_x_k += x[voxel];
		//	a_i_dot_a_i += a_j_times_a_j;
		//}
		if( voxel != previous_voxel )
		{
			a_i[number_of_intersections] = voxel + effective_chord_length;	
			//a_i_dot_x_k += x[voxel] * effective_chord_length;
			a_i_dot_x_k += effective_chord_length * x[voxel];
			a_i_dot_a_i += effective_chord_length * effective_chord_length;
			number_of_intersections++;
			previous_voxel = voxel;
		}
		u_1 += MLP_U_STEP;
		depth_2_go -= MLP_U_STEP;
		//step_number++;
		//u_1 = step_number * MLP_U_STEP;
		//depth_2_go = u_2 - u_1;
		sigma_1_coefficient_index += sigma_table_index_step;
		sigma_2_coefficient_index -= sigma_table_index_step;
		u_1_poly_index += poly_table_index_step;
	}
	//++num_intersections;
	//a_i_dot_x_k *= effective_chord_length;
	//a_i_dot_a_i *= number_of_intersections;
	//update_value_history = effective_chord_length * (( b_i - a_i_dot_x_k ) /  a_i_dot_a_i) * lambda;
	return number_of_intersections;
}
__device__ int find_blob_MLP_GPU_tabulated
(
	float* x, double b_i, unsigned int first_MLP_voxel_number, double x_in_object, double y_in_object, double z_in_object, 
	double x_out_object, double y_out_object, double z_out_object, double xy_entry_angle, double xz_entry_angle, double xy_exit_angle, double xz_exit_angle,
	double lambda, unsigned int* MLP, double effective_chord_length, double& a_i_dot_x_k, double& a_i_dot_a_i,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{
	double sigma_t1, sigma_t1_theta1, sigma_theta1, determinant_Sigma_1, Sigma_1I[3];
	double sigma_t2, sigma_t2_theta2, sigma_theta2, determinant_Sigma_2, Sigma_2I[3]; 
	double first_term_common_24_1, first_term[4], determinant_first_term;
	double second_term_common_3, second_term[2];
	//double t_1, v_1, x_1, y_1;
	double t_1, v_1;
	int voxel_x = 0, voxel_y = 0, voxel_z = 0;

	unsigned int trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
	double sin_term = sin_table[trig_table_index];
	double cos_term = cos_table[trig_table_index];
	
	// Blob parameters
	double xHat_u = cos_term;										// 'u' component of 'x' hat vector in 'xyz' system
	double yHat_u = sin_term;										// 'u' component of 'y' hat vector in 'xyz' system
	double zHat_u = 0;												// 'u' component of 'z' hat vector in 'xyz' system
	double x_1, y_1, z_1;											// Coordinates for steps of MLP
	double Phi_x, Phi_y, Phi_z;										// 'Phi' vector in 'xyz' system
	double tau_x, tau_y, tau_z, tau_u;								// 'tau' vector in 'xyz' system and 'u' component
	double u_sum;													// Denotes sum of 'u' components for position vector at blob center
	double xi;														// Constant for detection depth conditional statements
	int    index;													// Gives index for blob
	int    q_x, q_y;												// Used for indexing over blob lattice points
	
	double u_in_object = cos_term * x_in_object + sin_term * y_in_object;
	double u_out_object = cos_term * x_out_object + sin_term * y_out_object;

	if( u_in_object > u_out_object )
	{
		xy_entry_angle += PI;
		xy_exit_angle += PI;
		trig_table_index =  static_cast<unsigned int>((xy_entry_angle - TRIG_TABLE_MIN ) / TRIG_TABLE_STEP + 0.5);
		sin_term = sin_table[trig_table_index];
		cos_term = cos_table[trig_table_index];
		u_in_object = cos_term * x_in_object + sin_term * y_in_object;
		u_out_object = cos_term * x_out_object + sin_term * y_out_object;
	}
	double t_in_object = cos_term * y_in_object  - sin_term * x_in_object;
	double t_out_object = cos_term * y_out_object - sin_term * x_out_object;
	
	double T_2[2] = {t_out_object, xy_exit_angle - xy_entry_angle};
	double V_2[2] = {z_out_object, xz_exit_angle - xz_entry_angle};
	double u_1 = MLP_U_STEP;
	double u_2 = abs(u_out_object - u_in_object);
	double depth_2_go = u_2 - u_1;
	double u_shifted = u_in_object;	
	//unsigned int step_number = 1;

	// Scattering Coefficient tables indices
	unsigned int sigma_table_index_step = static_cast<unsigned int>( MLP_U_STEP / COEFF_TABLE_STEP + 0.5 );
	unsigned int sigma_1_coefficient_index = sigma_table_index_step;
	unsigned int sigma_2_coefficient_index = static_cast<unsigned int>( depth_2_go / COEFF_TABLE_STEP + 0.5 );
	
	// Scattering polynomial indices
	unsigned int poly_table_index_step = static_cast<unsigned int>( MLP_U_STEP / POLY_TABLE_STEP + 0.5 );
	unsigned int u_1_poly_index = poly_table_index_step;
	unsigned int u_2_poly_index = static_cast<unsigned int>( u_2 / POLY_TABLE_STEP + 0.5 );

	//precalculated u_2 dependent terms (since u_2 does not change inside while loop)
	double u_2_poly_3_12 = poly_3_12[u_2_poly_index];
	double u_2_poly_2_6 = poly_2_6[u_2_poly_index];
	double u_2_poly_1_2 = poly_1_2[u_2_poly_index];
	double u_1_poly_1_2, u_1_poly_2_3;

	int voxel = first_MLP_voxel_number;
	int number_of_intersections = 0;
	MLP[number_of_intersections] = voxel;
	number_of_intersections++;

	//effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle + xy_exit_angle ) / 2.0, ( xz_entry_angle + xz_exit_angle) / 2.0 );
	//double effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle + xy_exit_angle ) / 2.0, ( xz_entry_angle + xz_exit_angle) / 2.0 );
	//double a_j_times_a_j = effective_chord_length * effective_chord_length;
	a_i_dot_x_k = x[voxel];
	a_i_dot_a_i = pow(effective_chord_length, 2.0);
	//double a_i_dot_x_k = x[voxel] * effective_chord_length;
	//double a_i_dot_a_i = a_j_times_a_j;

	//while( u_1 < u_2 - configurations.MLP_U_STEP)
	while( depth_2_go > MLP_U_STEP )
	{
		u_1_poly_1_2 = poly_1_2[u_1_poly_index];
		u_1_poly_2_3 = poly_2_3[u_1_poly_index];

		sigma_t1 = poly_3_12[u_1_poly_index];										// poly_3_12(u_1)
		sigma_t1_theta1 =  poly_2_6[u_1_poly_index];								// poly_2_6(u_1) 
		sigma_theta1 = u_1_poly_1_2;												// poly_1_2(u_1)

		sigma_t2 =  u_2_poly_3_12 - pow(u_2, 2.0) * u_1_poly_1_2 + 2 * u_2 * u_1_poly_2_3 - poly_3_4[u_1_poly_index];	// poly_3_12(u_2) - u_2^2 * poly_1_2(u_1) +2u_2*(u_1) - poly_3_4(u_1)
		sigma_t2_theta2 =  u_2_poly_2_6 - u_2 * u_1_poly_1_2 + u_1_poly_2_3;											// poly_2_6(u_2) - u_2*poly_1_2(u_1) + poly_2_3(u_1)
		sigma_theta2 =  u_2_poly_1_2 - u_1_poly_1_2;																	// poly_1_2(u_2) - poly_1_2(u_1)	

		determinant_Sigma_1 = scattering_table[sigma_1_coefficient_index] * ( sigma_t1 * sigma_theta1 - pow( sigma_t1_theta1, 2 ) );//ad-bc
		Sigma_1I[0] = sigma_theta1 / determinant_Sigma_1;
		Sigma_1I[1] = sigma_t1_theta1 / determinant_Sigma_1;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_1I[2] = sigma_t1 / determinant_Sigma_1;			
			
		determinant_Sigma_2 = scattering_table[sigma_2_coefficient_index] * ( sigma_t2 * sigma_theta2 - pow( sigma_t2_theta2, 2 ) );//ad-bc
		Sigma_2I[0] = sigma_theta2 / determinant_Sigma_2;
		Sigma_2I[1] = sigma_t2_theta2 / determinant_Sigma_2;	// negative sign is propagated to subsequent calculations instead of here 
		Sigma_2I[2] = sigma_t2 / determinant_Sigma_2;
		/**********************************************************************************************************************************************************/
		first_term_common_24_1 = Sigma_2I[0] * depth_2_go - Sigma_2I[1];
		first_term[0] = Sigma_1I[0] + Sigma_2I[0];
		first_term[1] = first_term_common_24_1 - Sigma_1I[1];
		first_term[2] = depth_2_go * Sigma_2I[0] - Sigma_1I[1] - Sigma_2I[1];
		first_term[3] = Sigma_1I[2] + Sigma_2I[2] + depth_2_go * ( first_term_common_24_1 - Sigma_2I[1]);	
		determinant_first_term = first_term[0] * first_term[3] - first_term[1] * first_term[2];
		
		// Calculate MLP t coordinate
		second_term_common_3 = Sigma_2I[0] * t_out_object - Sigma_2I[1] * T_2[1];	
		second_term[0] = Sigma_1I[0] * t_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * T_2[1] - Sigma_2I[1] * t_out_object - Sigma_1I[1] * t_in_object;	
		t_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double theta_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Calculate MLP v coordinate
		second_term_common_3 = Sigma_2I[0] * z_out_object - Sigma_2I[1] * V_2[1];
		second_term[0] = Sigma_1I[0] * z_in_object + second_term_common_3;
		second_term[1] = depth_2_go * second_term_common_3 + Sigma_2I[2] * V_2[1] - Sigma_2I[1] * z_out_object - Sigma_1I[1] * z_in_object;
		v_1 = ( first_term[3] * second_term[0] - first_term[1] * second_term[1] ) / determinant_first_term ;
		//double phi_1 = first_term[2] * second_term[0] + first_term[3] * second_term[1];
		/**********************************************************************************************************************************************************/
		// Rotate Coordinate From utv to xyz Coordinate System and Determine Which Voxel this Point on the MLP Path is in
		u_shifted += MLP_U_STEP;
		//u_shifted = u_in_object + u_1;

		x_1 = cos_term * u_shifted - sin_term * t_1;
		y_1 = sin_term * u_shifted + cos_term * t_1;

		// Identify vector Phi^k in Z^3 for blob lattice
		Phi_x = static_cast<int>(x_1 / BETA_BLOB);
		Phi_y = static_cast<int>(y_1 / BETA_BLOB);
		Phi_z = static_cast<int>(v_1 / BETA_BLOB);

		// Identify vector 'tau' in xyz system
		tau_x = x_1 - BETA_BLOB * Phi_x;
		tau_y = y_1 - BETA_BLOB * Phi_y;
		tau_z = v_1 - BETA_BLOB * Phi_z;

		// Identify 'u' component of 'tau' and 'xi' constant
		tau_u = tau_x * cos_term + tau_y * sin_term;
		xi    = tau_u / BETA_BLOB;

		// Cycle through potentially intersected blobs
		for(float p = -ETA_BLOB; p <= ETA_BLOB; p++)
		{   
			q_y = -ETA_BLOB + static_cast<int>(z + Phi_z + Phi_y + ETA_BLOB)%2;
			for(float n = q; n <= ETA_BLOB; n += 2)
			{   
				q_x = -ETA_BLOB + static_cast<int>(z + Phi_z + Phi_x + ETA_BLOB)%2;
				for(float m = q_x; m <= ETA_BLOB; m += 2)
					if( (m*m + n*n + p*p) <= ETA_BLOB_SQUARED  )
					{
						u_sum = m * xHat_u + n * yHat_u; //+ z * zHat_u;   <-- zHat_u = 0.
						if( xi <= u_sum && u_sum < (xi + SBETA) )
						{
							index =  BlobIndex_GPU(Phi_x + m,   Phi_y + n,   Phi_z + p);
							if(index != -1)
								MLP[++number_of_intersections] = index;
						}
					}
			}
		}
		u_1 += MLP_U_STEP;
		depth_2_go -= MLP_U_STEP;
		//step_number++;
		//u_1 = step_number * MLP_U_STEP;
		//depth_2_go = u_2 - u_1;
		sigma_1_coefficient_index += sigma_table_index_step;
		sigma_2_coefficient_index -= sigma_table_index_step;
		u_1_poly_index += poly_table_index_step;
	}
	//++num_intersections;
	//a_i_dot_x_k *= effective_chord_length;
	//a_i_dot_a_i *= num_intersections;
	a_i_dot_x_k *= effective_chord_length;
	a_i_dot_a_i *= number_of_intersections;
	//update_value_history = effective_chord_length * (( b_i - a_i_dot_x_k ) /  a_i_dot_a_i) * lambda;
	return number_of_intersections;
}
__global__ void block_update_GPU
(
	float* x, float* x_entry, float* y_entry, float* z_entry, float* xy_entry_angle, float* xz_entry_angle, 
	float* x_exit, float* y_exit, float* z_exit, float* xy_exit_angle, float* xz_exit_angle, float* WEPL, 
	unsigned int* first_MLP_voxel, float* x_update, unsigned int* S, int start_proton_id, int num_histories, double lambda
) 
{
	int voxel = 0, number_of_intersections;
	double b_i, a_i_dot_a_i, a_i_dot_x_k, effective_chord_length;

	int proton_id =  start_proton_id + threadIdx.x * HISTORIES_PER_THREAD + blockIdx.x * HISTORIES_PER_BLOCK * HISTORIES_PER_THREAD;		
	if( proton_id < num_histories ) 
	{ 	  
		//unsigned int* a_i;
		//a_i = (unsigned int*)malloc( MAX_INTERSECTIONS * sizeof(unsigned int));
		unsigned int MLP[MAX_INTERSECTIONS];
		for( int history = 0; history < HISTORIES_PER_THREAD; history++ ) 
		{	
			if( proton_id < num_histories ) 
			{		  
				b_i = WEPL[proton_id];
				effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle[proton_id] + xy_exit_angle[proton_id] ) / 2.0, ( xz_entry_angle[proton_id] + xz_exit_angle[proton_id]) / 2.0 );
				number_of_intersections = find_MLP_GPU
				(
					x, b_i, first_MLP_voxel[proton_id], x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], x_exit[proton_id], y_exit[proton_id], 
					z_exit[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], lambda, 
					MLP, effective_chord_length, a_i_dot_x_k, a_i_dot_a_i 
				);					      
					      						      	
				// Copy a_i to global
				for (int j = 0 ; j < number_of_intersections; ++j) 
				{
					voxel = MLP[j];
					atomicAdd( &( S[voxel]), 1 );
					atomicAdd( &( x_update[voxel]) , effective_chord_length * ( (b_i - a_i_dot_x_k) /  a_i_dot_a_i ) * lambda ); 
				}	
			}
			proton_id++;
		}	
		free(MLP);    	 
	}		
}
__global__ void block_update_GPU_tabulated
(
	float* x, float* x_entry, float* y_entry, float* z_entry, float* xy_entry_angle, float* xz_entry_angle, 
	float* x_exit, float* y_exit, float* z_exit, float* xy_exit_angle, float* xz_exit_angle, float* WEPL, 
	unsigned int* first_MLP_voxel, float* x_update, unsigned int* S, int start_proton_id, int num_histories, double lambda,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{	
	int voxel = 0, number_of_intersections;
	double b_i, a_i_dot_a_i, a_i_dot_x_k, effective_chord_length;
	
	int proton_id =  start_proton_id + threadIdx.x * HISTORIES_PER_THREAD + blockIdx.x * HISTORIES_PER_BLOCK * HISTORIES_PER_THREAD;		
	if( proton_id < num_histories ) 
	{	  	  
		//unsigned int* a_i;
		//a_i = (unsigned int*)malloc( MAX_INTERSECTIONS * sizeof(unsigned int));
		unsigned int MLP[MAX_INTERSECTIONS];
		//__shared__ unsigned int* a_i[MAX_INTERSECTIONS];

		for( int history = 0; history < HISTORIES_PER_THREAD; history++ ) 
		{	
			if( proton_id < num_histories ) 
			{		  
				b_i = WEPL[proton_id];		
				effective_chord_length = EffectiveChordLength_GPU( ( xy_entry_angle[proton_id] + xy_exit_angle[proton_id] ) / 2.0, ( xz_entry_angle[proton_id] + xz_exit_angle[proton_id]) / 2.0 );
				number_of_intersections = find_MLP_GPU_tabulated
				(
					x, b_i, first_MLP_voxel[proton_id], x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], x_exit[proton_id], y_exit[proton_id], 
					z_exit[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], lambda, 
					MLP, effective_chord_length, a_i_dot_x_k, a_i_dot_a_i, sin_table, cos_table, scattering_table, poly_1_2, poly_2_3, poly_3_4, poly_2_6, poly_3_12
				);					      
									     						      	
				// Copy a_i to global
				for (int j = 0 ; j < number_of_intersections; ++j) 
				{
					voxel = MLP[j];
					atomicAdd( &(S[voxel]), 1 );
					atomicAdd( &(x_update[voxel]) , effective_chord_length * ( (b_i - a_i_dot_x_k) /  a_i_dot_a_i ) * lambda ); 
				}	
			}
			proton_id++;
		}	
		free(MLP);    	 
	}	
}
__global__ void block_update_GPU_tabulated_exact
(
	float* x, float* x_entry, float* y_entry, float* z_entry, float* xy_entry_angle, float* xz_entry_angle, 
	float* x_exit, float* y_exit, float* z_exit, float* xy_exit_angle, float* xz_exit_angle, float* WEPL, 
	unsigned int* first_MLP_voxel, float* x_update, unsigned int* S, int start_proton_id, int num_histories, double lambda,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{	
	int voxel = 0, number_of_intersections;
	double b_i, a_i_dot_a_i, a_i_dot_x_k, effective_chord_length;
	
	int proton_id =  start_proton_id + threadIdx.x * HISTORIES_PER_THREAD + blockIdx.x * HISTORIES_PER_BLOCK * HISTORIES_PER_THREAD;		
	if( proton_id < num_histories ) 
	{	  	  
		//unsigned int* a_i;
		//a_i = (unsigned int*)malloc( MAX_INTERSECTIONS * sizeof(unsigned int));
		unsigned int MLP[MAX_INTERSECTIONS];
		float a_i[MAX_INTERSECTIONS];
		//__shared__ unsigned int* a_i[MAX_INTERSECTIONS];

		for( int history = 0; history < HISTORIES_PER_THREAD; history++ ) 
		{	
			if( proton_id < num_histories ) 
			{		  
				b_i = WEPL[proton_id];		
				number_of_intersections = find_MLP_GPU_tabulated_exact
				(
					x, b_i, first_MLP_voxel[proton_id], x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], x_exit[proton_id], y_exit[proton_id], 
					z_exit[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], lambda, 
					MLP, a_i, a_i_dot_x_k, a_i_dot_a_i, sin_table, cos_table, scattering_table, poly_1_2, poly_2_3, poly_3_4, poly_2_6, poly_3_12
				);					      
					     						      	
				// Copy a_i to global
				for (int j = 0 ; j < number_of_intersections; ++j) 
				{
					voxel = MLP[j];
					atomicAdd( &(S[voxel]), 1 );
					atomicAdd( &(x_update[voxel]) , effective_chord_length * ( (b_i - a_i_dot_x_k) /  a_i_dot_a_i ) * lambda ); 
				}	
			}
			proton_id++;
		}	
		free(a_i);    	 
	}	
}
__global__ void block_update_GPU_tabulated_exact2
(
	float* x, float* x_entry, float* y_entry, float* z_entry, float* xy_entry_angle, float* xz_entry_angle, 
	float* x_exit, float* y_exit, float* z_exit, float* xy_exit_angle, float* xz_exit_angle, float* WEPL, 
	unsigned int* first_MLP_voxel, float* x_update, unsigned int* S, int start_proton_id, int num_histories, double lambda,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{	
	int voxel = 0, number_of_intersections;
	double b_i, a_i_dot_a_i, a_i_dot_x_k, a_ij;
	
	int proton_id =  start_proton_id + threadIdx.x * HISTORIES_PER_THREAD + blockIdx.x * HISTORIES_PER_BLOCK * HISTORIES_PER_THREAD;		
	if( proton_id < num_histories ) 
	{	  	  
		//unsigned int* a_i;
		//a_i = (unsigned int*)malloc( MAX_INTERSECTIONS * sizeof(unsigned int));
		float a_i[MAX_INTERSECTIONS];
		//__shared__ unsigned int* a_i[MAX_INTERSECTIONS];

		for( int history = 0; history < HISTORIES_PER_THREAD; history++ ) 
		{	
			if( proton_id < num_histories ) 
			{		  
				b_i = WEPL[proton_id];		
				number_of_intersections = find_MLP_GPU_tabulated_exact2
				(
					x, b_i, first_MLP_voxel[proton_id], x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], x_exit[proton_id], y_exit[proton_id], 
					z_exit[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], lambda, 
					a_i, a_i_dot_x_k, a_i_dot_a_i, sin_table, cos_table, scattering_table, poly_1_2, poly_2_3, poly_3_4, poly_2_6, poly_3_12
				);					      
					     						      	
				// Copy a_i to global
				for (int j = 0 ; j < number_of_intersections; ++j) 
				{
					voxel = static_cast<int>(a_i[j]);
					a_ij = a_i[j] - voxel;
					atomicAdd( &(S[voxel]), 1 );
					atomicAdd( &(x_update[voxel]) , a_ij * ( (b_i - a_i_dot_x_k) /  a_i_dot_a_i ) * lambda ); 
				}	
			}
			proton_id++;
		}	
		free(a_i);    	 
	}	
}
__global__ void block_update_GPU_tabulated_blob
(
	float* x, float* x_entry, float* y_entry, float* z_entry, float* xy_entry_angle, float* xz_entry_angle, 
	float* x_exit, float* y_exit, float* z_exit, float* xy_exit_angle, float* xz_exit_angle, float* WEPL, 
	unsigned int* first_MLP_voxel, float* x_update, unsigned int* S, int start_proton_id, int num_histories, double lambda,
	double* sin_table, double* cos_table, double* scattering_table, double* poly_1_2, double* poly_2_3, double* poly_3_4, double* poly_2_6, double* poly_3_12
) 
{	
	int blob = 0, number_of_intersections;
	double b_i, a_i_dot_a_i, a_i_dot_x_k, effective_chord_length;
	
	int proton_id =  start_proton_id + threadIdx.x * HISTORIES_PER_THREAD + blockIdx.x * HISTORIES_PER_BLOCK * HISTORIES_PER_THREAD;		
	if( proton_id < num_histories ) 
	{	  	  
		//unsigned int* a_i;
		//a_i = (unsigned int*)malloc( MAX_INTERSECTIONS * sizeof(unsigned int));
		unsigned int MLP[MAX_INTERSECTIONS];
		//__shared__ unsigned int* a_i[MAX_INTERSECTIONS];

		for( int history = 0; history < HISTORIES_PER_THREAD; history++ ) 
		{	
			if( proton_id < num_histories ) 
			{		  
				b_i = WEPL[proton_id];		
				effective_chord_length = BLOB_INT_LEN;
				number_of_intersections = find_MLP_GPU_tabulated
				(
					x, b_i, first_MLP_voxel[proton_id], x_entry[proton_id], y_entry[proton_id], z_entry[proton_id], x_exit[proton_id], y_exit[proton_id], 
					z_exit[proton_id], xy_entry_angle[proton_id], xz_entry_angle[proton_id], xy_exit_angle[proton_id], xz_exit_angle[proton_id], lambda, 
					MLP, effective_chord_length, a_i_dot_x_k, a_i_dot_a_i, sin_table, cos_table, scattering_table, poly_1_2, poly_2_3, poly_3_4, poly_2_6, poly_3_12
				);					      
									     						      	
				// Copy a_i to global
				for (int j = 0 ; j < number_of_intersections; ++j) 
				{
					blob = MLP[j];
					atomicAdd( &(S[blob]), 1 );
					atomicAdd( &(x_update[blob]) , effective_chord_length * ( (b_i - a_i_dot_x_k) /  a_i_dot_a_i ) * lambda ); 
				}	
			}
			proton_id++;
		}	
		free(MLP);    	 
	}	
}
__global__ void DROP_init_arrays_GPU(float* x_update, unsigned int* S) 
{
	int column_start = VOXELS_PER_THREAD * blockIdx.x;
	int row = blockIdx.y;
	int slice = threadIdx.x;
	int voxel = column_start  + row * COLUMNS + slice * ROWS * COLUMNS;

	for( int shift = 0; shift < VOXELS_PER_THREAD; shift++ ) 
	{	  
		if( voxel < NUM_VOXELS ) 
		{   
			x_update[voxel] = 0.0;
			S[voxel] = 0;			
		}
		voxel++;	 
	 }  
}
__global__ void x_update_GPU (float* x, float* x_update, unsigned int* S) 
{
	int column_start = VOXELS_PER_THREAD * blockIdx.x;
	int row = blockIdx.y;
	int slice = threadIdx.x;
	int voxel = column_start  + row * COLUMNS + slice * ROWS * COLUMNS;
	
	for( int shift = 0; shift < VOXELS_PER_THREAD; shift++ ) 
	{	  
		if( (voxel < NUM_VOXELS) && (S[voxel] > 0) ) 
		{		  
			x[voxel] = min( x[voxel] + x_update[voxel] / S[voxel], 2.0 );
			x_update[voxel] = 0.0;
			S[voxel] = 0;
		}
		voxel++;
	}
}
void allocate_x()
{
	cudaMalloc( (void**) &x_d, SIZE_IMAGE_FLOAT);
}
void deallocate_x()
{
	cudaFree(x_d);
}
void x_host_2_GPU() 
{
	  cudaMemcpy( x_h, x_d, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice);
}
void x_GPU_2_host() 
{
	  cudaMemcpy( x_h, x_d, SIZE_IMAGE_FLOAT, cudaMemcpyDeviceToHost);
}
void DROP_allocate_arrays()
{
	// Hull is not needed during DROP so free its host/GPU arrays
	free(hull_h);
	cudaFree(hull_d); 
	
	// Allocate GPU memory for x, hull, x_update, and S
	//cudaMalloc( (void**) &x_d, 			SIZE_IMAGE_FLOAT);
	cudaMalloc( (void**) &x_update_d, 	SIZE_IMAGE_FLOAT);
	cudaMalloc( (void**) &S_d, 			SIZE_IMAGE_UINT);
	
	//cudaMemcpy( x_d, x_h, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice );

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("DROP_allocate_arrays Error: %s\n", cudaGetErrorString(cudaStatus));
}
void DROP_deallocate_arrays()
{
	// Allocate GPU memory for x, hull, x_update, and S
	//cudaFree(x_d); 
	cudaFree(x_update_d); 
	cudaFree(S_d); 

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error: %s\n", cudaGetErrorString(cudaStatus));
}
void DROP_allocations(const int num_histories)
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_ints			= sizeof(int) * num_histories;
	
	cudaMalloc( (void**) &x_entry_d,			size_floats );
	cudaMalloc( (void**) &y_entry_d,			size_floats );
	cudaMalloc( (void**) &z_entry_d,			size_floats );
	cudaMalloc( (void**) &x_exit_d,				size_floats );
	cudaMalloc( (void**) &y_exit_d,				size_floats );
	cudaMalloc( (void**) &z_exit_d,				size_floats );	
	cudaMalloc( (void**) &xy_entry_angle_d,		size_floats );
	cudaMalloc( (void**) &xz_entry_angle_d,		size_floats );
	cudaMalloc( (void**) &xy_exit_angle_d,		size_floats );
	cudaMalloc( (void**) &xz_exit_angle_d,		size_floats );	
	cudaMalloc( (void**) &WEPL_d,				size_floats );
	cudaMalloc( (void**) &first_MLP_voxel_d, 	size_ints );

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("DROP_allocations Error: %s\n", cudaGetErrorString(cudaStatus));
}
void DROP_host_2_device(const int start_position,const int num_histories)
{
	unsigned int size_floats		= sizeof(float) * num_histories;
	unsigned int size_ints			= sizeof(int) * num_histories;
	
	cudaMemcpy( x_entry_d,			&x_entry_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( y_entry_d,			&y_entry_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( z_entry_d,			&z_entry_vector[start_position],			size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( x_exit_d,			&x_exit_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( y_exit_d,			&y_exit_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( z_exit_d,			&z_exit_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_entry_angle_d,	&xy_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_entry_angle_d,	&xz_entry_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xy_exit_angle_d,	&xy_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( xz_exit_angle_d,	&xz_exit_angle_vector[start_position],		size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( WEPL_d,				&WEPL_vector[start_position],				size_floats,	cudaMemcpyHostToDevice );
	cudaMemcpy( first_MLP_voxel_d,	&first_MLP_voxel_vector[start_position],	size_ints,		cudaMemcpyHostToDevice );

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("DROP_host_2_device Error: %s\n", cudaGetErrorString(cudaStatus));
}
void DROP_deallocations()
{	
	cudaFree(x_entry_d);
	cudaFree(y_entry_d);
	cudaFree(z_entry_d);
	cudaFree(x_exit_d);
	cudaFree(y_exit_d);
	cudaFree(z_exit_d);
	cudaFree(xy_entry_angle_d);
	cudaFree(xz_entry_angle_d);
	cudaFree(xy_exit_angle_d);
	cudaFree(xz_exit_angle_d);
	cudaFree(WEPL_d);
	cudaFree(first_MLP_voxel_d);

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("DROP_deallocations Error: %s\n", cudaGetErrorString(cudaStatus));
}
void DROP_full_tx(const int num_histories)
{
	// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = STANDARD
	cudaError_t cudaStatus;
	char iterate_filename[256];
	//char statement[256];
	int remaining_histories, start_position = 0, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>(COLUMNS/VOXELS_PER_THREAD);
	DROP_allocations(num_histories);
	DROP_host_2_device( start_position, num_histories);
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );
	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	

			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, start_position, num_histories, LAMBDA
			);		
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;
			start_position		+= DROP_BLOCK_SIZE;
		}
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);			
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
	DROP_deallocations();
}
void DROP_partial_tx( const int num_histories ) 
{
	// DROP_TX_MODE = PARTIAL_TX, MLP_ALGORITHM = STANDARD
	cudaError_t cudaStatus;
	//char statement[256];
	char iterate_filename[256];
	int remaining_histories, start_position, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>(COLUMNS/VOXELS_PER_THREAD);
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );
	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");			
		while( remaining_histories > 0 )
		{
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	
			
			DROP_allocations(histories_2_process);
			DROP_host_2_device( start_position, histories_2_process);
	
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, 0, histories_2_process, LAMBDA
			);		
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			DROP_deallocations();

			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));
			
			remaining_histories -= DROP_BLOCK_SIZE;
			start_position		+= DROP_BLOCK_SIZE;
		}
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);				
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
}
void DROP_partial_tx_preallocated( const int num_histories ) 
{ 
	// DROP_TX_MODE = PARTIAL_TX_PREALLOCATED, MLP_ALGORITHM = STANDARD
	cudaError_t cudaStatus;
	//char statement[256];
	char iterate_filename[256];
	int remaining_histories, start_position, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>(COLUMNS/VOXELS_PER_THREAD);
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );
	DROP_allocations(DROP_BLOCK_SIZE);
	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	
			
			DROP_host_2_device( start_position, histories_2_process);
	
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, 0, histories_2_process, LAMBDA
			);		
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;
			start_position		+= DROP_BLOCK_SIZE;
		}
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
	DROP_deallocations();
}
void DROP_full_tx_tabulated(const int num_histories)	
{
	// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = TABULATED
	cudaError_t cudaStatus;
	//char statement[256];
	char iterate_filename[256];
	int remaining_histories, start_position = 0, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>(COLUMNS/VOXELS_PER_THREAD);
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );

	DROP_allocations(num_histories);
	DROP_host_2_device( start_position, num_histories);
	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU_tabulated<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, start_position, num_histories, LAMBDA,
				sin_table_d, cos_table_d, scattering_table_d, poly_1_2_d, poly_2_3_d, poly_3_4_d, poly_2_6_d, poly_3_12_d
			);	
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );

			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;
			start_position		+= DROP_BLOCK_SIZE;
		}
		
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
	DROP_deallocations();
}
void DROP_partial_tx_tabulated( const int num_histories ) 
{ 
	// DROP_TX_MODE = PARTIAL_TX, MLP_ALGORITHM = TABULATED
	cudaError_t cudaStatus;
	//char statement[256];
	char iterate_filename[256];
	int remaining_histories, start_position, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>(COLUMNS/VOXELS_PER_THREAD);
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );

	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	
			
			DROP_allocations(histories_2_process);
			DROP_host_2_device( start_position, histories_2_process);
	
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU_tabulated<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, 0, histories_2_process, LAMBDA,
				sin_table_d, cos_table_d, scattering_table_d, poly_1_2_d, poly_2_3_d, poly_3_4_d, poly_2_6_d, poly_3_12_d
			);			
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			DROP_deallocations();

			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );

			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;
			start_position		+= DROP_BLOCK_SIZE;
		}
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
}
void DROP_partial_tx_preallocated_tabulated( const int num_histories ) 
{
	// DROP_TX_MODE = PARTIAL_TX_PREALLOCATED, MLP_ALGORITHM = TABULATED
	cudaError_t cudaStatus;
	//char statement[256];
	char iterate_filename[256];
	int remaining_histories, start_position, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>(COLUMNS/VOXELS_PER_THREAD);
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );

	//DROP_full_tx_setup(reconstruction_histories);
	DROP_allocations(DROP_BLOCK_SIZE);
	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	
			
			DROP_host_2_device( start_position, histories_2_process);
	
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU_tabulated<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, 0, histories_2_process, LAMBDA,
				sin_table_d, cos_table_d, scattering_table_d, poly_1_2_d, poly_2_3_d, poly_3_4_d, poly_2_6_d, poly_3_12_d
			);		
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );

			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;
			start_position		+= DROP_BLOCK_SIZE;
		}
		//end_DROP_iteration = clock();
		//clock_cycles_DROP_iteration = end_DROP_iteration - begin_DROP_iteration;
		//execution_time_DROP_iteration = static_cast<double>(clock_cycles_DROP_iteration) / CLOCKS_PER_SEC;
		//printf( "Execution time for iteration %d =  %lf seconds\n", iteration, execution_time_DROP_iteration );
		
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);		
	}
	DROP_deallocations();	
}
/***********************************************************************************************************************************************************************************************************************/
/****************************************************************************************** Total variation superiorization ********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
float calculate_total_variation( float* image )
{
	int voxel;
	float total_variation = 0.0;
	// Calculate TV for unperturbed image x
	// Scott had slice = [1,SLICES-1), row = [0, ROWS -1), and column = [0, COLUMNS -1)
	// Not sure why just need to avoid last row and column due to indices [voxel + COLUMNS] and [voxel + 1], respectively 
	for( int slice = 0; slice < SLICES; slice++ )
	{
		for( int row = 0; row < ROWS - 1; row++ )
		{
			for( int column = 0; column < COLUMNS - 1; column++ )
			{
				voxel = column + row * COLUMNS + slice * ROWS * COLUMNS;
				total_variation += sqrt( powf( image[voxel + COLUMNS] - image[voxel], 2 ) + powf( image[voxel + 1] - image[voxel], 2 ) );
				//total_variation += sqrt( ( image[voxel + COLUMNS] - image[voxel] ) * ( image[voxel + COLUMNS] - image[voxel] ) + ( image[voxel + 1] - image[voxel] ) * ( image[voxel + 1] - image[voxel] ) );
			}
		}
	}
	return total_variation;
}
__device__ float calculate_total_variation_GPU( float* image )
{
	int voxel;
	float total_variation = 0.0;
	// Calculate TV for unperturbed image x
	// Scott had slice = [1,SLICES-1), row = [0, ROWS -1), and column = [0, COLUMNS -1)
	// Not sure why just need to avoid last row and column due to indices [voxel + COLUMNS] and [voxel + 1], respectively 
	for( int slice = 0; slice < SLICES; slice++ )
	{
		for( int row = 0; row < ROWS - 1; row++ )
		{
			for( int column = 0; column < COLUMNS - 1; column++ )
			{
				voxel = column + row * COLUMNS + slice * ROWS * COLUMNS;
				total_variation += sqrt( powf( image[voxel + COLUMNS] - image[voxel], 2 ) + powf( image[voxel + 1] - image[voxel], 2 ) );
				//total_variation += sqrt( ( image[voxel + COLUMNS] - image[voxel] ) * ( image[voxel + COLUMNS] - image[voxel] ) + ( image[voxel + 1] - image[voxel] ) * ( image[voxel + 1] - image[voxel] ) );
			}
		}
	}
	return total_variation;
}
void allocate_perturbation_arrays( bool parallel)
{
	G_x_h		= (float*) calloc( NUM_VOXELS, sizeof(float) );
	G_y_h		= (float*) calloc( NUM_VOXELS, sizeof(float) );
	G_norm_h	= (float*) calloc( NUM_VOXELS, sizeof(float) );
	G_h			= (float*) calloc( NUM_VOXELS, sizeof(float) );
	v_h			= (float*) calloc( NUM_VOXELS, sizeof(float) );
	y_h			= (float*) calloc( NUM_VOXELS, sizeof(float) );
	TV_y_h		= (float*) calloc( 1,		   sizeof(float) );

	if( parallel )
	{
		cudaMalloc( (void**) &G_x_d,	SIZE_IMAGE_FLOAT );
		cudaMalloc( (void**) &G_y_d,	SIZE_IMAGE_FLOAT );
		cudaMalloc( (void**) &G_norm_d,	SIZE_IMAGE_FLOAT );
		cudaMalloc( (void**) &G_d,		SIZE_IMAGE_FLOAT );
		cudaMalloc( (void**) &v_d,		SIZE_IMAGE_FLOAT );	
		cudaMalloc( (void**) &y_d,		SIZE_IMAGE_FLOAT );	
		cudaMalloc( (void**) &TV_y_d,	sizeof(float)	 );	

		cudaMemcpy(G_x_d,		G_x_h,		SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice ); 
		cudaMemcpy(G_y_d,		G_y_h,		SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice ); 
		cudaMemcpy(G_norm_d,	G_norm_h,   SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice ); 
		cudaMemcpy(G_d,			G_h,		SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice ); 
		cudaMemcpy(v_d,			v_h,		SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice ); 
		cudaMemcpy(y_d,			y_h,		SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice ); 
		cudaMemcpy(TV_y_d,		TV_y_h,		sizeof(float)	, cudaMemcpyHostToDevice ); 
	}
}
void deallocate_perturbation_arrays( bool parallel)
{
	free(G_x_h);
	free(G_y_h);
	free(G_norm_h);
	free(G_h);
	free(v_h);
	free(y_h);
	free(TV_y_h);

	if( parallel )
	{
		cudaFree( G_x_d);
		cudaFree(G_y_d);
		cudaFree(G_norm_d);
		cudaFree(G_d);
		cudaFree(v_d);	
		cudaFree(y_d);	
		cudaFree(TV_y_d);	
	}
}
void generate_perturbation_vector()
{
	int row, column, slice, voxel;
	float norm_G = 0.0;

	// 1. Calculate the difference at each pixel with respect to rows and columns and get the normalization factor for this pixel
	for( slice = 0; slice < SLICES; slice++ )
	{
		for( row = 0; row < ROWS - 1; row++ )
		{
			for( column = 0; column < COLUMNS - 1; column++ )
			{
				voxel			= column + row * COLUMNS + slice * ROWS * COLUMNS;
				G_x_h[voxel]	= x_h[voxel + 1] - x_h[voxel];
				G_y_h[voxel]	= x_h[voxel + COLUMNS] - x_h[voxel];
				G_norm_h[voxel] = sqrt( powf( G_x_h[voxel], 2 ) + powf( G_y_h[voxel], 2 ) );
				//G_norm_h[voxel] = sqrt( ( G_x_h[voxel] * G_x_h[voxel] ) + ( G_y_h[voxel] * G_y_h[voxel] ) );
			}
		}
	}
	// 2. Add the appropriate difference values to each pixel subgradient
	for( slice = 0; slice < SLICES; slice++ )
	{
		for( row = 0; row < ROWS - 1; row++ )
		{
			for( column = 0; column < COLUMNS - 1; column++ )
			{
				voxel = column + row * COLUMNS + slice * ROWS * COLUMNS;
				if( G_norm_h[voxel] > 0.0 )
				{
					G_h[voxel]			 -= ( G_x_h[voxel] + G_y_h[voxel] ) / G_norm_h[voxel];		// Negative signs on x/y terms applied using -=
					G_h[voxel + COLUMNS] += G_y_h[voxel] / G_norm_h[voxel];
					G_h[voxel + 1]		 += G_x_h[voxel] / G_norm_h[voxel];
				}
			}
		}
	}			
	// 3. Get the norm of the subgradient vector 
	for( voxel = 0; voxel < NUM_VOXELS; voxel++ )
		norm_G += powf( G_h[voxel], 2 );
		//G_norm += G_h[voxel] * G_h[voxel];
	norm_G = sqrt(norm_G);
	
	// 4. Normalize the subgradient of the TV to produce v
	// if( norm_G == 0 )
	//	norm_G = 1.0;
	// If norm_G = 0, all elements of G_h are zero => all elements of v_h = 0.  
	if( norm_G == 0 )
	{
		for( voxel = 0; voxel < NUM_VOXELS; voxel++ )
		{
			v_h[voxel] = G_h[voxel] / norm_G;		// Negative sign applied as subtraction in application of perturbation, eliminating unnecessary op
			G_h[voxel] = 0.0;
		}
	}
	else
	{
		for( voxel = 0; voxel < NUM_VOXELS; voxel++ )
		{
			v_h[voxel] = 0.0;
			G_h[voxel] = 0.0;
		}
	}
	//for( slice = 0; slice < SLICES; slice++ )
	//{
	//	for( row = 0; row < ROWS - 1; row++ )
	//	{
	//		for( column = 0; column < COLUMNS - 1; column++ )
	//		{
	//			voxel = column + row * COLUMNS + slice * ROWS * COLUMNS;
	//			v_h[voxel] = G_h[voxel] / sqrt(G_norm);						// Negative sign moved to application of perturbation, reduce op
	//		}
	//	}
	//}
}
__global__ void generate_perturbation_vector_GPU( float* G_x, float* G_y, float* G_norm, float* G, float* v, float* x )
{
	int column = blockIdx.x;
	int row = blockIdx.y;
	int slice = threadIdx.x;
	int voxel = column  + row * COLUMNS + slice * ROWS * COLUMNS;
	float norm_G = 0.0;
	if( voxel < NUM_VOXELS )
	{
		// 1. Calculate the difference at each pixel with respect to rows and columns and get the normalization factor for this pixel
		if( (column < COLUMNS - 1) &&  (row < ROWS - 1) )
		{
			G_x[voxel]	= x[voxel + 1] - x[voxel];
			G_y[voxel]	= x[voxel + COLUMNS] - x[voxel];
			G_norm[voxel] = sqrt( powf( G_x[voxel], 2 ) + powf( G_y[voxel], 2 ) );
			//G_norm[voxel] = sqrt( ( G_x[voxel] * G_x[voxel] ) + ( G_y[voxel] * G_y[voxel] ) );
		}

		// 2. Add the appropriate difference values to each pixel subgradient
		if( G_norm[voxel] > 0.0 )
			G[voxel] -= ( G_x[voxel] + G_y[voxel] ) / G_norm[voxel];		// Negative signs on x/y terms applied using -=		
		if( row > 0 && G_norm[voxel - COLUMNS] > 0.0 )		
			G[voxel] += G_y[voxel - COLUMNS] / G_norm[voxel - COLUMNS];
		if( column > 0 && G_norm[voxel - 1] > 0.0 )		
			G[voxel] += G_x[voxel - 1] / G_norm[voxel - 1];
		
		// 3. Get the norm of the subgradient vector 
		//if( voxel == 0 )
		//{
			for( voxel = 0; voxel < NUM_VOXELS; voxel++ )
				norm_G += powf( G[voxel], 2 );
				//G_norm += G[voxel] * G[voxel];
			norm_G = sqrt(norm_G);
		//}
		// 4. Normalize the subgradient of the TV to produce v
		// If norm_G = 0, all elements of G are zero => all elements of v = 0.  
		if( norm_G != 0 )
			v[voxel] = G[voxel] / norm_G;		// Negative sign applied as subtraction in application of perturbation, eliminating unnecessary op
		else
			v[voxel] = 0.0;
		G[voxel] = 0.0;
		G_x[voxel] = 0.0;
		G_y[voxel] = 0.0;
		G_norm[voxel] = 0.0;
	}
}
__device__ void generate_perturbation_vector_GPU( float* G_x, float* G_y, float* G_norm, float* G, float* v, float* x, int column, int row, int voxel )
{
	float norm_G = 0.0;
	if( voxel < NUM_VOXELS )
	{
		// 1. Calculate the difference at each pixel with respect to rows and columns and get the normalization factor for this pixel
		if( (column < COLUMNS - 1) &&  (row < ROWS - 1) )
		{
			G_x[voxel]	= x[voxel + 1] - x[voxel];
			G_y[voxel]	= x[voxel + COLUMNS] - x[voxel];
			G_norm[voxel] = sqrt( powf( G_x[voxel], 2 ) + powf( G_y[voxel], 2 ) );
			//G_norm[voxel] = sqrt( ( G_x[voxel] * G_x[voxel] ) + ( G_y[voxel] * G_y[voxel] ) );
		}

		// 2. Add the appropriate difference values to each pixel subgradient
		if( G_norm[voxel] > 0.0 )
			G[voxel] -= ( G_x[voxel] + G_y[voxel] ) / G_norm[voxel];		// Negative signs on x/y terms applied using -=		
		if( row > 0 && G_norm[voxel - COLUMNS] > 0.0 )		
			G[voxel] += G_y[voxel - COLUMNS] / G_norm[voxel - COLUMNS];
		if( column > 0 && G_norm[voxel - 1] > 0.0 )		
			G[voxel] += G_x[voxel - 1] / G_norm[voxel - 1];
		
		// 3. Get the norm of the subgradient vector 
		//if( voxel == 0 )
		//{
			for( voxel = 0; voxel < NUM_VOXELS; voxel++ )
				norm_G += powf( G[voxel], 2 );
				//G_norm += G[voxel] * G[voxel];
			norm_G = sqrt(norm_G);
		//}
		// 4. Normalize the subgradient of the TV to produce v
		// If norm_G = 0, all elements of G are zero => all elements of v = 0.  
		if( norm_G != 0.0 )
			v[voxel] = G[voxel] / norm_G;		// Negative sign applied as subtraction in application of perturbation, eliminating unnecessary op
		else
			v[voxel] = 0.0;
		G[voxel] = 0.0;
		G_x[voxel] = 0.0;
		G_y[voxel] = 0.0;
		G_norm[voxel] = 0.0;
	}
}
__global__ void apply_perturbation_GPU(float* x, float* v, float beta, float* TV_y )
{
	int column = blockIdx.x;
	int row = blockIdx.y;
	int slice = threadIdx.x;
	int voxel = column  + row * COLUMNS + slice * ROWS * COLUMNS;
	
	x[voxel] += beta * v[voxel];						// Negative sign imposing steepest descent applied here as subtraction to eliminate math op calculating v
	if( voxel == 0)
		*TV_y = calculate_total_variation_GPU(x);
	
	//return TV_y;
}
void perturb_x( float& beta )
{
	float TV_y, TV_y_previous = 0.0;
	float TV_x = calculate_total_variation(x_h);			// Calculate total variation for unperturbed image
	generate_perturbation_vector();
	// Scott has slices = 1 as starting point, not sure why yet
	for( int voxel = 0; voxel < NUM_VOXELS; voxel++ )
		x_h[voxel] = x_h[voxel] - beta * v_h[voxel];			// Negative sign imposing steepest descent applied here as subtraction to eliminate math op calculating v
	
	// Beginning with beta from previous perturbation, iteratively halve it until TV improves or relative difference ratio between successive beta < TV_THRESHOLD
	while(true)
	{
		TV_y = calculate_total_variation(x_h);
		if( ( TV_y <= TV_x ) || ( fabs( TV_y - TV_y_previous ) / TV_y < TV_THRESHOLD ) )			// ( fabs( TV_y_previous - TV_y ) / TV_y * 100 < 0.01 )
			return;
		else
		{ 
			beta /= 2;
			TV_y_previous = TV_y;
			// Scott has slices = 1 as starting point, not sure why yet
			for( int voxel = 0; voxel < NUM_VOXELS; voxel++ )			// Exploit 1 - 1/2 = 1/2, 1/2 - 1/4 = 1/4, ... to get x - beta/2*v from previous value x + beta*v
				x_h[voxel] = x_h[voxel] + beta * v_h[voxel];			// x = x - beta/2*v = (x - beta*v) + beta/2*v
		}																// x = x - beta/4*v = ((x - beta*v) + beta/2*v) + beta/4*v = (x - beta/2*v) + beta/4*v = x - beta/4*v
	}
}
void perturb_x_GPU(float& beta)
{
	float TV_x = calculate_total_variation(x_h);					// Calculate total variation for unperturbed image
	float TV_y, TV_y_previous = 0.0;
	dim3 dimGrid(COLUMNS, ROWS);
	dim3 dimBlock = SLICES;
	generate_perturbation_vector_GPU<<< dimGrid, dimBlock>>>( G_x_d, G_y_d, G_norm_d, G_d, v_d, x_d );
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error generating perturbation vector: %s\n", cudaGetErrorString(cudaStatus));
	
	apply_perturbation_GPU<<< dimGrid, dimBlock >>>(x_d, v_d, -beta, TV_y_d );
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error applying perturbation: %s\n", cudaGetErrorString(cudaStatus));

		
	cudaMemcpy(TV_y_h, TV_y_d, sizeof(float), cudaMemcpyDeviceToHost );
	// Beginning with beta from previous perturbation, iteratively halve it until TV improves or relative difference ratio between successive beta < TV_THRESHOLD
	while(true)
	{
		//TV_y = calculate_total_variation_GPU(x);
		if( ( *TV_y_h <= TV_x ) || ( fabs( *TV_y_h - TV_y_previous ) / *TV_y_h < TV_THRESHOLD ) )			// ( fabs( TV_y_previous - TV_y ) / TV_y * 100 < 0.01 )
			return;
		else
		{ 
			beta /= 2;
			TV_y_previous = *TV_y_h;
			apply_perturbation_GPU<<< dimGrid, dimBlock >>>(x_d, v_d, beta, TV_y_d );	
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("Error applying perturbation: %s\n", cudaGetErrorString(cudaStatus));

			cudaMemcpy(TV_y_h, TV_y_d, sizeof(float), cudaMemcpyDeviceToHost );
		}													
	}
}
void TVS_DROP_full_tx_tabulated(const int num_histories)	
{
	// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = TABULATED
	cudaError_t cudaStatus;
	char iterate_filename[256];
	int remaining_histories, start_position = 0, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>( COLUMNS / VOXELS_PER_THREAD );
	//float beta = 1.0;
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );

	// Host and GPU array allocations and host->GPU transfers/initializations for DROP and TVS
	DROP_allocations(num_histories);
	DROP_host_2_device( start_position, num_histories);
	allocate_perturbation_arrays(false);

	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			// Proceed using DROP_BLOCK_SIZE histories or all remaining histories if this is less than DROP_BLOCK_SIZE
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	

			perturb_x(BETA);							// Beginning with previous value of beta, halve beta until TV improves or changes < TV_THRESHOLD
			x_host_2_GPU();									// Transfer perturbed image back to GPU for update
			// Set GPU grid/block configuration and perform DROP update calculations
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU_tabulated<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, start_position, num_histories, LAMBDA,
				sin_table_d, cos_table_d, scattering_table_d, poly_1_2_d, poly_2_3_d, poly_3_4_d, poly_2_6_d, poly_3_12_d
			);	
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			// Apply DROP update to image
			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;		
			start_position		+= DROP_BLOCK_SIZE;		
		}
		
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
	deallocate_perturbation_arrays(false);
	DROP_deallocations();
}
void TVS_DROP_full_tx_tabulated_GPU(const int num_histories)	
{
	// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = TABULATED
	cudaError_t cudaStatus;
	char iterate_filename[256];
	int remaining_histories, start_position = 0, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>( COLUMNS / VOXELS_PER_THREAD );
	//float beta = 1.0;
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );

	// Host and GPU array allocations and host->GPU transfers/initializations for DROP and TVS
	DROP_allocations(num_histories);
	DROP_host_2_device( start_position, num_histories);
	allocate_perturbation_arrays(true);

	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			// Proceed using DROP_BLOCK_SIZE histories or all remaining histories if this is less than DROP_BLOCK_SIZE
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	

			perturb_x_GPU(BETA);								// Beginning with previous value of beta, halve beta until TV improves or changes < TV_THRESHOLD
			
			// Set GPU grid/block configuration and perform DROP update calculations
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU_tabulated<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, start_position, num_histories, LAMBDA,
				sin_table_d, cos_table_d, scattering_table_d, poly_1_2_d, poly_2_3_d, poly_3_4_d, poly_2_6_d, poly_3_12_d
			);	
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			// Apply DROP update to image
			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;		
			start_position		+= DROP_BLOCK_SIZE;		
		}
		
		// Transfer the updated image to the host and write it to disk
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 
		{
			x_GPU_2_host();
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		}
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
	deallocate_perturbation_arrays(true);
	DROP_deallocations();
}
void DROP_TVS_full_tx_tabulated(const int num_histories)	
{
	// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = TABULATED
	cudaError_t cudaStatus;
	char iterate_filename[256];
	int remaining_histories, start_position = 0, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>( COLUMNS / VOXELS_PER_THREAD );
	//float beta = 1.0;
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );

	// Host and GPU array allocations and host->GPU transfers/initializations for DROP and TVS
	DROP_allocations(num_histories);
	DROP_host_2_device( start_position, num_histories);
	allocate_perturbation_arrays(false);

	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			// Proceed using DROP_BLOCK_SIZE histories or all remaining histories if this is less than DROP_BLOCK_SIZE
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	

			// Set GPU grid/block configuration and perform DROP update calculations
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU_tabulated<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, start_position, num_histories, LAMBDA,
				sin_table_d, cos_table_d, scattering_table_d, poly_1_2_d, poly_2_3_d, poly_3_4_d, poly_2_6_d, poly_3_12_d
			);	
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			// Apply DROP update to image
			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );

			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;		
			start_position		+= DROP_BLOCK_SIZE;		
		}
		
		// Transfer the updated image to the host and write it to disk
		x_GPU_2_host();
		perturb_x(BETA);							// Beginning with previous value of beta, halve beta until TV improves or changes < TV_THRESHOLD
		x_host_2_GPU();									// Transfer perturbed image back to GPU for update
		
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 	
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
		
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
	DROP_deallocations();
	deallocate_perturbation_arrays(false);
}
void DROP_TVS_full_tx_tabulated_GPU(const int num_histories)	
{
	// DROP_TX_MODE = FULL_TX, MLP_ALGORITHM = TABULATED
	cudaError_t cudaStatus;
	char iterate_filename[256];
	int remaining_histories, start_position = 0, histories_2_process, num_blocks;
	int column_blocks = static_cast<int>( COLUMNS / VOXELS_PER_THREAD );
	//float beta = 1.0;
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );

	// Host and GPU array allocations and host->GPU transfers/initializations for DROP and TVS
	DROP_allocations(num_histories);
	DROP_host_2_device( start_position, num_histories);
	allocate_perturbation_arrays(true);

	for(int iteration = 1; iteration <= ITERATIONS ; ++iteration) 
	{	    
		sprintf(print_statement, "Performing iteration %u of image reconstruction", iteration);
		print_colored_text(print_statement, LIGHT, CYAN );
		remaining_histories = num_histories;
		start_position = 0;
		timer( START, begin_DROP_iteration, "for DROP iteration");	
		while( remaining_histories > 0 )
		{
			// Proceed using DROP_BLOCK_SIZE histories or all remaining histories if this is less than DROP_BLOCK_SIZE
			if( remaining_histories > DROP_BLOCK_SIZE )
				histories_2_process = DROP_BLOCK_SIZE;
			else
				histories_2_process = remaining_histories;	

			// Set GPU grid/block configuration and perform DROP update calculations
			num_blocks = static_cast<int>( (histories_2_process - 1 + HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) / (HISTORIES_PER_BLOCK*HISTORIES_PER_THREAD) );  
			block_update_GPU_tabulated<<< num_blocks, HISTORIES_PER_BLOCK >>>
			( 
				x_d, x_entry_d, y_entry_d, z_entry_d, xy_entry_angle_d, xz_entry_angle_d, x_exit_d, y_exit_d, z_exit_d,  xy_exit_angle_d, 
				xz_exit_angle_d, WEPL_d, first_MLP_voxel_d, x_update_d, S_d, start_position, num_histories, LAMBDA,
				sin_table_d, cos_table_d, scattering_table_d, poly_1_2_d, poly_2_3_d, poly_3_4_d, poly_2_6_d, poly_3_12_d
			);	
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("block_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));
	
			x_update_GPU<<< dimGrid, dimBlock >>>( x_d, x_update_d, S_d );	// Apply DROP update to image
			cudaStatus = cudaGetLastError();
			if (cudaStatus != cudaSuccess) 
				printf("x_update_GPU Error: %s\n", cudaGetErrorString(cudaStatus));

			remaining_histories -= DROP_BLOCK_SIZE;		
			start_position		+= DROP_BLOCK_SIZE;		
		}		
		x_GPU_2_host();													// Transfer the updated image to the host and apply TVS, then write it to disk (if desired)
		perturb_x_GPU(BETA);											// Beginning with previous value of beta, halve beta until TV improves or changes < TV_THRESHOLD		
		
		sprintf(iterate_filename, "%s%d", "x_", iteration );
		if( WRITE_X_KI ) 		
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true ); 
	
		sprintf(print_statement, "for DROP iteration %d", iteration );
		execution_time_DROP_iteration = timer( STOP, begin_DROP_iteration, print_statement);	
		execution_times_DROP_iterations.push_back(execution_time_DROP_iteration);
	}
	DROP_deallocations();
	deallocate_perturbation_arrays(true);
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************************* Image Reconstruction (GPU) **********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void image_reconstruction()
{
	/*************************************************************************************************************************************************************************
	*********************************************************************************************GPU**************************************************************************
	**************************************************************************************************************************************************************************
	//1)Set MLP_ENDPOINTS_FILE_EXISTS = false
	//2)GPU Storage has been declared in recon_volume_intersections() function
	//3) define collect_MLP_endpoints_d as a helper function	
	*/	
	/*************************************************************************************************************************************************************************/
	/************************************************************************* Determine MLP endpoints ***********************************************************************/
	/*************************************************************************************************************************************************************************/
	//collect_MLP_endpoints();
	if( !MLP_ENDPOINTS_FILE_EXISTS )
	{
		puts("Calculating hull entry/exit coordinates and writing results to disk...");
		collect_MLP_endpoints();
	}
	else
	{
		puts("Reading hull entry/exit coordinates from disk...");
		reconstruction_histories = read_MLP_endpoints();
	}
	puts("Acquistion of hull entry/exit coordinates complete.");
	printf("%d of %d protons passed through hull\n", reconstruction_histories, post_cut_histories);
	/*************************************************************************************************************************************************************************/
	/****************************************************************** Array allocations and initializations ****************************************************************/
	/*************************************************************************************************************************************************************************/
	MLP_h = (unsigned int*)calloc( MAX_INTERSECTIONS, sizeof(unsigned int));
	float* MLP_errors = (float*)calloc( MAX_INTERSECTIONS, sizeof(float));
	A_ij_h = (float*)calloc( 1, sizeof(float));
	norm_Ai = (double*)calloc( NUM_VOXELS, sizeof(double));
	//MLP_block_h = (unsigned int*)calloc( BLOCK_SIZE * MAX_INTERSECTIONS, sizeof(unsigned int));
	S_h = (unsigned int*)calloc( NUM_VOXELS, sizeof(unsigned int));	
	x_update_h = (float*)calloc( NUM_VOXELS, sizeof(float));
	
	//if( (MLP_h == NULL) || (MLP_block_h == NULL) || (S_h == NULL) || (x_update_h == NULL) )
	//if( (MLP_h == NULL) ||  (S_h == NULL) || (x_update_h == NULL) )
	if( (MLP_h == NULL) ||  (S_h == NULL) || (x_update_h == NULL) || ( norm_Ai == NULL ) )
	//if( (MLP_h == NULL) || (MLP_block_h == NULL) || (x_update_h == NULL) )
	{
		puts("ERROR: Memory allocation for one or more image reconstruction arrays failed.");
		exit_program_if(true);
	}
	//unsigned int block_intersections = 0;
	unsigned int MLP_intersections = 0;
	//cudaMalloc((void**) &x_d, SIZE_IMAGE_FLOAT );
	//cudaMalloc((void**) &x_update_d, SIZE_IMAGE_DOUBLE );
	//cudaMalloc((void**) &S_d, SIZE_IMAGE_UINT );

	//cudaMemcpy( x_d, x_h, SIZE_IMAGE_FLOAT, cudaMemcpyHostToDevice );
	/*************************************************************************************************************************************************************************/
	/************************************************************************* Generate history sequence *********************************************************************/
	/*************************************************************************************************************************************************************************/	
	puts("Generating cyclic and exhaustive ordering of histories...");
	history_sequence = (ULL*)calloc( reconstruction_histories, sizeof(ULL));
	generate_history_sequence(reconstruction_histories, PRIME_OFFSET, history_sequence );
	puts("History order generation complete.");
	/*************************************************************************************************************************************************************************/
	/**************************************************************** Create and open output file for MLP paths **************************************************************/
	/*************************************************************************************************************************************************************************/
	char MLP_filename[256];
	sprintf(MLP_filename, "%s%s/%s_r=%d.bin", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_PATHS_FILENAME, HULL_AVG_FILTER_RADIUS );
	unsigned int start_history = 0, end_history = reconstruction_histories;
	ULL i;	
	if( !MLP_FILE_EXISTS )
	{
		puts("Precalculating MLP paths and writing them to disk...");
		FILE* write_MLPs = fopen(MLP_filename, "wb");
		fprintf(write_MLPs, "%u\n", reconstruction_histories);	
		for( unsigned int n = start_history; n < end_history; n++ )
		{		
			i = history_sequence[n];			
			MLP_intersections = find_MLP( MLP_h, A_ij_h, x_entry_vector[i], y_entry_vector[i], z_entry_vector[i], x_exit_vector[i], y_exit_vector[i], z_exit_vector[i], xy_entry_angle_vector[i], xz_entry_angle_vector[i], xy_exit_angle_vector[i], xz_exit_angle_vector[i], voxel_x_vector[i], voxel_y_vector[i], voxel_z_vector[i]);
			write_MLP( write_MLPs, MLP_h, MLP_intersections);
		}
		fclose(write_MLPs);
		puts("MLP paths calculated and written to disk");
	}	
	/*************************************************************************************************************************************************************************/
	/************************************************************************ Perform image reconstruction *******************************************************************/
	/*************************************************************************************************************************************************************************/	
	puts("Starting image reconstruction...");
	printf("ETA_VAL: %f\n",ETA);
	printf("PSI_SIGN: %d\n", PSI_SIGN);
	printf("LAMBDA: %f\n", LAMBDA);
	
	char iterate_filename[256];
	char MLP_error_filename[256];
	sprintf(MLP_error_filename, "%s%s/%s_r=%d.bin", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_PATHS_ERROR_FILENAME, HULL_AVG_FILTER_RADIUS );
	FILE* read_MLPs;	
	FILE* read_MLPs_error;
	unsigned int num_MLPs;
	double effective_chord_length  = VOXEL_WIDTH;
	//double u_0, t_0, v_0, u_2, t_2, v_2;
	for( unsigned int iteration = 1; iteration <= ITERATIONS; iteration++ )
	{
		printf("Performing iteration %u of image reconstruction\n", iteration);
		read_MLPs = fopen(MLP_filename, "rb");
		read_MLPs_error = fopen(MLP_error_filename,"rb");
		fscanf(read_MLPs, "%u\n", &num_MLPs);
		end_history = min( num_MLPs, reconstruction_histories );
		/*********************************************************************************************************************************************************************/
		/********************************************************************** Perform MLP calculations *********************************************************************/
		/*********************************************************************************************************************************************************************/
		for( unsigned int n = start_history; n < end_history; n++ )
		{		
			i = history_sequence[n];			
			//MLP_intersections = find_MLP( MLP_h, A_ij_h, x_entry_vector[i], y_entry_vector[i], z_entry_vector[i], x_exit_vector[i], y_exit_vector[i], z_exit_vector[i], xy_entry_angle_vector[i], xz_entry_angle_vector[i], xy_exit_angle_vector[i], xz_exit_angle_vector[i], voxel_x_vector[i], voxel_y_vector[i], voxel_z_vector[i]);
			MLP_intersections = read_MLP( read_MLPs, MLP_h);
			read_MLP_error(read_MLPs_error,MLP_errors, MLP_intersections);
			//effective_chord_length = mean_chord_length2( x_entry_vector[i],  y_entry_vector[i],  z_entry_vector[i],  x_exit_vector[i],  y_exit_vector[i],  z_exit_vector[i], VOXEL_WIDTH, VOXEL_THICKNESS);
			//effective_chord_length = mean_chord_length( x_entry_vector[i],  y_entry_vector[i],  z_entry_vector[i],  x_exit_vector[i],  y_exit_vector[i],  z_exit_vector[i]);
			//u_0 = ( cos( xy_entry_angle_vector[i] ) * x_entry_vector[i] ) + ( sin( xy_entry_angle_vector[i] ) * y_entry_vector[i] );
			//t_0 = ( cos( xy_entry_angle_vector[i] ) * y_entry_vector[i] ) - ( sin( xy_entry_angle_vector[i] ) * x_entry_vector[i] );
			//u_2 = ( cos(xy_exit_angle_vector[i]) * x_exit_vector[i] ) + ( sin(xy_exit_angle_vector[i]) * y_exit_vector[i] );
			//t_2 = ( cos(xy_exit_angle_vector[i]) * y_exit_vector[i] ) - ( sin(xy_exit_angle_vector[i]) * x_exit_vector[i] );
			//effective_chord_length = EffectiveChordLength( atanf( (t_2 - t_0) / (u_2 - u_0) ), atanf( (z_exit_vector[i] - z_entry_vector[i]) / (u_2 - u_0) ) );

			effective_chord_length = EffectiveChordLength( ( xy_entry_angle_vector[i] + xy_exit_angle_vector[i] ) / 2, ( xz_entry_angle_vector[i] + xz_exit_angle_vector[i] ) / 2 );			
			//effective_chord_length = EffectiveChordLength(atan2((y_exit_vector[i] - y_entry_vector[i]),(x_exit_vector[i] - x_entry_vector[i])), atan2((z_exit_vector[i] - z_entry_vector[i]),(x_exit_vector[i] - x_entry_vector[i])));
			//if( n < 10 )
				//cout << WEPL_vector[i] << endl;
			//generate_error_for_MLP(MLP_error,MLP_intersections,0.0,1.0);
			//update_iterate22( WEPL_vector[i], effective_chord_length, x_h, MLP_h, MLP_intersections );
			//DROP_blocks_red(MLP_h, x_h, WEPL_vector[i], MLP_intersections,effective_chord_length, x_update_h, S_h);
			//DROP_blocks_error( MLP_h, MLP_errors, x_h, WEPL_vector[i], MLP_intersections, effective_chord_length, x_update_h, S_h );
			//DROP_blocks_error_red_sp(MLP_h, x_h, WEPL_vector[i], MLP_intersections, effective_chord_length, x_update_h, S_h);
			DROP_blocks_error_red( MLP_h, MLP_errors, x_h, WEPL_vector[i], MLP_intersections, effective_chord_length, x_update_h, S_h );
			//DROP_blocks( MLP_h, x_h, WEPL_vector[i], MLP_intersections, effective_chord_length, x_update_h, S_h );
			//DROP_blocks_robust2( MLP_h, x_h, WEPL_vector[i], MLP_intersections, effective_chord_length, x_update_h, S_h, norm_Ai );
			
			//DROP_blocks2( MLP_h, x_h, WEPL_vector[i], MLP_intersections, effective_chord_length, x_update_h, MLP_block_h, block_intersections, S_h );
			//DROP_blocks3( MLP_h, x_h, WEPL_vector[i], MLP_intersections, effective_chord_length, x_update_h, MLP_block_h, block_intersections );
			if( (n+1) % DROP_BLOCK_SIZE == 0 )
			{
			//	DROP_update_robust2( x_h, x_update_h, S_h, norm_Ai );
				DROP_update( x_h, x_update_h, S_h );			
				//DROP_update2( x_h, x_update_h, MLP_block_h, block_intersections, S_h );
				//DROP_update3( x_h, x_update_h, MLP_block_h, block_intersections);
				//	//update_x();
			}
		}	
		fclose(read_MLPs);
		fclose(read_MLPs_error);
		sprintf(iterate_filename, "%s%d", "x_", iteration );		
		if( WRITE_X_KI )
			array_2_disk(iterate_filename, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, x_h, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	}
	puts("Image reconstruction complete.");
}
void image_reconstruction_GPU() 
{  
	//char statement[256];
	/***********************************************************************************************************************************************************************************************************************/
	/****************************************************************** Find MLP endpoints and remove data for protons that did not enter and/or exit the hull *************************************************************/
	/***********************************************************************************************************************************************************************************************************************/
	sprintf(print_statement, "Determining if and where each of the protons enters/exits the hull to (1) define the endpoints of MLP and (2) remove protons that missed the hull from consideration in reconstruction");
	print_section_header( print_statement, '-', DARK, CYAN );
	
	timer( START, begin_endpoints, "for finding MLP endpoints");	
	int remaining_histories = post_cut_histories, start_position = 0, histories_2_process = 0;
	reconstruction_histories = 0;

	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Before image reconstruction Error: %s\n", cudaGetErrorString(cudaStatus));
		
	//post_cut_histories = 100000000;
	first_MLP_voxel_vector.resize( post_cut_histories ); 
	reconstruction_cuts_hull_transfer();		// Free hull_d which may not be aligned well on the GPU and reallocate/transfer it to GPU again

	sprintf(print_statement, "Collecting MLP endpoints...");
	print_colored_text(print_statement, LIGHT, CYAN );
	if( ENDPOINTS_TX_MODE == FULL_TX )
	{
		sprintf(print_statement, "Identifying MLP endpoints with all data transferred to the GPU before the 1st kernel launch");
		print_colored_text(print_statement, LIGHT, CYAN );
		if( ENDPOINTS_ALG == USE_BOOL_ARRAY )
		{
			sprintf(print_statement, "Using boolean array to identify protons hitting/missing hull");
			print_colored_text(print_statement, LIGHT, CYAN );
			reconstruction_cuts_allocations(post_cut_histories);
			reconstruction_cuts_host_2_device( 0, post_cut_histories );  
			reconstruction_cuts_full_tx( post_cut_histories );
			reconstruction_cuts_deallocations();
		}
		// 
		else if( ENDPOINTS_ALG == NO_BOOL_ARRAY )
		{
			sprintf(print_statement, "Using hull entry voxel # to identify protons hitting/missing hull");
			print_colored_text(print_statement, LIGHT, CYAN );
			reconstruction_cuts_allocations_nobool(post_cut_histories);
			reconstruction_cuts_host_2_device_nobool( 0, post_cut_histories );  
			reconstruction_cuts_full_tx_nobool( post_cut_histories );
			reconstruction_cuts_deallocations_nobool();
		}
	}
	else if( ENDPOINTS_TX_MODE == PARTIAL_TX )
	{
		sprintf(print_statement, "Identifying MLP endpoints using partial data transfers with GPU arrays allocated/freed each kernel launch");
		print_colored_text(print_statement, LIGHT, CYAN );
		if( ENDPOINTS_ALG == USE_BOOL_ARRAY )
		{
			sprintf(print_statement, "Using boolean array to identify protons hitting/missing hull");
			print_colored_text(print_statement, LIGHT, CYAN );
			while( remaining_histories > 0 )
			{
				if( remaining_histories > MAX_ENDPOINTS_HISTORIES )
					histories_2_process = MAX_ENDPOINTS_HISTORIES;
				else
					histories_2_process = remaining_histories;		
				reconstruction_cuts_partial_tx( start_position, histories_2_process );
				remaining_histories -= MAX_ENDPOINTS_HISTORIES;
				start_position		+= MAX_ENDPOINTS_HISTORIES;
			}
		}
		else if( ENDPOINTS_ALG == NO_BOOL_ARRAY )
		{
			sprintf(print_statement, "Using hull entry voxel # to identify protons hitting/missing hull");
			print_colored_text(print_statement, LIGHT, CYAN );
			while( remaining_histories > 0 )
			{
				if( remaining_histories > MAX_ENDPOINTS_HISTORIES )
					histories_2_process = MAX_ENDPOINTS_HISTORIES;
				else
					histories_2_process = remaining_histories;	
				reconstruction_cuts_partial_tx_nobool( start_position, histories_2_process );
				remaining_histories -= MAX_ENDPOINTS_HISTORIES;
				start_position		+= MAX_ENDPOINTS_HISTORIES;
			}	
		}
	}
	else if( ENDPOINTS_TX_MODE == PARTIAL_TX_PREALLOCATED )
	{
		sprintf(print_statement, "Identifying MLP endpoints using partial data transfers with preallocated GPU arrays reused each kernel launch");
		print_colored_text(print_statement, LIGHT, CYAN );
		if( ENDPOINTS_ALG == USE_BOOL_ARRAY )
		{
			sprintf(print_statement, "Using boolean array to identify protons hitting/missing hull");
			print_colored_text(print_statement, LIGHT, CYAN );
			reconstruction_cuts_allocations(MAX_ENDPOINTS_HISTORIES); 
			while( remaining_histories > 0 )
			{
				if( remaining_histories > MAX_ENDPOINTS_HISTORIES )
					histories_2_process = MAX_ENDPOINTS_HISTORIES;
				else
					histories_2_process = remaining_histories;			
				reconstruction_cuts_partial_tx_preallocated( start_position, histories_2_process );
				remaining_histories -= MAX_ENDPOINTS_HISTORIES;
				start_position		+= MAX_ENDPOINTS_HISTORIES;
			}
			reconstruction_cuts_deallocations();
		}
		else if( ENDPOINTS_ALG == NO_BOOL_ARRAY )
		{
			sprintf(print_statement, "Using hull entry voxel # to identify protons hitting/missing hull");
			print_colored_text(print_statement, LIGHT, CYAN );
			reconstruction_cuts_allocations_nobool(MAX_ENDPOINTS_HISTORIES); 
			while( remaining_histories > 0 )
			{
				if( remaining_histories > MAX_ENDPOINTS_HISTORIES )
					histories_2_process = MAX_ENDPOINTS_HISTORIES;
				else
					histories_2_process = remaining_histories;	
				reconstruction_cuts_partial_tx_preallocated_nobool( start_position, histories_2_process );
				remaining_histories -= MAX_ENDPOINTS_HISTORIES;
				start_position		+= MAX_ENDPOINTS_HISTORIES;
			}	
			reconstruction_cuts_deallocations_nobool();
		}
	}
	sprintf(print_statement, "Reconsruction Cuts Complete.");
	print_section_exit( print_statement, SECTION_EXIT_STRING, DARK, RED );

	//percentage_pass_hull_cuts
	sprintf(print_statement, "Protons that intersected the hull and will be used for reconstruction = %d\n", reconstruction_histories);
	print_colored_text( print_statement, DARK, GREEN );
	execution_time_endpoints = timer( STOP, begin_endpoints, "for finding MLP endpoints");
		
	// Reduce the size of the vectors to reconstruction_histories and shrink their capacity to match
	first_MLP_voxel_vector.resize( reconstruction_histories );
	//first_MLP_voxel_vector.shrink_to_fit();
	resize_vectors( reconstruction_histories );
	//shrink_vectors();

	for( int i = 0; i < reconstruction_histories; i++ )
	{
		if( first_MLP_voxel_vector[i] >= NUM_VOXELS + 1 )
			cout << "i = " << i << "voxel = " << first_MLP_voxel_vector[i] << endl;
	}
	/***********************************************************************************************************************************************************************************************************************/
	/********************************************************************************************* Initialize Reconstructed Image ******************************************************************************************/
	/***********************************************************************************************************************************************************************************************************************/
	timer( START, begin_init_image, "for initializing reconstructed image x");
	
	allocate_x();				// allocate GPU memory for x
	x_host_2_GPU();				// transfer initial iterate x_0 to x_d
	DROP_allocate_arrays();		// allocate GPU memory for x_update and S
	
	int column_blocks = static_cast<int>(COLUMNS/VOXELS_PER_THREAD);
	dim3 dimBlock( SLICES );
	dim3 dimGrid( column_blocks, ROWS );
	DROP_init_arrays_GPU<<< dimGrid, dimBlock >>>(x_update_d, S_d);
	
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("Error: %s\n", cudaGetErrorString(cudaStatus));
	
	execution_time_init_image = timer( STOP, begin_init_image, "for initializing reconstructed image x");	
	/***********************************************************************************************************************************************************************************************************************/
	/************************************************************************************************ Image Reconstruction *************************************************************************************************/
	/***********************************************************************************************************************************************************************************************************************/
	sprintf(print_statement, "Performing MLP and image reconstrution");
	print_section_header( print_statement, '-', DARK, CYAN );
	
	timer( START, begin_DROP, "for all iterations of DROP");	
	//reconstruction_histories = 20000000;
	if( TVS_ON )
	{
		// Generate MLP lookup tables and transfer these to the GPU
		timer( START, begin_tables, "for generating MLP lookup tables and transferring them to the GPU");	
		generate_MLP_lookup_tables();
		execution_time_tables = timer( STOP, begin_tables, "for generating MLP lookup tables and transferring them to the GPU");	
				
		if( TVS_FIRST )
		{
			if( TVS_PARALLEL ) TVS_DROP_full_tx_tabulated_GPU(reconstruction_histories);
			else TVS_DROP_full_tx_tabulated(reconstruction_histories);
		}
		else
		{
			if( TVS_PARALLEL ) DROP_TVS_full_tx_tabulated_GPU(reconstruction_histories);			
			else DROP_TVS_full_tx_tabulated(reconstruction_histories);
		}
		free_MLP_lookup_tables();
	}
	else
	{
		// Calculate MLP explicitly
		if( MLP_ALGORITHM == STANDARD )
		{
			// Transfer data for ALL reconstruction_histories before beginning image reconstruction
			if( DROP_TX_MODE == FULL_TX ) DROP_full_tx( reconstruction_histories );
			// Transfer data to GPU as needed and allocate/free the corresponding GPU arrays each kernel launch, explcitly calculating MLP each time
			else if( DROP_TX_MODE == PARTIAL_TX ) DROP_partial_tx( reconstruction_histories );
			// Transfer data to GPU as needed but allocate and resuse the GPU arrays each kernel launch, explcitly calculating MLP each time
			else if( DROP_TX_MODE == PARTIAL_TX_PREALLOCATED ) DROP_partial_tx_preallocated( reconstruction_histories);
		}
		// Use MLP lookup tables 
		else if( MLP_ALGORITHM == TABULATED )
		{
			// Generate MLP lookup tables and transfer these to the GPU
			timer( START, begin_tables, "for generating MLP lookup tables and transferring them to the GPU");	
			generate_MLP_lookup_tables();
			execution_time_tables = timer( STOP, begin_tables, "for generating MLP lookup tables and transferring them to the GPU");	
	
			// Transfer data for ALL reconstruction_histories before beginning image reconstruction, using the MLP lookup tables each time
			if( DROP_TX_MODE == FULL_TX ) DROP_full_tx_tabulated(reconstruction_histories);
			// Transfer data to GPU as needed and allocate/free the corresponding GPU arrays each kernel launch, using the MLP lookup tables each time
			else if( DROP_TX_MODE == PARTIAL_TX ) DROP_partial_tx_tabulated( reconstruction_histories);
			// Transfer data to GPU as needed but allocate and resuse the GPU arrays each kernel launch, using the MLP lookup tables each time
			else if( DROP_TX_MODE == PARTIAL_TX_PREALLOCATED ) DROP_partial_tx_preallocated_tabulated( reconstruction_histories );
			free_MLP_lookup_tables();
		}// end: else if( MLP_ALGORITHM == TABULATED )
	}
	DROP_deallocate_arrays();	// deallocate GPU memory for x_update and S
	deallocate_x();				// deallocate GPU memory for x
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************************* Image Reconstruction (host) *********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void write_reconstruction_settings()
{
	FILE* settings_file = fopen("reconstruction_settings.txt", "w");
	time_t rawtime;
	struct tm * timeinfo;

	time (&rawtime);
	timeinfo = localtime (&rawtime);
	fprintf (settings_file, "Current local time and date: %s", asctime(timeinfo));
	fprintf(settings_file, "PRIME_OFFSET = %d \n",  PRIME_OFFSET);
	fprintf(settings_file, "AVG_FILTER_HULL = %s \n",  bool_2_string(AVG_FILTER_HULL));
	
	fprintf(settings_file, "HULL_AVG_FILTER_RADIUS = %d \n",  HULL_AVG_FILTER_RADIUS);
	fprintf(settings_file, "HULL_AVG_FILTER_THRESHOLD = %d \n",  HULL_AVG_FILTER_THRESHOLD);
	fprintf(settings_file, "LAMBDA = %d \n",  LAMBDA);
	switch( X_0 )
	{
		case X_HULL:		fprintf(settings_file, "X_0 = X_HULL\n");		break;
		case FBP_IMAGE:		fprintf(settings_file, "X_0 = FBP_IMAGE\n");	break;
		case HYBRID:		fprintf(settings_file, "X_0 = HYBRID\n");		break;
		case ZEROS:			fprintf(settings_file, "X_0 = ZEROS\n");		break;
		case IMPORT:		fprintf(settings_file, "X_0 = IMPORT\n");		break;
	}
	fprintf(settings_file, "IMPORT_FILTERED_FBP = %d \n", bool_2_string(IMPORT_FILTERED_FBP) );
	if( IMPORT_FILTERED_FBP )
	{
		fprintf(settings_file, "FILTERED_FBP_PATH = %d \n",  IMPORT_FBP_PATH);
	}
	switch( PROJECTION_ALGORITHM )
	{
		case X_HULL:		fprintf(settings_file, "PROJECTION_ALGORITHM = ART\n");		break;
		case FBP_IMAGE:		fprintf(settings_file, "PROJECTION_ALGORITHM = SART\n");	break;
		case HYBRID:		fprintf(settings_file, "PROJECTION_ALGORITHM = DROP\n");	break;
		case ZEROS:			fprintf(settings_file, "PROJECTION_ALGORITHM = BIP\n");		break;
		case IMPORT:		fprintf(settings_file, "PROJECTION_ALGORITHM = SAP\n");		break;
	}
	fclose(settings_file);
}
double mean_chord_length2( double x_entry, double y_entry, double z_entry, double x_exit, double y_exit, double z_exit, double xy_dim, double z_dim )
{
    double xy_angle = atan2( y_exit - y_entry, x_exit - x_entry);
    double xz_angle = atan2( z_exit - z_entry, x_exit - x_entry);

    double max_value_xy = xy_dim;
    double min_value_xy = xy_dim/sqrt(2.0);
    double range_xy = max_value_xy - min_value_xy;
    double A_xy = range_xy/2;
    double base_level_xy = (max_value_xy + min_value_xy)/2;
    double xy_dist_sqd = pow(base_level_xy + A_xy * cos(4*xy_angle), 2.0);

    //double max_value_xz = z_dim;
    //double min_value_xz = z_dim/sqrt(2.0);
    //double range_xz = max_value_xz - min_value_xz;
    //double A_xz = range_xz/2;
    //double base_level_xz = (max_value_xz + min_value_xz)/2;
    //double xz_dist_sqd = pow(base_level_xz + A_xz * cos(4*xz_angle), 2.0);
    double xz_dist_sqd = pow(sin(xz_angle), 2.0);

    return sqrt( xy_dist_sqd + xz_dist_sqd);
}
double mean_chord_length( double x_entry, double y_entry, double z_entry, double x_exit, double y_exit, double z_exit )
{

	double xy_angle = atan2( y_exit - y_entry, x_exit - x_entry);
	double xz_angle = atan2( z_exit - z_entry, x_exit - x_entry);

	//double int_part;
	//double reduced_angle = modf( xy_angle/(PI/2), &int_part );
	double reduced_angle = xy_angle - ( int( xy_angle/(PI/2) ) ) * (PI/2);
	double effective_angle_ut = fabs(reduced_angle);
	double effective_angle_uv = fabs(xz_angle );
	//
	double average_pixel_size = ( VOXEL_WIDTH + VOXEL_HEIGHT) / 2;
	double s = MLP_U_STEP;
	double l = average_pixel_size;

	double sin_ut_angle = sin(effective_angle_ut);
	double sin_2_ut_angle = sin(2 * effective_angle_ut);
	double cos_ut_angle = cos(effective_angle_ut);

	double sin_uv_angle = sin(effective_angle_uv);
	double sin_2_uv_angle = sin(2 * effective_angle_uv);
	double cos_uv_angle = cos(effective_angle_uv);

	double sum_ut_angles = sin(effective_angle_ut) + cos(effective_angle_ut);
	double sum_uv_angles = sin(effective_angle_uv) + cos(effective_angle_uv);
	
	////		(L/3) { [(s/L)^2 S{2O} - 6] / [(s/L)S{2O} - 2(C{O} + S{O}) ] } + { [(s/L)^2 S{2O}] / [ 2(C{O} + S{O})] } = (L/3)*[( (s/L)^3 * S{2O}^2 - 12 (C{O} + S{O}) ) / ( 2(s/L)*S{2O}*(C{O} + S{O}) - 4(C{O} + S{O})^2 ]
	////		

	double chord_length_t = ( l / 6.0 * sum_ut_angles) * ( pow(s/l, 3.0) * pow( sin(2 * effective_angle_ut), 2.0 ) - 12 * sum_ut_angles ) / ( (s/l) * sin(2 * effective_angle_ut) - 2 * sum_ut_angles );
	
	// Multiply this by the effective chord in the v-u plane
	double mean_pixel_width = average_pixel_size / sum_ut_angles;
	double height_fraction = SLICE_THICKNESS / mean_pixel_width;
	s = MLP_U_STEP;
	l = mean_pixel_width;
	double chord_length_v = ( l / (6.0 * height_fraction * sum_uv_angles) ) * ( pow(s/l, 3.0) * pow( sin(2 * effective_angle_uv), 2.0 ) - 12 * height_fraction * sum_uv_angles ) / ( (s/l) * sin(2 * effective_angle_uv) - 2 * height_fraction * sum_uv_angles );
	return sqrt(chord_length_t * chord_length_t + chord_length_v*chord_length_v);

	//double eff_angle_t,eff_angle_v;
	//
	////double xy_angle = atan2( y_exit - y_entry, x_exit - x_entry);
	////double xz_angle = atan2( z_exit - z_entry, x_exit - x_entry);

	////eff_angle_t = modf( xy_angle/(PI/2), &int_part );
	////eff_angle_t = fabs( eff_angle_t);
	////eff_angle_t = xy_angle - ( int( xy_angle/(PI/2) ) ) * (PI/2);
	//eff_angle_t = effective_angle_ut;
	//
	////cout << "eff angle t = " << eff_angle_t << endl;
	//eff_angle_v=fabs(xz_angle);
	//
	//// Get the effective chord in the t-u plane
	//double step_fraction=MLP_U_STEP/VOXEL_WIDTH;
	//double chord_length_2D=(1/3.0)*((step_fraction*step_fraction*sin(2*eff_angle_t)-6)/(step_fraction*sin(2*eff_angle_t)-2*(cos(eff_angle_t)+sin(eff_angle_t))) + step_fraction*step_fraction*sin(2*eff_angle_t)/(2*(cos(eff_angle_t)+sin(eff_angle_t))));
	//
	//// Multiply this by the effective chord in the v-u plane
	//double mean_pixel_width=VOXEL_WIDTH/(cos(eff_angle_t)+sin(eff_angle_t));
	//double height_fraction=SLICE_THICKNESS/mean_pixel_width;
	//step_fraction=MLP_U_STEP/mean_pixel_width;
	//double chord_length_3D=(1/3.0)*((step_fraction*step_fraction*sin(2*eff_angle_v)-6*height_fraction)/(step_fraction*sin(2*eff_angle_v)-2*(height_fraction*cos(eff_angle_v)+sin(eff_angle_v))) + step_fraction*step_fraction*sin(2*eff_angle_v)/(2*(height_fraction*cos(eff_angle_v)+sin(eff_angle_v))));
	//
	////cout << "2D = " << chord_length_2D << " 3D = " << chord_length_3D << endl;
	//return VOXEL_WIDTH*chord_length_2D*chord_length_3D;
}
double EffectiveChordLength(double abs_angle_t, double abs_angle_v)
{
	
	double eff_angle_t,eff_angle_v;
	
	eff_angle_t=abs_angle_t-((int)(abs_angle_t/(PI/2)))*(PI/2);
	
	eff_angle_v=fabs(abs_angle_v);
	
	// Get the effective chord in the t-u plane
	double step_fraction=MLP_U_STEP/VOXEL_WIDTH;
	double chord_length_2D=(1/3.0)*((step_fraction*step_fraction*sinf(2*eff_angle_t)-6)/(step_fraction*sinf(2*eff_angle_t)-2*(cosf(eff_angle_t)+sinf(eff_angle_t))) + step_fraction*step_fraction*sinf(2*eff_angle_t)/(2*(cosf(eff_angle_t)+sinf(eff_angle_t))));
	
	// Multiply this by the effective chord in the v-u plane
	double mean_pixel_width=VOXEL_WIDTH/(cosf(eff_angle_t)+sinf(eff_angle_t));
	double height_fraction=VOXEL_THICKNESS/mean_pixel_width;
	step_fraction=MLP_U_STEP/mean_pixel_width;
	double chord_length_3D=(1/3.0)*((step_fraction*step_fraction*sinf(2*eff_angle_v)-6*height_fraction)/(step_fraction*sinf(2*eff_angle_v)-2*(height_fraction*cosf(eff_angle_v)+sinf(eff_angle_v))) + step_fraction*step_fraction*sinf(2*eff_angle_v)/(2*(height_fraction*cosf(eff_angle_v)+sinf(eff_angle_v))));
	
	return VOXEL_WIDTH*chord_length_2D*chord_length_3D;
	 
}
/********************************************************************************************************* ART *********************************************************************************************************/
template< typename T, typename LHS, typename RHS> T discrete_dot_product( LHS*& left, RHS*& right, unsigned int*& elements, unsigned int num_elements )
{
	T sum = 0;
	for( unsigned int i = 0; i < num_elements; i++)
	{
		//cout << "iteration " << i << " " << "num_elements = " << num_elements << " " << elements[i] << " " << left[i] << " " << right[elements[i]] << endl;
		sum += ( left[i] * right[elements[i]] );
	}
	return sum;
}
template< typename T, typename RHS> T scalar_dot_product( double scalar, RHS*& vector, unsigned int*& elements, unsigned int num_elements )
{
	T sum = 0;
	for( unsigned int i = 0; i < num_elements; i++)
		sum += vector[elements[i]];
	return scalar * sum;
}
double update_vector_multiplier( double bi, double mean_chord_length, float*& x_k, unsigned int*& voxels_intersected, unsigned int num_intersections )
{
	// [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai = [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	double a_i_dot_x_k = scalar_dot_product<double, float>( mean_chord_length, x_k, voxels_intersected, num_intersections );
	return ( bi - a_i_dot_x_k ) /  (  pow(mean_chord_length, 2.0 ) * num_intersections );
}
void update_iterate( double bi, double mean_chord_length, float*& x_k, unsigned int*& voxels_intersected, unsigned int num_intersections )
{
	// x(K+1) = x(k) + [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	// double inner_product_ai_xk = discrete_dot_product<double>( a_i, x_k, voxels_intersected, num_intersections );
	// double norm_ai_squared = std::inner_product(a_i, a_i + num_intersections, a_i, 0.0 );
	
	//double inner_product_ai_xk = scalar_dot_product<double>( mean_chord_length, x_k, voxels_intersected, num_intersections );
	//double norm_ai_squared = pow(mean_chord_length, 2.0 ) * num_intersections;
	
	double a_i_dot_x_k = 0;
	for( unsigned int i = 0; i < num_intersections; i++)
		a_i_dot_x_k += x_k[voxels_intersected[i]];
	double update_value =  LAMBDA * ( bi - mean_chord_length * a_i_dot_x_k ) /  ( num_intersections * pow( mean_chord_length, 2.0)  ) * mean_chord_length;	
	//for( unsigned int intersection = 0; intersection < num_voxel_scales; intersection++ )
		//x_k[voxels_intersected[intersection]] += voxel_scales[intersection] * update_value;
	for( unsigned int intersection = 0; intersection < num_intersections; intersection++)
	//for( unsigned int intersection = num_voxel_scales; intersection < num_intersections; intersection++)
		x_k[voxels_intersected[intersection]] += update_value;
}
/*****************************************************************************************Generate Number from Normal Distribution**************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
/************************************************************************************* Robust DROP Image Reconstruction Algorithms *************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void DROP_blocks_error_red_sp(unsigned int*& a_i, float*& x_k, double bi, unsigned int num_intersections, double mean_chord_length, float*& x_update, unsigned int*& S) {
  
	double a_i_dot_x_k = 0.0;
	double a_i_dot_a_i = 0.0;
	double modified_cord_length = 0.0;

	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	for(unsigned int i = 0 ; i < num_intersections ; i++) {
	  
	  if(i % 5 == 0) {
	    
	    modified_cord_length = 1.8;
	  }
	  
	  else {
	    
	    modified_cord_length = mean_chord_length;
	  }
	  a_i_dot_x_k += (modified_cord_length * x_k[i]);
	  a_i_dot_a_i += pow(modified_cord_length,2.0);
	  
	}
	// (2) ( bi - <ai, x(k)> ) / <ai, ai>
	double residual =  bi - a_i_dot_x_k;
	//double scaled_residual = ( bi - a_i_dot_x_k ) /  a_i_dot_a_i;
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	//double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	
	for( unsigned int intersection = 0; intersection < num_intersections; intersection++)
	{
	  
		double psi_i = ((1.0 - x_k[a_i[intersection]]) * ETA) * PSI_SIGN;
		if(intersection % 5 == 0) {
	    
		  modified_cord_length = 1.8;
		}
	  
		else {
	    
		  modified_cord_length = mean_chord_length;
		}
		
		x_update[a_i[intersection]] += modified_cord_length * LAMBDA * (residual / (a_i_dot_a_i + psi_i));
		S[a_i[intersection]] += 1;
	}
  
}
void DROP_blocks_error_red( unsigned int*& a_i, float*& row_error,float*& x_k, double bi, unsigned int num_intersections, double mean_chord_length, float*& x_update, unsigned int*& S )
{
  
        double a_i_dot_x_k = 0.0;
	double a_i_dot_a_i = 0.0;
	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	for(unsigned int i = 0 ; i < num_intersections ; i++) {
	  
	  double error = row_error[i];
	  a_i_dot_x_k += ((mean_chord_length + (error * ETA)) * x_k[i]);
	  a_i_dot_a_i += pow(mean_chord_length + (error * ETA),2.0);
	  
	}
	
	double residual =  bi - a_i_dot_x_k;
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	//double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	
	for( unsigned int intersection = 0; intersection < num_intersections; intersection++)
	{
	        double psi_i = ((1.0 - x_k[a_i[intersection]]) * ETA) * PSI_SIGN;
		
		double update_value = (mean_chord_length + (row_error[intersection] * ETA)) * LAMBDA * (residual / (a_i_dot_a_i + psi_i)); 
		x_update[a_i[intersection]] += update_value;
		S[a_i[intersection]] += 1;
	}
}
void DROP_blocks_error( unsigned int*& a_i, float*& row_error,float*& x_k, double bi, unsigned int num_intersections, double mean_chord_length, float*& x_update, unsigned int*& S )
{
  
        double a_i_dot_x_k = 0.0;
	double a_i_dot_a_i = 0.0;
	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	for(unsigned int i = 0 ; i < num_intersections ; i++) {
	  
	  float error = row_error[i];
	  a_i_dot_x_k += ((mean_chord_length + error * ETA * mean_chord_length) * x_k[i]);
	  a_i_dot_a_i += pow((mean_chord_length + error * ETA * mean_chord_length),2.0);
	  
	}
	// (2) ( bi - <ai, x(k)> ) / <ai, ai>
	double scaled_residual = ( bi - a_i_dot_x_k ) /  a_i_dot_a_i;
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	//double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	
	for( unsigned int intersection = 0; intersection < num_intersections; intersection++)
	{
		
		x_update[a_i[intersection]] += (mean_chord_length + row_error[intersection] * ETA * mean_chord_length ) * LAMBDA * scaled_residual;
		S[a_i[intersection]] += 1;
	}
}
void DROP_blocks_robust2( unsigned int*& a_i, float*& x_k, double bi, unsigned int num_intersections, double mean_chord_length, float*& x_update, unsigned int*& S, double*& norm_Ai )
{
	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	double a_i_dot_x_k = scalar_dot_product<double, float>( mean_chord_length, x_k, a_i, num_intersections );
	// (2) ( bi - <ai, x(k)> ) / <ai, ai>
	double scaled_residual = ( bi - a_i_dot_x_k ) /  (  pow(mean_chord_length, 2.0) * num_intersections );
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	for( unsigned int intersection = 0; intersection < num_intersections; intersection++)
	{
		x_update[a_i[intersection]] += update_value;
		S[a_i[intersection]] += 1;
		norm_Ai[a_i[intersection]] += pow( mean_chord_length, 2.0 );
	}
}
void DROP_update_robust2( float*& x_k, float*& x_update, unsigned int*& S, double*& norm_Ai )
{
	double psi_i;
	for( unsigned int voxel = 0; voxel < NUM_VOXELS; voxel++ )
	{
		if( S[voxel] > 0 )
		{
			psi_i = PSI_SIGN*(1-x_k[voxel])*ETA;
			//x_k[voxel] += x_update[voxel] / S[voxel];
			x_k[voxel] += ( norm_Ai[voxel]/ (norm_Ai[voxel] + psi_i))  * x_update[voxel] / S[voxel];		
			x_update[voxel] = 0;
			S[voxel] = 0;
		}
	}
}
void DROP_blocks3
( 
	unsigned int*& MLP, float*& x_k, double bi, unsigned int MLP_intersections, double mean_chord_length, 
	float*& x_update, unsigned int*& MLP_block, unsigned int& block_intersections
)
{
	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	double a_i_dot_x_k = scalar_dot_product<double, float>( mean_chord_length, x_k, MLP, MLP_intersections );
	// (2) ( bi - <ai, x(k)> ) / <ai, ai>
	double scaled_residual = ( bi - a_i_dot_x_k ) /  (  pow(mean_chord_length, 2.0) * MLP_intersections );
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	//for( unsigned int intersection = 0; intersection < num_voxel_scales; intersection++ )
	//{
	//	x_update[a_i[intersection]] += voxel_scales[intersection] * update_value;
	//	S[a_i[intersection]] += 1;
	//}
	//bool new_block_voxel = true;
	for( unsigned int MLP_intersection = 0; MLP_intersection < MLP_intersections; MLP_intersection++)
	{
		MLP_block[block_intersections] = MLP[MLP_intersection];
		x_update[MLP_block[block_intersections]] += update_value;
		//S[block_intersections] +=1;
		block_intersections++;
	}
}
void DROP_update3( float*& x_k, double*& x_update, unsigned int*& MLP_block, unsigned int& block_intersections )
{
	unsigned int count;
	for( unsigned int block_intersection = 0; block_intersection < block_intersections; block_intersection++ )
	{
		count = static_cast<unsigned int>(std::count(MLP_block, MLP_block + block_intersections, MLP_block[block_intersection] ));
		x_k[MLP_block[block_intersection]] += x_update[MLP_block[block_intersection]] / count;
		//x_update[block_intersection] = 0;
	}
	memset(x_update, 0, NUM_VOXELS );
	block_intersections = 0;
}
void DROP_blocks2
( 
	unsigned int*& MLP, float*& x_k, double bi, unsigned int MLP_intersections, double mean_chord_length, 
	float*& x_update, unsigned int*& MLP_block, unsigned int& block_intersections, unsigned int*& S 
)
{
	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	double a_i_dot_x_k = scalar_dot_product<double, float>( mean_chord_length, x_k, MLP, MLP_intersections );
	// (2) ( bi - <ai, x(k)> ) / <ai, ai>
	double scaled_residual = ( bi - a_i_dot_x_k ) /  (  pow(mean_chord_length, 2.0) * MLP_intersections );
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	//for( unsigned int intersection = 0; intersection < num_voxel_scales; intersection++ )
	//{
	//	x_update[a_i[intersection]] += voxel_scales[intersection] * update_value;
	//	S[a_i[intersection]] += 1;
	//}
	//bool new_block_voxel = true;
	for( unsigned int MLP_intersection = 0; MLP_intersection < MLP_intersections; MLP_intersection++)
	{
		//for( unsigned int block_intersection = 0; block_intersection < block_intersections; block_intersection++ )
		//{
			//if( MLP[MLP_intersection] == MLP_block[block_intersection] )
			unsigned int* ptr = std::find( MLP_block, MLP_block + block_intersections, MLP[MLP_intersection] );
			
			if( ptr == MLP_block + block_intersections )
			{
				MLP_block[block_intersections] = MLP[MLP_intersection];
				x_update[block_intersections] += update_value;
				S[block_intersections]++;
				block_intersections++;
			}
			else
			{
				x_update[*ptr] += update_value;
				S[*ptr] +=1;
			}
			//else
			//{
			//	x_update[block_intersection] += update_value;
			//	S[block_intersection] +=1;
			//}
		//}
	}
}
void DROP_update2( float*& x_k, float*& x_update, unsigned int*& MLP_block, unsigned int& block_intersections, unsigned int*& S )
{
	for( unsigned int block_intersection = 0; block_intersection < block_intersections; block_intersection++ )
	{
			x_k[MLP_block[block_intersection]] += x_update[block_intersection] / S[block_intersection];
			x_update[block_intersection] = 0;
			S[block_intersection] = 0;
	}
	block_intersections = 0;
}
void DROP_blocks_red( unsigned int*& a_i, float*& x_k, double bi, unsigned int num_intersections, double mean_chord_length, float*& x_update, unsigned int*& S )
{
	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	double a_i_dot_x_k = scalar_dot_product<double, float>( mean_chord_length, x_k, a_i, num_intersections );
	// (2) ( bi - <ai, x(k)> ) / <ai, ai>
	double a_i_dot_a_i =  pow(mean_chord_length, 2.0) * num_intersections;
	//double scaled_residual = ( bi - a_i_dot_x_k ) /  (  pow(mean_chord_length, 2.0) * num_intersections );
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	//double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	//for( unsigned int intersection = 0; intersection < num_voxel_scales; intersection++ )
	//{
	//	x_update[a_i[intersection]] += voxel_scales[intersection] * update_value;
	//	S[a_i[intersection]] += 1;
	//}
	double residual =  bi - a_i_dot_x_k;
	for( unsigned int intersection = 0; intersection < num_intersections; intersection++)
	{
	        double psi_i = ((1.0 - x_k[a_i[intersection]]) * ETA) * PSI_SIGN;
		
		double update_value = mean_chord_length * LAMBDA * (residual / (a_i_dot_a_i + psi_i)); 
		x_update[a_i[intersection]] += update_value;
		S[a_i[intersection]] += 1;
	}
}
void DROP_blocks( unsigned int*& a_i, float*& x_k, double bi, unsigned int num_intersections, double mean_chord_length, float*& x_update, unsigned int*& S )
{
	// x(K+1) = x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / <ai, ai> ] ai =  x(k) + LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ] ai 
	//  (1) <ai, x(k)>
	double a_i_dot_x_k = scalar_dot_product<double, float>( mean_chord_length, x_k, a_i, num_intersections );
	// (2) ( bi - <ai, x(k)> ) / <ai, ai>
	double scaled_residual = ( bi - a_i_dot_x_k ) /  (  pow(mean_chord_length, 2.0) * num_intersections );
	// (3) LAMBDA * [ ( bi - <ai, x(k)> ) / ||ai||^2 ]
	double update_value = mean_chord_length * LAMBDA * scaled_residual;	
	//for( unsigned int intersection = 0; intersection < num_voxel_scales; intersection++ )
	//{
	//	x_update[a_i[intersection]] += voxel_scales[intersection] * update_value;
	//	S[a_i[intersection]] += 1;
	//}
	for( unsigned int intersection = 0; intersection < num_intersections; intersection++)
	{
		
		x_update[a_i[intersection]] += update_value;
		S[a_i[intersection]]++;
	}
}
void DROP_update( float*& x_k, float*& x_update, unsigned int*& S )
{
	for( unsigned int voxel = 0; voxel < NUM_VOXELS; voxel++ )
	{
		if( S[voxel] > 0 )
		{
			x_k[voxel] += x_update[voxel] / S[voxel];
			x_update[voxel] = 0;
			S[voxel] = 0;
		}
	}
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************** Routines for Writing Data Arrays/Vectors to Disk ***********************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void binary_2_ASCII()
{
	count_histories();
	char filename[256];
	FILE* output_file;
	int start_file_num = 0, end_file_num = 0, histories_2_process = 0;
	while( start_file_num != NUM_FILES )
	{
		while( end_file_num < NUM_FILES )
		{
			if( histories_2_process + histories_per_file[end_file_num] < MAX_GPU_HISTORIES )
				histories_2_process += histories_per_file[end_file_num];
			else
				break;
			end_file_num++;
		}
		read_data_chunk( histories_2_process, start_file_num, end_file_num );
		sprintf( filename, "%s%s/%s%s%d%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, INPUT_DATA_BASENAME, "_", gantry_angle_h[0], ".txt" );
		output_file = fopen (filename, "w");

		for( unsigned int i = 0; i < histories_2_process; i++ )
		{
			fprintf(output_file, "%3f %3f %3f %3f %3f %3f %3f %3f %3f\n", t_in_1_h[i], t_in_2_h[i], t_out_1_h[i], t_out_2_h[i], v_in_1_h[i], v_in_2_h[i], v_out_1_h[i], v_out_2_h[i], WEPL_h[i]);
		}
		fclose (output_file);
		initial_processing_memory_clean();
		start_file_num = end_file_num;
		histories_2_process = 0;
	} 
}
template<typename T> void array_2_disk( const char* filename_base, const char* directory, const char* folder, T* data, const int x_max, const int y_max, const int z_max, const int elements, const bool single_file )
{
	char filename[256];
	std::ofstream output_file;
	int index;
	int num_files = z_max;
	int z_start = 0;
	int z_end = 1;
	if( single_file )
	{
		num_files = 1;
		z_end = z_max;
	}
	for( int file = 0; file < num_files; file++)
	{
		if( num_files == z_max )
			sprintf( filename, "%s%s/%s_%d.txt", directory, folder, filename_base, file );
		else
			sprintf( filename, "%s%s/%s.txt", directory, folder, filename_base );			
		output_file.open(filename);		
		for(int z = z_start; z < z_end; z++)
		{			
			for(int y = 0; y < y_max; y++)
			{
				for(int x = 0; x < x_max; x++)
				{
					index = x + ( y * x_max ) + ( z * x_max * y_max );
					if( index >= elements )
						break;
					output_file << data[index] << " ";
				}	
				if( index >= elements )
					break;
				output_file << std::endl;
			}
			if( index >= elements )
				break;
		}
		z_start += 1;
		z_end += 1;
		output_file.close();
	}
}
template<typename T> void vector_2_disk( const char* filename_base, const char* directory, const char* folder, std::vector<T> data, const int x_max, const int y_max, const int z_max, const bool single_file )
{
	char filename[256];
	std::ofstream output_file;
	int elements = data.size();
	int index;
	int num_files = z_max;
	int z_start = 0;
	int z_end = 1;
	if( single_file )
	{
		num_files = 1;
		z_end = z_max;
	}
	for( int file = 0; file < num_files; file++)
	{
		if( num_files == z_max )
			sprintf( filename, "%s%s/%s_%d.txt", directory, folder, filename_base, file );
		else
			sprintf( filename, "%s%s/%s.txt", directory, folder, filename_base );			
		output_file.open(filename);		
		for(int z = z_start; z < z_end; z++)
		{			
			for(int y = 0; y < y_max; y++)
			{
				for(int x = 0; x < x_max; x++)
				{
					index = x + ( y * x_max ) + ( z * x_max * y_max );
					if( index >= elements )
						break;
					output_file << data[index] << " ";
				}	
				if( index >= elements )
					break;
				output_file << std::endl;
			}
			if( index >= elements )
				break;
		}
		z_start += 1;
		z_end += 1;
		output_file.close();
	}
}
template<typename T> void t_bins_2_disk( FILE* output_file, const std::vector<int>& bin_numbers, const std::vector<T>& data, const BIN_ANALYSIS_TYPE type, const BIN_ORGANIZATION bin_order, int bin )
{
	const char* data_format = FLOAT_FORMAT;
	if( typeid(T) == typeid(int) )
		data_format = INT_FORMAT;
	if( typeid(T) == typeid(bool))
		data_format = BOOL_FORMAT;
	std::vector<T> bin_histories;
	unsigned int num_bin_members;
	for( int t_bin = 0; t_bin < T_BINS; t_bin++, bin++ )
	{
		if( bin_order == BY_HISTORY )
		{
			for( unsigned int i = 0; i < data.size(); i++ )
				if( bin_numbers[i] == bin )
					bin_histories.push_back(data[i]);
		}
		else
			bin_histories.push_back(data[bin]);
		num_bin_members = bin_histories.size();
		switch( type )
		{
			case COUNTS:	
				fprintf (output_file, "%d ", num_bin_members);																			
				break;
			case MEANS:		
				fprintf (output_file, "%f ", std::accumulate(bin_histories.begin(), bin_histories.end(), 0.0) / max(num_bin_members, 1 ) );
				break;
			case MEMBERS:	
				for( unsigned int i = 0; i < num_bin_members; i++ )
				{
					//fprintf (output_file, "%f ", bin_histories[i]); 
					fprintf (output_file, data_format, bin_histories[i]); 
					fputs(" ", output_file);
				}					 
				if( t_bin != T_BINS - 1 )
					fputs("\n", output_file);
		}
		bin_histories.resize(0);
		//bin_histories.shrink_to_fit();
	}
}
template<typename T> void bins_2_disk( const char* filename_base, const std::vector<int>& bin_numbers, const std::vector<T>& data, const BIN_ANALYSIS_TYPE type, const BIN_ANALYSIS_FOR which_bins, const BIN_ORGANIZATION bin_order, ... )
{
	//bins_2_disk( "WEPL_dist_pre_test2", empty_parameter, mean_WEPL_h, NUM_BINS, MEANS, ALL_BINS, BY_BIN );
	//bins_2_disk( "WEPL_dist_pre_test2", empty_parameter, sinogram_h, NUM_BINS, MEANS, ALL_BINS, BY_BIN );
	std::vector<int> angles;
	std::vector<int> angular_bins;
	std::vector<int> v_bins;
	if( which_bins == ALL_BINS )
	{
		angular_bins.resize( ANGULAR_BINS);
		v_bins.resize( V_BINS);
		//std::iota( angular_bins.begin(), angular_bins.end(), 0 );
		//std::iota( v_bins.begin(), v_bins.end(), 0 );
	}
	else
	{
		va_list specific_bins;
		va_start( specific_bins, bin_order );
		int num_angles = va_arg(specific_bins, int );
		int* angle_array = va_arg(specific_bins, int* );	
		angles.resize(num_angles);
		std::copy(angle_array, angle_array + num_angles, angles.begin() );

		int num_v_bins = va_arg(specific_bins, int );
		int* v_bins_array = va_arg(specific_bins, int* );	
		v_bins.resize(num_v_bins);
		std::copy(v_bins_array, v_bins_array + num_v_bins, v_bins.begin() );

		va_end(specific_bins);
		angular_bins.resize(angles.size());
		std::transform(angles.begin(), angles.end(), angular_bins.begin(), std::bind2nd(std::divides<int>(), GANTRY_ANGLE_INTERVAL ) );
	}
	
	int num_angles = (int) angular_bins.size();
	int num_v_bins = (int) v_bins.size();
	/*for( unsigned int i = 0; i < 3; i++ )
		printf("%d\n", angles[i] );
	for( unsigned int i = 0; i < 3; i++ )
		printf("%d\n", angular_bins[i] );
	for( unsigned int i = 0; i < 3; i++ )
		printf("%d\n", v_bins[i] );*/
	char filename[256];
	int start_bin, angle;
	FILE* output_file;

	for( int angular_bin = 0; angular_bin < num_angles; angular_bin++)
	{
		angle = angular_bins[angular_bin] * GANTRY_ANGLE_INTERVAL;
		//printf("angle = %d\n", angular_bins[angular_bin]);
		sprintf( filename, "%s%s/%s_%03d%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, filename_base, angle, ".txt" );
		output_file = fopen (filename, "w");
		for( int v_bin = 0; v_bin < num_v_bins; v_bin++)
		{			
			//printf("v bin = %d\n", v_bins[v_bin]);
			start_bin = angular_bins[angular_bin] * T_BINS + v_bins[v_bin] * ANGULAR_BINS * T_BINS;
			t_bins_2_disk( output_file, bin_numbers, data, type, bin_order, start_bin );
			if( v_bin != num_v_bins - 1 )
				fputs("\n", output_file);
		}	
		fclose (output_file);
	}
}
template<typename T> void t_bins_2_disk( FILE* output_file, int*& bin_numbers, T*& data, const unsigned int data_elements, const BIN_ANALYSIS_TYPE type, const BIN_ORGANIZATION bin_order, int bin )
{
	const char* data_format = FLOAT_FORMAT;
	if( typeid(T) == typeid(int) )
		data_format = INT_FORMAT;
	if( typeid(T) == typeid(bool))
		data_format = BOOL_FORMAT;

	std::vector<T> bin_histories;
	//int data_elements = sizeof(data)/sizeof(float);
	unsigned int num_bin_members;
	for( int t_bin = 0; t_bin < T_BINS; t_bin++, bin++ )
	{
		if( bin_order == BY_HISTORY )
		{
			for( unsigned int i = 0; i < data_elements; i++ )
				if( bin_numbers[i] == bin )
					bin_histories.push_back(data[i]);
		}
		else
			bin_histories.push_back(data[bin]);
		num_bin_members = (unsigned int) bin_histories.size();
		switch( type )
		{
			case COUNTS:	
				fprintf (output_file, "%d ", num_bin_members);																			
				break;
			case MEANS:		
				fprintf (output_file, "%f ", std::accumulate(bin_histories.begin(), bin_histories.end(), 0.0) / max(num_bin_members, 1 ) );
				break;
			case MEMBERS:	
				for( unsigned int i = 0; i < num_bin_members; i++ )
				{
					//fprintf (output_file, "%f ", bin_histories[i]); 
					fprintf (output_file, data_format, bin_histories[i]); 
					fputs(" ", output_file);
				}
				if( t_bin != T_BINS - 1 )
					fputs("\n", output_file);
		}
		bin_histories.resize(0);
		//bin_histories.shrink_to_fit();
	}
}
template<typename T>  void bins_2_disk( const char* filename_base, int*& bin_numbers, T*& data, const int data_elements, const BIN_ANALYSIS_TYPE type, const BIN_ANALYSIS_FOR which_bins, const BIN_ORGANIZATION bin_order, ... )
{
	std::vector<int> angles;
	std::vector<int> angular_bins;
	std::vector<int> v_bins;
	if( which_bins == ALL_BINS )
	{
		angular_bins.resize( ANGULAR_BINS);
		v_bins.resize( V_BINS);
		//std::iota( angular_bins.begin(), angular_bins.end(), 0 );
		//std::iota( v_bins.begin(), v_bins.end(), 0 );
	}
	else
	{
		va_list specific_bins;
		va_start( specific_bins, bin_order );
		int num_angles = va_arg(specific_bins, int );
		int* angle_array = va_arg(specific_bins, int* );	
		angles.resize(num_angles);
		std::copy(angle_array, angle_array + num_angles, angles.begin() );

		int num_v_bins = va_arg(specific_bins, int );
		int* v_bins_array = va_arg(specific_bins, int* );	
		v_bins.resize(num_v_bins);
		std::copy(v_bins_array, v_bins_array + num_v_bins, v_bins.begin() );

		va_end(specific_bins);
		angular_bins.resize(angles.size());
		std::transform(angles.begin(), angles.end(), angular_bins.begin(), std::bind2nd(std::divides<int>(), GANTRY_ANGLE_INTERVAL ) );
	}
	//int data_elements = sizeof(data)/sizeof(float);
	//std::cout << std::endl << data_elements << std::endl << std::endl;
	int num_angles = (int) angular_bins.size();
	int num_v_bins = (int) v_bins.size();
	/*for( unsigned int i = 0; i < 3; i++ )
		printf("%d\n", angles[i] );
	for( unsigned int i = 0; i < 3; i++ )
		printf("%d\n", angular_bins[i] );
	for( unsigned int i = 0; i < 3; i++ )
		printf("%d\n", v_bins[i] );*/
	char filename[256];
	int start_bin, angle;
	FILE* output_file;

	for( int angular_bin = 0; angular_bin < num_angles; angular_bin++)
	{
		angle = angular_bins[angular_bin] * (int) GANTRY_ANGLE_INTERVAL;
		//printf("angle = %d\n", angular_bins[angular_bin]);
		sprintf( filename, "%s%s/%s_%03d%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, filename_base, angle, ".txt" );
		output_file = fopen (filename, "w");
		for( int v_bin = 0; v_bin < num_v_bins; v_bin++)
		{			
			//printf("v bin = %d\n", v_bins[v_bin]);
			start_bin = angular_bins[angular_bin] * T_BINS + v_bins[v_bin] * ANGULAR_BINS * T_BINS;
			t_bins_2_disk( output_file, bin_numbers, data, data_elements, type, bin_order, start_bin );
			if( v_bin != num_v_bins - 1 )
				fputs("\n", output_file);
		}	
		fclose (output_file);
	}
}
FILE* create_MLP_file( char* data_filename )
{
	FILE * pFile;
	//char data_filename[256];
	//sprintf(data_filename, "%s%s/%s.txt", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_PATH_FILENAME );
	pFile = fopen (data_filename,"w+");
	return pFile;
}
template<typename T> void MLP_data_2_disk(const char* data_filename, FILE* pFile, unsigned int S, unsigned int* voxel_numbers, T*& data, bool write_sparse)
{
	// Writes either voxel intersection numbers or chord lengths in either dense or sparse format
	T data_value;	
	const char* data_format = FLOAT_FORMAT;
	if( typeid(T) == typeid(int) )
		data_format = INT_FORMAT;
	if( typeid(T) == typeid(bool))
		data_format = BOOL_FORMAT;
	freopen (data_filename,"a+", pFile);
	//pFile = freopen (data_filename,"a+", pFile);
	if( write_sparse )
	{
		for( unsigned int intersection_num = 0; intersection_num < S; intersection_num++ )
		{
			fprintf (pFile, data_format, data[intersection_num]);	
			fputs(" ", pFile);
		}
	}
	else
	{
		bool intersected = false;
		
		for( int voxel = 0; voxel < NUM_VOXELS; voxel++)
		{
			for( unsigned int i = 0; i < S; i++ )
			{
				if( voxel_numbers[i] == voxel )
				{
					data_value = data[i];
					intersected = true;
				}
			}
			if( typeid(T) == typeid(int) || typeid(T) == typeid(bool) )
				fprintf (pFile, data_format, intersected);
			else
				fprintf (pFile, data_format, data_value);
			if( voxel != NUM_VOXELS - 1 )
				fputc(' ', pFile);
			intersected = false;
			data_value = 0;
		}
	}
	fputc ('\n',pFile);
	fclose (pFile);
}
void execution_times_2_txt()
{
	char ENDPOINTS_TX_MODE_STRING[32];
	char ENDPOINTS_ALG_STRING[32];
	char DROP_TX_MODE_STRING[32];
	char MLP_ALGORITHM_STRING[32];
	//char statement[256];
	switch( ENDPOINTS_TX_MODE )
	{
		case FULL_TX:					sprintf(ENDPOINTS_TX_MODE_STRING, "%s", FULL_TX_STRING);						break;
		case PARTIAL_TX:				sprintf(ENDPOINTS_TX_MODE_STRING, "%s", PARTIAL_TX_STRING);						break;
		case PARTIAL_TX_PREALLOCATED:	sprintf(ENDPOINTS_TX_MODE_STRING, "%s", PARTIAL_TX_PRE_STRING);		break;		
	}
	switch( DROP_TX_MODE )
	{
		case FULL_TX:					sprintf(DROP_TX_MODE_STRING, "%s", FULL_TX_STRING);						break;
		case PARTIAL_TX:				sprintf(DROP_TX_MODE_STRING, "%s", PARTIAL_TX_STRING);						break;
		case PARTIAL_TX_PREALLOCATED:	sprintf(DROP_TX_MODE_STRING, "%s", PARTIAL_TX_PRE_STRING);		break;
	}
	switch( ENDPOINTS_ALG )
	{
		case USE_BOOL_ARRAY:		sprintf(ENDPOINTS_ALG_STRING, "%s", BOOL_ARRAY_STRING);					break;
		case NO_BOOL_ARRAY:	sprintf(ENDPOINTS_ALG_STRING, "%s", NO_BOOL_ARRAY_STRING);				break;
	}
	switch( MLP_ALGORITHM )
	{
		case TABULATED:		sprintf(MLP_ALGORITHM_STRING, "%s", TABULATED_STRING);			break;
		case STANDARD:		sprintf(MLP_ALGORITHM_STRING, "%s", STANDARD_STRING);			break;
	}

	int i = 0;
	char execution_times_path[256];
	//char execution_date[9];
	//current_MMDDYYYY( EXECUTION_DATE);
	//sprintf(execution_times_path, "%s//%s.txt", OUTPUT_DIRECTORY, EXECUTION_TIMES_BASENAME);
	sprintf(execution_times_path, "%s%s//%s.txt", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, EXECUTION_TIMES_BASENAME);
	
	sprintf(print_statement, "Local testing results written to .txt at:");
	print_colored_text(print_statement, LIGHT, CYAN );
	
	sprintf(print_statement, "Local testing results written to .txt at:");
	print_colored_text(execution_times_path, DARK, GREEN );
	
	
	FILE* execution_times_file = fopen( execution_times_path, "w" );
	fprintf(execution_times_file, "execution_date = %s\n",				EXECUTION_DATE						);	// 1
	fprintf(execution_times_file, "Executed By Blake Schultze, "										);	// 2
	fprintf(execution_times_file, "INPUT_DIRECTORY = %s\n",				INPUT_DIRECTORY						);	// 3
	fprintf(execution_times_file, "INPUT_FROM = %s\n",				INPUT_FROM						);	// 4
	fprintf(execution_times_file, "OUTPUT_DIRECTORY = %s\n",				OUTPUT_DIRECTORY					);	// 5
	fprintf(execution_times_file, "OUTPUT_TO_UNIQUE = %s\n",				OUTPUT_TO_UNIQUE						);	// 6
	fprintf(execution_times_file, "execution_time_data_reads = %6.6lf\n",			execution_time_data_reads			);	// 7
	fprintf(execution_times_file, "execution_time_preprocessing = %6.6lf\n",			execution_time_preprocessing		);	// 8
	fprintf(execution_times_file, "execution_time_endpoints = %6.6lf\n",			execution_time_endpoints			);	// 9
	fprintf(execution_times_file, "execution_time_tables = %6.6lf\n",			execution_time_tables				);	// 10
	fprintf(execution_times_file, "execution_time_init_image = %6.6lf\n",			execution_time_init_image			);	// 11
	fprintf(execution_times_file, "execution_time_DROP = %6.6lf\n",			execution_time_DROP					);	// 12
	for( i = 0; i < execution_times_DROP_iterations.size(); i++ )
		fprintf(execution_times_file, "execution_times_DROP_iterations %d = %6.6lf\n", i,	execution_times_DROP_iterations[i]	);	// 13-24																									
	fprintf(execution_times_file, "execution_time_reconstruction = %6.6lf\n",			execution_time_reconstruction		);	// 25
	fprintf(execution_times_file, "execution_time_program = %6.6lf\n",			execution_time_program				);	// 26

	fprintf(execution_times_file, "THREADS_PER_BLOCK = %d\n",				THREADS_PER_BLOCK					);	// 27
	fprintf(execution_times_file, "ENDPOINTS_TX_MODE_STRING = %s\n",				ENDPOINTS_TX_MODE_STRING			);	// 28
	fprintf(execution_times_file, "ENDPOINTS_ALG_STRING = %s\n",				ENDPOINTS_ALG_STRING				);	// 29
	fprintf(execution_times_file, "MAX_ENDPOINTS_HISTORIES = %d\n",				MAX_ENDPOINTS_HISTORIES				);	// 30
	fprintf(execution_times_file, "ENDPOINTS_PER_BLOCK = %d\n",				ENDPOINTS_PER_BLOCK					);	// 31
	fprintf(execution_times_file, "ENDPOINTS_PER_THREAD = %d\n",				ENDPOINTS_PER_THREAD				);	// 32
	fprintf(execution_times_file, "DROP_TX_MODE_STRING = %s\n",				DROP_TX_MODE_STRING					);	// 33
	fprintf(execution_times_file, "MLP_ALGORITHM_STRING = %s\n",				MLP_ALGORITHM_STRING				);	// 34
	fprintf(execution_times_file, "HISTORIES_PER_BLOCK = %d\n",				HISTORIES_PER_BLOCK					);	// 35
	fprintf(execution_times_file, "HISTORIES_PER_THREAD = %d\n",				HISTORIES_PER_THREAD				);	// 36
	fprintf(execution_times_file, "VOXELS_PER_THREAD = %d\n",				VOXELS_PER_THREAD					);	// 37
	fprintf(execution_times_file, "LAMBDA = %6.6lf\n",			LAMBDA								);	// 38
	fprintf(execution_times_file, "DROP_BLOCK_SIZE = %d\n",				DROP_BLOCK_SIZE						);	// 39
	fprintf(execution_times_file, "TRIG_TABLE_MIN = %6.6lf\n",			TRIG_TABLE_MIN						);	// 40
	fprintf(execution_times_file, "TRIG_TABLE_MAX = %6.6lf\n",			TRIG_TABLE_MAX						);	// 41
	fprintf(execution_times_file, "TRIG_TABLE_STEP = %6.6lf\n",			TRIG_TABLE_STEP						);	// 42
	fprintf(execution_times_file, "COEFF_TABLE_RANGE = %6.6lf\n",			COEFF_TABLE_RANGE					);	// 43
	fprintf(execution_times_file, "COEFF_TABLE_STEP = %6.6lf\n",			COEFF_TABLE_STEP					);	// 44
	fprintf(execution_times_file, "POLY_TABLE_RANGE = %6.6lf\n",			POLY_TABLE_RANGE					);	// 45
	fprintf(execution_times_file, "POLY_TABLE_STEP = %6.6lf\n",			POLY_TABLE_STEP						);	// 46
	fprintf(execution_times_file, "\n",					POLY_TABLE_STEP						);	// end line, go to beginning of next entry

	fclose(execution_times_file);
	//Execution Date	Executed By	INPUT_DIRECTORY	INPUT_FROM	OUTPUT_DIRECTORY	OUTPUT_TO_UNIQUE	preprocessing	endpoints	tables	init_image	DROP_total	iteration 1	iteration 2	iteration 3	iteration 4	iteration 5	iteration 6	iteration 7	iteration 8	iteration 9	iteration 10	iteration 11	iteration 12	reconstruction	program	THREADS_PER_BLOCK	ENDPOINTS_TX_MODE	ENDPOINTS_ALG	MAX_ENDPOINTS_HISTORIES	ENDPOINTS_PER_BLOCK	ENDPOINTS_PER_THREAD	DROP_TX_MODE	MLP_ALGORITHM	HISTORIES_PER_BLOCK	HISTORIES_PER_THREAD	VOXELS_PER_THREAD	LAMBDA	DROP_BLOCK_SIZE	TRIG_TABLE_MIN	TRIG_TABLE_MAX	TRIG_TABLE_STEP	COEFF_TABLE_RANGE	COEFF_TABLE_STEP	POLY_TABLE_RANGE	POLY_TABLE_STEP
}
void execution_times_2_csv()
{
	char ENDPOINTS_TX_MODE_STRING[32];
	char ENDPOINTS_ALG_STRING[32];
	char DROP_TX_MODE_STRING[32];
	char MLP_ALGORITHM_STRING[32];
	//char statement[256];
	
	switch( ENDPOINTS_TX_MODE )
	{
		case FULL_TX:					sprintf(ENDPOINTS_TX_MODE_STRING, "%s", FULL_TX_STRING);						break;
		case PARTIAL_TX:				sprintf(ENDPOINTS_TX_MODE_STRING, "%s", PARTIAL_TX_STRING);						break;
		case PARTIAL_TX_PREALLOCATED:	sprintf(ENDPOINTS_TX_MODE_STRING, "%s", PARTIAL_TX_PRE_STRING);		break;		
	}
	switch( DROP_TX_MODE )
	{
		case FULL_TX:					sprintf(DROP_TX_MODE_STRING, "%s", FULL_TX_STRING);								break;
		case PARTIAL_TX:				sprintf(DROP_TX_MODE_STRING, "%s", PARTIAL_TX_STRING);							break;
		case PARTIAL_TX_PREALLOCATED:	sprintf(DROP_TX_MODE_STRING, "%s", PARTIAL_TX_PRE_STRING);				break;
	}
	switch( ENDPOINTS_ALG )
	{
		case USE_BOOL_ARRAY:			sprintf(ENDPOINTS_ALG_STRING, "%s", BOOL_ARRAY_STRING);							break;
		case NO_BOOL_ARRAY:				sprintf(ENDPOINTS_ALG_STRING, "%s", NO_BOOL_ARRAY_STRING);						break;
	}
	switch( MLP_ALGORITHM )
	{
		case TABULATED:					sprintf(MLP_ALGORITHM_STRING, "%s", TABULATED_STRING);							break;
		case STANDARD:					sprintf(MLP_ALGORITHM_STRING, "%s", STANDARD_STRING);							break;
	}

	int i = 0;
	char execution_times_path[256];
	//char execution_date[9];
	//current_MMDDYYYY( EXECUTION_DATE);
	sprintf(execution_times_path, "%s//%s.csv", OUTPUT_DIRECTORY, EXECUTION_TIMES_BASENAME);
	if( !file_exists (execution_times_path))
		init_execution_times_csv();
	//sprintf(execution_times_path, "%s%s//%s.csv", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, EXECUTION_TIMES_BASENAME);
	
	sprintf(print_statement, "Global testing results written to .txt at:");
	print_colored_text(print_statement, LIGHT, CYAN );
	
	sprintf(print_statement, "Local testing results written to .txt at:");
	print_colored_text(execution_times_path, DARK, GREEN );
		
	FILE* execution_times_file = fopen( execution_times_path, "a+" );
	fprintf(execution_times_file, "%s, ",				EXECUTION_DATE						);	// 1
	fprintf(execution_times_file, "%s, ",				TESTED_BY_STRING						);	// 2
	fprintf(execution_times_file, "%s, ",				INPUT_DIRECTORY						);	// 3
	fprintf(execution_times_file, "%s, ",				INPUT_FROM						);	// 4
	fprintf(execution_times_file, "%s, ",				OUTPUT_DIRECTORY					);	// 5
	fprintf(execution_times_file, "%s, ",				OUTPUT_TO_UNIQUE						);	// 6
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_data_reads			);	// 7
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_preprocessing		);	// 8
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_endpoints			);	// 9
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_tables				);	// 10
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_init_image			);	// 11
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_DROP					);	// 12
	for( i = 0; i < execution_times_DROP_iterations.size(); i++ )
		fprintf(execution_times_file, " %6.6lf, ", execution_times_DROP_iterations[i]	);	// 13-24
	for( ; i < MAX_ITERATIONS; i++ )
		fprintf(execution_times_file, ", ");													
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_reconstruction		);	// 25
	fprintf(execution_times_file, "%6.6lf, ",			execution_time_program				);	// 26

	fprintf(execution_times_file, "%d, ",				THREADS_PER_BLOCK					);	// 27
	fprintf(execution_times_file, "%s, ",				ENDPOINTS_TX_MODE_STRING			);	// 28
	fprintf(execution_times_file, "%s, ",				ENDPOINTS_ALG_STRING				);	// 29
	fprintf(execution_times_file, "%d, ",				MAX_ENDPOINTS_HISTORIES				);	// 30
	fprintf(execution_times_file, "%d, ",				ENDPOINTS_PER_BLOCK					);	// 31
	fprintf(execution_times_file, "%d, ",				ENDPOINTS_PER_THREAD				);	// 32
	fprintf(execution_times_file, "%s, ",				DROP_TX_MODE_STRING					);	// 33
	fprintf(execution_times_file, "%s, ",				MLP_ALGORITHM_STRING				);	// 34
	fprintf(execution_times_file, "%d, ",				HISTORIES_PER_BLOCK					);	// 35
	fprintf(execution_times_file, "%d, ",				HISTORIES_PER_THREAD				);	// 36
	fprintf(execution_times_file, "%d, ",				VOXELS_PER_THREAD					);	// 37
	fprintf(execution_times_file, "%6.6lf, ",			LAMBDA								);	// 38
	fprintf(execution_times_file, "%d, ",				DROP_BLOCK_SIZE						);	// 39
	fprintf(execution_times_file, "%6.6lf, ",			TRIG_TABLE_MIN						);	// 40
	fprintf(execution_times_file, "%6.6lf, ",			TRIG_TABLE_MAX						);	// 41
	fprintf(execution_times_file, "%6.6lf, ",			TRIG_TABLE_STEP						);	// 42
	fprintf(execution_times_file, "%6.6lf, ",			COEFF_TABLE_RANGE					);	// 43
	fprintf(execution_times_file, "%6.6lf, ",			COEFF_TABLE_STEP					);	// 44
	fprintf(execution_times_file, "%6.6lf, ",			POLY_TABLE_RANGE					);	// 45
	fprintf(execution_times_file, "%6.6lf, ",			POLY_TABLE_STEP						);	// 46
	fprintf(execution_times_file, "\n",					POLY_TABLE_STEP						);	// end line, go to beginning of next entry

	fclose(execution_times_file);
	//Execution Date	Executed By	INPUT_DIRECTORY	INPUT_FROM	OUTPUT_DIRECTORY	OUTPUT_TO_UNIQUE	preprocessing	endpoints	tables	init_image	DROP_total	iteration 1	iteration 2	iteration 3	iteration 4	iteration 5	iteration 6	iteration 7	iteration 8	iteration 9	iteration 10	iteration 11	iteration 12	reconstruction	program	THREADS_PER_BLOCK	ENDPOINTS_TX_MODE	ENDPOINTS_ALG	MAX_ENDPOINTS_HISTORIES	ENDPOINTS_PER_BLOCK	ENDPOINTS_PER_THREAD	DROP_TX_MODE	MLP_ALGORITHM	HISTORIES_PER_BLOCK	HISTORIES_PER_THREAD	VOXELS_PER_THREAD	LAMBDA	DROP_BLOCK_SIZE	TRIG_TABLE_MIN	TRIG_TABLE_MAX	TRIG_TABLE_STEP	COEFF_TABLE_RANGE	COEFF_TABLE_STEP	POLY_TABLE_RANGE	POLY_TABLE_STEP
}
void init_execution_times_csv()
{
	char execution_times_path[256];
	//char statement[256];
	//char execution_date[9];
	//current_MMDDYYYY( EXECUTION_DATE);
	//fprintf( Execution Date	Executed By	INPUT_DIRECTORY	INPUT_FROM	OUTPUT_DIRECTORY	OUTPUT_TO_UNIQUE	THREADS_PER_BLOCK	ENDPOINTS_TX_MODE	ENDPOINTS_ALG	MAX_ENDPOINTS_HISTORIES	ENDPOINTS_PER_BLOCK	ENDPOINTS_PER_THREAD	DROP_TX_MODE	MLP_ALGORITHM	HISTORIES_PER_BLOCK	HISTORIES_PER_THREAD	VOXELS_PER_THREAD	LAMBDA	DROP_BLOCK_SIZE	TRIG_TABLE_MIN	TRIG_TABLE_MAX	TRIG_TABLE_STEP	COEFF_TABLE_RANGE	COEFF_TABLE_STEP	POLY_TABLE_RANGE	POLY_TABLE_STEP
	//Execution Date		INPUT_DIRECTORY	INPUT_FROM	OUTPUT_DIRECTORY	OUTPUT_TO_UNIQUE	preprocessing	endpoints	tables	init_image	DROP_total	iteration 1	iteration 2	iteration 3	iteration 4	iteration 5	iteration 6	iteration 7	iteration 8	iteration 9	iteration 10	iteration 11	iteration 12	reconstruction	program	THREADS_PER_BLOCK	ENDPOINTS_TX_MODE	ENDPOINTS_ALG	MAX_ENDPOINTS_HISTORIES	ENDPOINTS_PER_BLOCK	ENDPOINTS_PER_THREAD	DROP_TX_MODE	MLP_ALGORITHM	HISTORIES_PER_BLOCK	HISTORIES_PER_THREAD	VOXELS_PER_THREAD	LAMBDA	DROP_BLOCK_SIZE	TRIG_TABLE_MIN	TRIG_TABLE_MAX	TRIG_TABLE_STEP	COEFF_TABLE_RANGE	COEFF_TABLE_STEP	POLY_TABLE_RANGE	POLY_TABLE_STEP
	//													
	sprintf(execution_times_path, "%s//%s.csv", OUTPUT_DIRECTORY, EXECUTION_TIMES_BASENAME);
	//sprintf(execution_times_path, "%s%s//%s.csv", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, EXECUTION_TIMES_BASENAME);
	sprintf(print_statement, "Testing results .csv initialized and written to:");
	print_colored_text(print_statement, LIGHT, CYAN );
	
	sprintf(print_statement, "Local testing results written to .txt at:");
	print_colored_text(execution_times_path, DARK, GREEN );

	FILE* execution_times_file = fopen( execution_times_path, "w" );
	fprintf(execution_times_file, "Execution Date, "			);	// 1
	fprintf(execution_times_file, "Executed By, "				);	// 2
	fprintf(execution_times_file, "INPUT_DIRECTORY, "			);	// 3
	fprintf(execution_times_file, "INPUT_FROM, "				);	// 4
	fprintf(execution_times_file, "OUTPUT_DIRECTORY, "			);	// 5
	fprintf(execution_times_file, "OUTPUT_TO_UNIQUE, "				);	// 6
	fprintf(execution_times_file, "data reads, "				);	// 7
	fprintf(execution_times_file, "preprocessing, "				);	// 8
	fprintf(execution_times_file, "endpoints, "					);	// 9
	fprintf(execution_times_file, "tables, "					);	// 10
	fprintf(execution_times_file, "init_image, "				);	// 11
	fprintf(execution_times_file, "DROP_total, "				);	// 12
	for( int i = 1; i <= MAX_ITERATIONS; i++ )
		fprintf(execution_times_file, " iteration %d, ", i		);	// 13-24													
	fprintf(execution_times_file, "reconstruction, "			);	// 25
	fprintf(execution_times_file, "program, "					);	// 26

	fprintf(execution_times_file, "THREADS_PER_BLOCK, "			);	// 27
	fprintf(execution_times_file, "ENDPOINTS_TX_MODE, "			);	// 28
	fprintf(execution_times_file, "ENDPOINTS_ALG, "				);	// 29
	fprintf(execution_times_file, "MAX_ENDPOINTS_HISTORIES, "	);	// 30
	fprintf(execution_times_file, "ENDPOINTS_PER_BLOCK, "		);	// 31
	fprintf(execution_times_file, "ENDPOINTS_PER_THREAD, "		);	// 32
	fprintf(execution_times_file, "DROP_TX_MODE, "				);	// 33
	fprintf(execution_times_file, "MLP_ALGORITHM, "				);	// 34
	fprintf(execution_times_file, "HISTORIES_PER_BLOCK, "		);	// 35
	fprintf(execution_times_file, "HISTORIES_PER_THREAD, "		);	// 36
	fprintf(execution_times_file, "VOXELS_PER_THREAD, "			);	// 37
	fprintf(execution_times_file, "LAMBDA, "					);	// 38
	fprintf(execution_times_file, "DROP_BLOCK_SIZE, "			);	// 39
	fprintf(execution_times_file, "TRIG_TABLE_MIN, "			);	// 40
	fprintf(execution_times_file, "TRIG_TABLE_MAX, "			);	// 41
	fprintf(execution_times_file, "TRIG_TABLE_STEP, "			);	// 42
	fprintf(execution_times_file, "COEFF_TABLE_RANGE, "			);	// 43
	fprintf(execution_times_file, "COEFF_TABLE_STEP, "			);	// 44
	fprintf(execution_times_file, "POLY_TABLE_RANGE, "			);	// 45
	fprintf(execution_times_file, "POLY_TABLE_STEP, "			);	// 46
	fprintf(execution_times_file, "\n"							);	// end line, go to beginning of next entry

	fclose(execution_times_file);
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************* Image Position/Voxel Calculation Functions (Host) ***********************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
int calculate_voxel( double zero_coordinate, double current_position, double voxel_size )
{
	return static_cast<int>(abs( current_position - zero_coordinate ) / voxel_size);
}
int positions_2_voxels(const double x, const double y, const double z, int& voxel_x, int& voxel_y, int& voxel_z )
{
	voxel_x = static_cast<int>( ( x - X_ZERO_COORDINATE ) / VOXEL_WIDTH );				
	voxel_y = static_cast<int>( ( Y_ZERO_COORDINATE - y ) / VOXEL_HEIGHT );
	voxel_z = static_cast<int>( ( Z_ZERO_COORDINATE - z ) / VOXEL_THICKNESS );
	return voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
}
int position_2_voxel( double x, double y, double z )
{
	int voxel_x = static_cast<int>( ( x - X_ZERO_COORDINATE ) / VOXEL_WIDTH );
	int voxel_y = static_cast<int>( ( Y_ZERO_COORDINATE - y ) / VOXEL_HEIGHT );
	int voxel_z = static_cast<int>( ( Z_ZERO_COORDINATE - z ) / VOXEL_THICKNESS );
	return voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
}
void voxel_2_3D_voxels( int voxel, int& voxel_x, int& voxel_y, int& voxel_z )
{
	voxel_x = 0;
    voxel_y = 0;
    voxel_z = 0;
    
    while( voxel - COLUMNS * ROWS >= 0 )
	{
		voxel -= COLUMNS * ROWS;
		voxel_z++;
	}
	// => bin = t_bin + angular_bin * T_BINS > 0
	while( voxel - COLUMNS >= 0 )
	{
		voxel -= COLUMNS;
		voxel_y++;
	}
	// => bin = t_bin > 0
	voxel_x = voxel;
}
double voxel_2_position( int voxel_i, double voxel_i_size, int num_voxels_i, int coordinate_progression )
{
	// voxel_i = 50, num_voxels_i = 200, middle_voxel = 100, ( 50 - 100 ) * 1 = -50
	double zero_voxel = ( num_voxels_i - 1) / 2.0;
	return coordinate_progression * ( voxel_i - zero_voxel ) * voxel_i_size;
}
void voxel_2_positions( int voxel, double& x, double& y, double& z )
{
	int voxel_x, voxel_y, voxel_z;
	voxel_2_3D_voxels( voxel, voxel_x, voxel_y, voxel_z );
	x = voxel_2_position( voxel_x, VOXEL_WIDTH, COLUMNS, 1 );
	y = voxel_2_position( voxel_y, VOXEL_HEIGHT, ROWS, -1 );
	z = voxel_2_position( voxel_z, VOXEL_THICKNESS, SLICES, -1 );
}
double voxel_2_radius_squared( int voxel )
{
	int voxel_x, voxel_y, voxel_z;
	voxel_2_3D_voxels( voxel, voxel_x, voxel_y, voxel_z );
	double x = voxel_2_position( voxel_x, VOXEL_WIDTH, COLUMNS, 1 );
	double y = voxel_2_position( voxel_y, VOXEL_HEIGHT, ROWS, -1 );
	return pow( x, 2.0 ) + pow( y, 2.0 );
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************* Image Position/Voxel Calculation Functions (Device) *********************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
__device__ int calculate_voxel_GPU( double zero_coordinate, double current_position, double voxel_size )
{
	return abs( current_position - zero_coordinate ) / voxel_size;
}
__device__ int positions_2_voxels_GPU(const double x, const double y, const double z, int& voxel_x, int& voxel_y, int& voxel_z )
{
	voxel_x = static_cast<int>( ( x - X_ZERO_COORDINATE ) / VOXEL_WIDTH );				
	voxel_y = static_cast<int>( ( Y_ZERO_COORDINATE - y ) / VOXEL_HEIGHT );
	voxel_z = static_cast<int>( ( Z_ZERO_COORDINATE - z ) / VOXEL_THICKNESS );
	return voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
}
__device__ int position_2_voxel_GPU( double x, double y, double z )
{
	int voxel_x = static_cast<int>( ( x - X_ZERO_COORDINATE ) / VOXEL_WIDTH );
	int voxel_y = static_cast<int>( ( Y_ZERO_COORDINATE - y ) / VOXEL_HEIGHT );
	int voxel_z = static_cast<int>( ( Z_ZERO_COORDINATE - z ) / VOXEL_THICKNESS );
	return voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
}
__device__ void voxel_2_3D_voxels_GPU( int voxel, int& voxel_x, int& voxel_y, int& voxel_z )
{
	voxel_x = 0;
    voxel_y = 0;
    voxel_z = 0;
    
    while( voxel - COLUMNS * ROWS >= 0 )
	{
		voxel -= COLUMNS * ROWS;
		voxel_z++;
	}
	// => bin = t_bin + angular_bin * T_BINS > 0
	while( voxel - COLUMNS >= 0 )
	{
		voxel -= COLUMNS;
		voxel_y++;
	}
	// => bin = t_bin > 0
	voxel_x = voxel;
}
__device__ double voxel_2_position_GPU( int voxel_i, double voxel_i_size, int num_voxels_i, int coordinate_progression )
{
	// voxel_i = 50, num_voxels_i = 200, middle_voxel = 100, ( 50 - 100 ) * 1 = -50
	double zero_voxel = ( num_voxels_i - 1) / 2.0;
	return coordinate_progression * ( voxel_i - zero_voxel ) * voxel_i_size;
}
__device__ void voxel_2_positions_GPU( int voxel, double& x, double& y, double& z )
{
	int voxel_x, voxel_y, voxel_z;
	voxel_2_3D_voxels_GPU( voxel, voxel_x, voxel_y, voxel_z );
	x = voxel_2_position_GPU( voxel_x, VOXEL_WIDTH, COLUMNS, 1 );
	y = voxel_2_position_GPU( voxel_y, VOXEL_HEIGHT, ROWS, -1 );
	z = voxel_2_position_GPU( voxel_z, VOXEL_THICKNESS, SLICES, -1 );
}
__device__ double voxel_2_radius_squared_GPU( int voxel )
{
	int voxel_x, voxel_y, voxel_z;
	voxel_2_3D_voxels_GPU( voxel, voxel_x, voxel_y, voxel_z );
	double x = voxel_2_position_GPU( voxel_x, VOXEL_WIDTH, COLUMNS, 1 );
	double y = voxel_2_position_GPU( voxel_y, VOXEL_HEIGHT, ROWS, -1 );
	return pow( x, 2.0 ) + pow( y, 2.0 );
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************************** Voxel Walk Functions (Host) ********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
double distance_remaining( double zero_coordinate, double current_position, int increasing_direction, int step_direction, double voxel_size, int current_voxel )
{
	/* Determine distance from current position to the next voxel edge.  path_projection is used to determine next intersected voxel, but it is possible for two edges to have the same distance in 
	// a particular direction if the path passes through a corner of a voxel.  In this case, we need to advance voxels in two directions simultaneously and to avoid if/else branches
	// to handle every possibility, we simply advance one of the voxel numbers and pass the assumed current_voxel to this function.  Under normal circumstances, this function simply return the 
	// distance to the next edge in a particual direction.  If the path passed through a corner, then this function will return 0 so we will know the voxel needs to be advanced in this direction too.
	*/
	int next_voxel = current_voxel + increasing_direction * step_direction;//  vz = 0, i = -1, s = 1 	
	double next_edge = edge_coordinate( zero_coordinate, next_voxel, voxel_size, increasing_direction, step_direction );
	return abs( next_edge - current_position );
}
double edge_coordinate( double zero_coordinate, int voxel_entered, double voxel_size, int increasing_direction, int step_direction )
{
	// Determine if on left or right edge, since entering a voxel can happen from either side depending on path direction, then calculate the x/y/z coordinate corresponding to the x/y/z edge, respectively
	int on_edge = ( step_direction == increasing_direction ) ? voxel_entered : voxel_entered + 1;
	return zero_coordinate + ( increasing_direction * on_edge * voxel_size );
}
double path_projection( double m, double current_coordinate, double zero_coordinate, int current_voxel, double voxel_size, int increasing_direction, int step_direction )
{
	// Based on the dimensions of a voxel and the current (x,y,z) position, we can determine how far it is to the next edge in the x, y, and z directions.  Since the points where a path crosses 
	// one of these edges each have a corresponding (x,y,z) coordinate, we can determine which edge will be crossed next by comparing the coordinates of the next x/y/z edge in one of the three 
	// directions and determining which is closest to the current position.  For example, the x/y/z edge whose x coordinate is closest to the current x coordinate is the next edge 
	int next_voxel = current_voxel + increasing_direction * step_direction;
	double next_edge = edge_coordinate( zero_coordinate, next_voxel, voxel_size, increasing_direction, step_direction );
	// y = m(x-x0) + y0 => distance = m * (x - x0)
	return m * ( next_edge - current_coordinate );
}
double corresponding_coordinate( double m, double x, double x0, double y0 )
{
	// Using the coordinate returned by edge_coordinate, call this function to determine one of the other coordinates using 
	// y = m(x-x0)+y0 equation determine coordinates in other directions by subsequent calls to this function
	return m * ( x - x0 ) + y0;
}
void take_2D_step
( 
	const int x_move_direction, const int y_move_direction, const int z_move_direction,
	const double dy_dx, const double dz_dx, const double dz_dy, 
	const double dx_dy, const double dx_dz, const double dy_dz, 
	const double x_start, const double y_start, const double z_start, 
	double& x, double& y, double& z, 
	int& voxel_x, int& voxel_y, int& voxel_z, int& voxel,
	double& x_to_go, double& y_to_go, double& z_to_go	
)
{
	// Change in x for Move to Voxel Edge in y
	double y_extension = fabs( dx_dy ) * y_to_go;
	//If Next Voxel Edge is in x or xy Diagonal
	if( x_to_go <= y_extension )
	{
		//printf(" x_to_go <= y_extension \n");
		voxel_x += x_move_direction;					
		x = edge_coordinate( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
		y = corresponding_coordinate( dy_dx, x, x_start, y_start );
		x_to_go = VOXEL_WIDTH;
		y_to_go = distance_remaining( Y_ZERO_COORDINATE, y, Z_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
	}
	// Else Next Voxel Edge is in y
	else
	{
		//printf(" y_extension < x_extension \n");				
		voxel_y -= y_move_direction;
		y = edge_coordinate( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Y_INCREASING_DIRECTION, y_move_direction );
		x = corresponding_coordinate( dx_dy, y, y_start, x_start );
		x_to_go = distance_remaining( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
		y_to_go = VOXEL_HEIGHT;
	}
	if( x_to_go == 0 )
	{
		x_to_go = VOXEL_WIDTH;
		voxel_x += x_move_direction;
	}
	if( y_to_go == 0 )
	{
		y_to_go = VOXEL_HEIGHT;
		voxel_y -= y_move_direction;
	}
	voxel_z = max(voxel_z, 0 );
	voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
}
void take_3D_step
( 
	const int x_move_direction, const int y_move_direction, const int z_move_direction,
	const double dy_dx, const double dz_dx, const double dz_dy, 
	const double dx_dy, const double dx_dz, const double dy_dz, 
	const double x_start, const double y_start, const double z_start, 
	double& x, double& y, double& z, 
	int& voxel_x, int& voxel_y, int& voxel_z, int& voxel,
	double& x_to_go, double& y_to_go, double& z_to_go	
)
{
		// Change in z for Move to Voxel Edge in x and y
	double x_extension = fabs( dz_dx ) * x_to_go;
	double y_extension = fabs( dz_dy ) * y_to_go;
	if( (z_to_go <= x_extension  ) && (z_to_go <= y_extension) )
	{
		//printf("z_to_go <= x_extension && z_to_go <= y_extension\n");				
		voxel_z -= z_move_direction;					
		z = edge_coordinate( Z_ZERO_COORDINATE, voxel_z, VOXEL_THICKNESS, Z_INCREASING_DIRECTION, z_move_direction );					
		x = corresponding_coordinate( dx_dz, z, z_start, x_start );
		y = corresponding_coordinate( dy_dz, z, z_start, y_start );
		x_to_go = distance_remaining( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
		y_to_go = distance_remaining( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );	
		z_to_go = VOXEL_THICKNESS;
	}
	//If Next Voxel Edge is in x or xy Diagonal
	else if( x_extension <= y_extension )
	{
		//printf(" x_extension <= y_extension \n");					
		voxel_x += x_move_direction;
		x = edge_coordinate( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
		y = corresponding_coordinate( dy_dx, x, x_start, y_start );
		z = corresponding_coordinate( dz_dx, x, x_start, z_start );
		x_to_go = VOXEL_WIDTH;
		y_to_go = distance_remaining( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
		z_to_go = distance_remaining( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
	}
	// Else Next Voxel Edge is in y
	else
	{
		//printf(" y_extension < x_extension \n");
		voxel_y -= y_move_direction;					
		y = edge_coordinate( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Y_INCREASING_DIRECTION, y_move_direction );
		x = corresponding_coordinate( dx_dy, y, y_start, x_start );
		z = corresponding_coordinate( dz_dy, y, y_start, z_start );
		x_to_go = distance_remaining( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
		y_to_go = VOXEL_HEIGHT;					
		z_to_go = distance_remaining( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
	}
	if( x_to_go == 0 )
	{
		x_to_go = VOXEL_WIDTH;
		voxel_x += x_move_direction;
	}
	if( y_to_go == 0 )
	{
		y_to_go = VOXEL_HEIGHT;
		voxel_y -= y_move_direction;
	}
	if( z_to_go == 0 )
	{
		z_to_go = VOXEL_THICKNESS;
		voxel_z -= z_move_direction;
	}
	voxel_z = max(voxel_z, 0 );
	voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
	//end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
}
/***********************************************************************************************************************************************************************************************************************/
/********************************************************************************************* Voxel Walk Functions (Device) *******************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
__device__ double distance_remaining_GPU( double zero_coordinate, double current_position, int increasing_direction, int step_direction, double voxel_size, int current_voxel )
{
	/* Determine distance from current position to the next voxel edge.  Based on the dimensions of a voxel and the current (x,y,z) position, we can determine how far it is to
	// the next edge in the x, y, and z directions.  Since the points where a path crosses one of these edges each have a corresponding (x,y,z) coordinate, we can determine
	// which edge will be crossed next by comparing the coordinates of the next x/y/z edge in one of the three directions and determining which is closest the current position.  
	// For example, the edge whose x coordinate is closest to the x coordinate will be encountered next.  However, it is possible for two edges to have the same distance in 
	// a particular direction if the path passes through a corner of a voxel.  In this case we need to advance voxels in two direction simultaneously and to avoid if/else branches
	// to handle every possibility, we simply advance one of the voxel numbers and pass the assumed current_voxel to this function.  If the path passed through a corner, then this
	// function will return 0 for remaining distance and we can advance the voxel number upon review of its return value.
	*/
	int next_voxel = current_voxel + increasing_direction * step_direction;
	double next_edge = edge_coordinate_GPU( zero_coordinate, next_voxel, voxel_size, increasing_direction, step_direction );
	return abs( next_edge - current_position );
}
__device__ double edge_coordinate_GPU( double zero_coordinate, int voxel_entered, double voxel_size, int increasing_direction, int step_direction )
{
	int on_edge = ( step_direction == increasing_direction ) ? voxel_entered : voxel_entered + 1;
	return zero_coordinate + ( increasing_direction * on_edge * voxel_size );
}
__device__ double path_projection_GPU( double m, double x0, double zero_coordinate, int current_voxel, double voxel_size, int increasing_direction, int step_direction )
{

	int next_voxel = current_voxel + increasing_direction * step_direction;
	double x_next_edge = edge_coordinate_GPU( zero_coordinate, next_voxel, voxel_size, increasing_direction, step_direction );
	// y = mx + b: x(2) = [Dx(2)/Dx(1)]*[x(1) - x(1,0)] + x(2,0) => x = (Dx/Dy)*(y - y0) + x0
	return m * ( x_next_edge - x0 );
}
__device__ double corresponding_coordinate_GPU( double m, double x, double x0, double y0 )
{
	// Using the coordinate returned by edge_coordinate, call this function to determine one of the other coordinates using 
	// y = m(x-x0)+y0 equation determine coordinates in other directions by subsequent calls to this function
	return m * ( x - x0 ) + y0;
}
__device__ void take_2D_step_GPU
( 
	const int x_move_direction, const int y_move_direction, const int z_move_direction,
	const double dy_dx, const double dz_dx, const double dz_dy, 
	const double dx_dy, const double dx_dz, const double dy_dz, 
	const double x_start, const double y_start, const double z_start, 
	double& x, double& y, double& z, 
	int& voxel_x, int& voxel_y, int& voxel_z, int& voxel,
	double& x_to_go, double& y_to_go, double& z_to_go	
)
{
	// Change in x for Move to Voxel Edge in y
	double y_extension = fabs( dx_dy ) * y_to_go;
	//If Next Voxel Edge is in x or xy Diagonal
	if( x_to_go <= y_extension )
	{
		//printf(" x_to_go <= y_extension \n");
		voxel_x += x_move_direction;					
		x = edge_coordinate_GPU( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
		y = corresponding_coordinate_GPU( dy_dx, x, x_start, y_start );
		x_to_go = VOXEL_WIDTH;
		y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
	}
	// Else Next Voxel Edge is in y
	else
	{
		//printf(" y_extension < x_extension \n");				
		voxel_y -= y_move_direction;
		y = edge_coordinate_GPU( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Y_INCREASING_DIRECTION, y_move_direction );
		x = corresponding_coordinate_GPU( dx_dy, y, y_start, x_start );
		x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
		y_to_go = VOXEL_HEIGHT;
	}
	if( x_to_go == 0 )
	{
		x_to_go = VOXEL_WIDTH;
		voxel_x += x_move_direction;
	}
	if( y_to_go == 0 )
	{
		y_to_go = VOXEL_HEIGHT;
		voxel_y -= y_move_direction;
	}
	voxel_z = max(voxel_z, 0 );
	voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
}
__device__ void take_3D_step_GPU
( 
	const int x_move_direction, const int y_move_direction, const int z_move_direction,
	const double dy_dx, const double dz_dx, const double dz_dy, 
	const double dx_dy, const double dx_dz, const double dy_dz, 
	const double x_start, const double y_start, const double z_start, 
	double& x, double& y, double& z, 
	int& voxel_x, int& voxel_y, int& voxel_z, int& voxel,
	double& x_to_go, double& y_to_go, double& z_to_go	
)
{
		// Change in z for Move to Voxel Edge in x and y
	double x_extension = fabs( dz_dx ) * x_to_go;
	double y_extension = fabs( dz_dy ) * y_to_go;
	if( (z_to_go <= x_extension  ) && (z_to_go <= y_extension) )
	{
		//printf("z_to_go <= x_extension && z_to_go <= y_extension\n");				
		voxel_z -= z_move_direction;					
		z = edge_coordinate_GPU( Z_ZERO_COORDINATE, voxel_z, VOXEL_THICKNESS, Z_INCREASING_DIRECTION, z_move_direction );					
		x = corresponding_coordinate_GPU( dx_dz, z, z_start, x_start );
		y = corresponding_coordinate_GPU( dy_dz, z, z_start, y_start );
		x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
		y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );	
		z_to_go = VOXEL_THICKNESS;
	}
	//If Next Voxel Edge is in x or xy Diagonal
	else if( x_extension <= y_extension )
	{
		//printf(" x_extension <= y_extension \n");					
		voxel_x += x_move_direction;
		x = edge_coordinate_GPU( X_ZERO_COORDINATE, voxel_x, VOXEL_WIDTH, X_INCREASING_DIRECTION, x_move_direction );
		y = corresponding_coordinate_GPU( dy_dx, x, x_start, y_start );
		z = corresponding_coordinate_GPU( dz_dx, x, x_start, z_start );
		x_to_go = VOXEL_WIDTH;
		y_to_go = distance_remaining_GPU( Y_ZERO_COORDINATE, y, Y_INCREASING_DIRECTION, y_move_direction, VOXEL_HEIGHT, voxel_y );
		z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
	}
	// Else Next Voxel Edge is in y
	else
	{
		//printf(" y_extension < x_extension \n");
		voxel_y -= y_move_direction;					
		y = edge_coordinate_GPU( Y_ZERO_COORDINATE, voxel_y, VOXEL_HEIGHT, Y_INCREASING_DIRECTION, y_move_direction );
		x = corresponding_coordinate_GPU( dx_dy, y, y_start, x_start );
		z = corresponding_coordinate_GPU( dz_dy, y, y_start, z_start );
		x_to_go = distance_remaining_GPU( X_ZERO_COORDINATE, x, X_INCREASING_DIRECTION, x_move_direction, VOXEL_WIDTH, voxel_x );
		y_to_go = VOXEL_HEIGHT;					
		z_to_go = distance_remaining_GPU( Z_ZERO_COORDINATE, z, Z_INCREASING_DIRECTION, z_move_direction, VOXEL_THICKNESS, voxel_z );
	}
	if( x_to_go == 0 )
	{
		x_to_go = VOXEL_WIDTH;
		voxel_x += x_move_direction;
	}
	if( y_to_go == 0 )
	{
		y_to_go = VOXEL_HEIGHT;
		voxel_y -= y_move_direction;
	}
	if( z_to_go == 0 )
	{
		z_to_go = VOXEL_THICKNESS;
		voxel_z -= z_move_direction;
	}
	voxel_z = max(voxel_z, 0 );
	voxel = voxel_x + voxel_y * COLUMNS + voxel_z * COLUMNS * ROWS;
	//end_walk = ( voxel == voxel_out ) || ( voxel_x >= COLUMNS ) || ( voxel_y >= ROWS ) || ( voxel_z >= SLICES );
}
/***********************************************************************************************************************************************************************************************************************/
/************************************************************************************************ Host Helper Functions ************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
double randn (double mu, double sigma)
{
  double U1, U2, W, mult;
  static double X1, X2;
  static int call = 0;
 
  if (call == 1)
    {
      call = !call;
      return (mu + sigma * (double) X2);
    }
 
  do
    {
      U1 = -1 + ((double) rand () / RAND_MAX) * 2;
      U2 = -1 + ((double) rand () / RAND_MAX) * 2;
      W = pow (U1, 2) + pow (U2, 2);
    }
  while (W >= 1 || W == 0);
 
  mult = sqrt ((-2 * log (W)) / W);
  X1 = U1 * mult;
  X2 = U2 * mult;
 
  call = !call;
 
  return (mu + sigma * (double) X1);
}
template<typename T, typename T2> T max_n( int num_args, T2 arg_1, ...)
{
	T2 largest = arg_1;
	T2 value;
	va_list values;
	va_start( values, arg_1 );
	for( int i = 1; i < num_args; i++ )
	{
		value = va_arg( values, T2 );
		largest = ( largest > value ) ? largest : value;
	}
	va_end(values);
	return (T) largest; 
}
template<typename T, typename T2> T min_n( int num_args, T2 arg_1, ...)
{
	T2 smallest = arg_1;
	T2 value;
	va_list values;
	va_start( values, arg_1 );
	for( int i = 1; i < num_args; i++ )
	{
		value = va_arg( values, T2 );
		smallest = ( smallest < value ) ? smallest : value;
	}
	va_end(values);
	return (T) smallest; 
}
template<typename T> T* sequential_numbers( int start_number, int length )
{
	T* sequential_array = (T*)calloc(length,sizeof(T));
	//std::iota( sequential_array, sequential_array + length, start_number );
	return sequential_array;
}
void bin_2_indexes( int& bin_num, int& t_bin, int& v_bin, int& angular_bin )
{
	// => bin = t_bin + angular_bin * T_BINS + v_bin * ANGULAR_BINS * T_BINS > 0
	while( bin_num - ANGULAR_BINS * T_BINS > 0 )
	{
		bin_num -= ANGULAR_BINS * T_BINS;
		v_bin++;
	}
	// => bin = t_bin + angular_bin * T_BINS > 0
	while( bin_num - T_BINS > 0 )
	{
		bin_num -= T_BINS;
		angular_bin++;
	}
	// => bin = t_bin > 0
	t_bin = bin_num;
}
std::string terminal_response(char* system_command) 
{
	#if defined(_WIN32) || defined(_WIN64)
		FILE* pipe = _popen(system_command, "r");
    #else
		FILE* pipe = popen(system_command, "r");
    #endif
    
    if (!pipe) return "ERROR";
    char buffer[256];
    std::string result;
    while(!feof(pipe)) {
    	if(fgets(buffer, 256, pipe) != NULL)
    		result += buffer;
    }
	#if defined(_WIN32) || defined(_WIN64)
		 _pclose(pipe);
    #else
		 pclose(pipe);
    #endif
   
    return result;
}
char((&terminal_response( char* system_command, char(&result)[256]))[256])
{
	#if defined(_WIN32) || defined(_WIN64)
		FILE* pipe = _popen(system_command, "r");
    #else
		FILE* pipe = popen(system_command, "r");
    #endif
    
    if (!pipe) 
		{
			strcpy(result, "ERROR");
			return result;
	}
	strcpy(result, "");
    char buffer[128];
    while(!feof(pipe)) {
    	if(fgets(buffer, 128, pipe) != NULL)
    		sprintf( result, "%s%s", result, buffer );
    }
	#if defined(_WIN32) || defined(_WIN64)
		 _pclose(pipe);
    #else
		 pclose(pipe);
    #endif
	return result;
}
char((&current_MMDD( char(&date_MMDD)[5]))[5])
{
	time_t rawtime;
	time (&rawtime);
	struct tm * timeinfo = gmtime (&rawtime);
	strftime (date_MMDD,11,"%m%d", timeinfo);
	return date_MMDD;
}
char((&current_MMDDYYYY( char(&date_MMDDYYYY)[9]))[9])
{
	time_t rawtime;
	time (&rawtime);
	struct tm * timeinfo = gmtime (&rawtime);
	strftime (date_MMDDYYYY,11,"%m%d%Y", timeinfo);
	return date_MMDDYYYY;
}
char((&current_YY_MM_DD( char(&date_YY_MM_DD)[9]))[9])
{
	time_t rawtime;
	time (&rawtime);
	struct tm * timeinfo = gmtime (&rawtime);
	strftime (date_YY_MM_DD,11,"%y-%m-%d", timeinfo);
	return date_YY_MM_DD;
}
/***********************************************************************************************************************************************************************************************************************/
/************************************************************************************* Console Window Print Statement Functions  ***************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void print_colored_text(const char* statement_in, unsigned int shade, unsigned int color_code )
{
	char statement_out[256];
	sprintf(statement_out, "echo -e \x1b[31m;1b %s\x1b[0m", statement_in );
	//sprintf(statement_out, "echo -e \"\e[%d;%dm%s\e[m\"", shade, color_code, statement_in );
	
	system(statement_out);
}
void print_section_separator(const char separation_char, unsigned int shade, unsigned int color_code )
{
	char section_separator[CONSOLE_WINDOW_WIDTH];
	for( int n = 0; n < CONSOLE_WINDOW_WIDTH; n++ )
		section_separator[n] = separation_char;
	section_separator[CONSOLE_WINDOW_WIDTH - 1] = '\0';
	print_colored_text( section_separator, shade, color_code );
}
void construct_header_line( const char* statement, const char separation_char, char* header )
{
	size_t length = strlen(statement), max_line_length = 70;
	size_t num_dashes = CONSOLE_WINDOW_WIDTH - length - 2;
	size_t leading_dashes = num_dashes / 2;
	size_t trailing_dashes = num_dashes - leading_dashes;
	size_t i = 0, line_length, index = 0;

	line_length = min(static_cast<int>(length - index), static_cast<int>(max_line_length));
	if( line_length < length - index )
		while( statement[index + line_length] != ' ' )
			line_length--;
	num_dashes = CONSOLE_WINDOW_WIDTH - line_length - 2;
	leading_dashes = num_dashes / 2;		
	trailing_dashes = num_dashes - leading_dashes;

	for( ; i < leading_dashes; i++ )
		header[i] = separation_char;
	if( statement[index] != ' ' )
		header[i++] = ' ';
	else
		header[i++] = separation_char;
	for( int j = 0; j < line_length; j++)
		header[i++] = statement[index++];
	header[i++] = ' ';
	for( int j = 0; j < trailing_dashes; j++)
		header[i++] = separation_char;
	header[CONSOLE_WINDOW_WIDTH - 1] = '\0';
}
void print_section_header( const char* statement, const char separation_char, unsigned int shade, unsigned int color_code )
{
	print_section_separator(separation_char, shade, color_code);
	char header[CONSOLE_WINDOW_WIDTH];
	size_t length = strlen(statement), max_line_length = 70;
	size_t num_dashes = CONSOLE_WINDOW_WIDTH - length - 2;
	size_t leading_dashes = num_dashes / 2;
	size_t trailing_dashes = num_dashes - leading_dashes;
	size_t i, line_length, index = 0;

	while( index < length )
	{
		i = 0;
		line_length = min(static_cast<int>(length - index), static_cast<int>(max_line_length));
		if( line_length < length - index )
			while( statement[index + line_length] != ' ' )
				line_length--;
		num_dashes = CONSOLE_WINDOW_WIDTH - line_length - 2;
		leading_dashes = num_dashes / 2;		
		trailing_dashes = num_dashes - leading_dashes;

		for( ; i < leading_dashes; i++ )
			header[i] = separation_char;
		if( statement[index] != ' ' )
			header[i++] = ' ';
		else
			header[i++] = separation_char;
		for( int j = 0; j < line_length; j++)
			header[i++] = statement[index++];
		header[i++] = ' ';
		for( int j = 0; j < trailing_dashes; j++)
			header[i++] = separation_char;
		header[CONSOLE_WINDOW_WIDTH - 1] = '\0';
		print_colored_text( header, shade, color_code );
	}
	print_section_separator(separation_char, shade, color_code);
}
void print_section_exit( const char* statement, const char* leading_statement_chars, unsigned int shade, unsigned int color_code )
{
	char header[CONSOLE_WINDOW_WIDTH];
	size_t length = strlen(statement), max_line_length = 70;
	size_t leading_chars = strlen(leading_statement_chars);
	size_t i = 0, index = 0, line_length;

	while( index < length )
	{
		line_length = min(static_cast<int>(length - index), static_cast<int>(max_line_length));
		if( line_length < length - index )
			while( statement[index + line_length] != ' ' )
				line_length--;
		leading_chars = strlen(leading_statement_chars);

		if( index == 0 )
		{
			for( ; i < leading_chars; i++ )
				header[i] = leading_statement_chars[i];
		}
		else
		{
			for( ; i < leading_chars; i++ )
				header[i] = ' '; 
		}
		
		header[i++] = ' ';
		if( statement[index] == ' ' )
			index++;
		for( int j = 0; j < line_length; j++ )
			header[i++] = statement[index++];
		for( ; i < CONSOLE_WINDOW_WIDTH; i++ )
			header[i] = ' ';
		header[CONSOLE_WINDOW_WIDTH - 1] = '\0';
		print_colored_text( header, shade, color_code );
		i = 0;
	}
}
/***********************************************************************************************************************************************************************************************************************/
/*********************************************************************************************** Device Helper Functions ***********************************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
cudaError_t CUDA_error_check( char* error_statement )
{
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("%s %s\n", error_statement, cudaGetErrorString(cudaStatus));						  

	return cudaStatus;
}
cudaError_t CUDA_error_check_and_sync_device( char* error_statement, char* sync_statement )
{
	cudaError_t cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) 
		printf("%s %s\n", error_statement, cudaGetErrorString(cudaStatus));						  
	
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess)
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching %s Kernel!\n", cudaStatus, sync_statement);

	return cudaStatus;
}
/***********************************************************************************************************************************************************************************************************************/
/************************************************************************************ Testing Functions and Functions in Development ***********************************************************************************/
/***********************************************************************************************************************************************************************************************************************/
void voxel_2_3D_voxels2( int voxel, int& voxel_x, int& voxel_y, int& voxel_z, int rows,  int columns )
{
	voxel_x = 0;
    voxel_y = 0;
    voxel_z = 0;
    
    while( voxel - rows * columns >= 0 )
	{
		voxel -= rows * columns;
		voxel_z++;
	}
	// => bin = t_bin + angular_bin * T_BINS > 0
	while( voxel - columns >= 0 )
	{
		voxel -= columns;
		voxel_y++;
	}
	// => bin = t_bin > 0
	
	voxel_x = voxel;
}
void test_func()
{
	//current_YY_MM_DD( EXECUTION_DATE);
	//assign_directories();
	int slices = 4, rows = 5, columns = 5;
	int voxel, voxels = slices*rows*columns;
	cout << "Hello1" << endl;
	x_h = (float*)calloc(voxels, sizeof(float));
	cout << "Hello2" << endl;
	for( int i = 0; i < slices; i++ )
	{
		for( int j = 0; j < rows; j++ )
		{
			for( int k = 0; k < columns; k++ )
			{
				x_h[k+ columns*j + columns*rows*i] = i*j*k + i + j + 1;
			//x_h[i*10 +j] = i * j;
			}
		}
	}
	G_x_h = (float*)calloc(voxels, sizeof(float));
	G_y_h = (float*)calloc(voxels, sizeof(float));
	G_norm_h = (float*)calloc(voxels, sizeof(float));
	G_h = (float*)calloc(voxels, sizeof(float));
	float* G_h2 = (float*)calloc(voxels, sizeof(float));
	cout << "Hello3" << endl;
	// 1. Calculate the difference at each pixel with respect to rows and columns and get the normalization factor for this pixel
	for( int slice = 0; slice < slices; slice++ )
	{
		for( int row = 0; row < rows - 1; row++ )
		{
			for( int column = 0; column < columns - 1; column++ )
			{
				voxel			= column + row * columns + slice * rows * columns;
				G_x_h[voxel]	= x_h[voxel + 1] - x_h[voxel];
				G_y_h[voxel]	= x_h[voxel + columns] - x_h[voxel];
				G_norm_h[voxel] = sqrt( powf( G_x_h[voxel], 2 ) + powf( G_y_h[voxel], 2 ) );
				//G_norm_h[voxel] = sqrt( ( G_x_h[voxel] * G_x_h[voxel] ) + ( G_y_h[voxel] * G_y_h[voxel] ) );
			}
		}
	}
	cout << "Hello4" << endl;
	
	// 2. Add the appropriate difference values to each pixel subgradient
	for( int slice = 0; slice < slices; slice++ )
	{
		for( int row = 0; row < rows - 1; row++ )
		{
			for( int column = 0; column < columns - 1; column++ )
			{
				voxel = column + row * columns + slice * rows * columns;
				if( G_norm_h[voxel] > 0.0 )
				{
					G_h[voxel]			 -= ( G_x_h[voxel] + G_y_h[voxel] ) / G_norm_h[voxel];		// Negative signs on x/y terms applied using -=
					G_h[voxel + columns] += G_y_h[voxel] / G_norm_h[voxel];
					G_h[voxel + 1]		 += G_x_h[voxel] / G_norm_h[voxel];
				}
			}
		}
	}
	cout << "Hello5" << endl;
	
	int row, column, slice;
	for( voxel = 0; voxel < voxels; voxel++)
	{
		voxel_2_3D_voxels2( voxel, column, row, slice, rows,  columns );
		
		if( G_norm_h[voxel] > 0.0 )
			//if( (column < COLUMNS - 1) &&  (row < ROWS - 1) )		
			G_h2[voxel] -= ( G_x_h[voxel] + G_y_h[voxel] ) / G_norm_h[voxel];		// Negative signs on x/y terms applied using -=		
		if( row > 0 && G_norm_h[voxel- columns] > 0.0)		
			G_h2[voxel] += G_y_h[voxel - columns] / G_norm_h[voxel - columns];
		if( column > 0 && G_norm_h[voxel -1] > 0.0)		
			G_h2[voxel] += G_x_h[voxel - 1] / G_norm_h[voxel - 1];
	
	}
	//int row2, column2, slice2;
	//for( int slice = 0; slice < slices; slice++ )
	//{
	//	for( int row = 0; row < rows; row++ )
	//	{
	//		for( int column = 0; column < columns; column++ )
	//		{
	//			voxel = column + row * columns + slice * rows * columns;
	//			voxel_2_3D_voxels2( voxel, column2, row2, slice2, rows,  columns);
	//			if( row -row2 != 0 )
	//				cout << row << " row " << row2 << endl;
	//			if( column -column2 != 0 )
	//				cout << column << " col " << column2 << endl;
	//			if( slice -slice2 != 0 )
	//				cout << slice << " sli " << slice2 << endl;
	//			//if( column
	//			if( G_norm_h[voxel] > 0.0 )
	//				G_h2[voxel] -= ( G_x_h[voxel] + G_y_h[voxel] ) / G_norm_h[voxel];		// Negative signs on x/y terms applied using -=					
	//			if( row > 0 && G_norm_h[voxel- columns] > 0.0)		
	//				G_h2[voxel] += G_y_h[voxel - columns] / G_norm_h[voxel - columns];
	//			if( column > 0 && G_norm_h[voxel -1] > 0.0)		
	//				G_h2[voxel] += G_x_h[voxel - 1] / G_norm_h[voxel - 1];
	//		}
	//	}
	//}


	cout << "Hello6" << endl;
	//for( int slice = 0; slice < slices; slice++ )
	//{
	//	for( int row = 0; row < rows - 1; row++ )
	//	{
	//		for( int column = 0; column < columns - 1; column++ )
	//		{
	//			voxel = column + row * columns + slice * rows * columns;
	//			cout << G_h2[voxel] << " ";
	//		}
	//		cout << endl;
	//	}
	//
	//}
	//cout << "Hello7" << endl;
	int count = 0;
	for( int slice = 0; slice < slices; slice++ )
	{
		for( int row = 0; row < rows - 1; row++ )
		{
			for( int column = 0; column < columns - 1; column++ )
			{
				voxel = column + row * columns + slice * rows * columns;
				if( fabs(G_h[voxel] - G_h2[voxel]) > 0.0001 )
				{
					cout << row <<" " << column << " " << slice << endl;
					cout << G_h[voxel] << " " << G_h2[voxel] << endl;
					count++;
				}
			}
		}
	}
	cout << voxels <<" " << count << endl;
	//cout << "Hello8" << endl;
	//post_reconstruction_results_transfers();
	//char filename[256];
	//char* name = "FBP_med7";
	//sprintf( filename, "%s%s/%s%s", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, name, ".bin" );
	//float* image = (float*)calloc( NUM_VOXELS, sizeof(float));
	//import_image( image, filename );
	//array_2_disk( name, OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, image, COLUMNS, ROWS, SLICES, NUM_VOXELS, true );
	//read_config_file();
	//double voxels[4] = {1,2,3,4};
	//std::copy( hull_h, hull_h + NUM_VOXELS, x_h );
	//std::function<double(int, int)> fn1 = my_divide;                    // function
	//int x = 2;
	//int y = 3;
	//cout << func_pass_test(x,y, fn1) << endl;
	//std::function<double(double, double)> fn2 = my_divide2;                    // function
	//double x2 = 2;
	//double y2 = 3;
	//cout << func_pass_test(x2,y2, fn2) << endl;
	//std::function<int(int)> fn2 = &half;                   // function pointer
	//std::function<int(int)> fn3 = third_t();               // function object
	//std::function<int(int)> fn4 = [](int x){return x/4;};  // lambda expression
	//std::function<int(int)> fn5 = std::negate<int>();      // standard function object
	//create_MLP_test_image();
	//array_2_disk( "MLP_image_init", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_test_image_h, MLP_IMAGE_COLUMNS, MLP_IMAGE_ROWS, MLP_IMAGE_SLICES, MLP_IMAGE_VOXELS, true );
	//MLP_test();
	//array_2_disk( "MLP_image", OUTPUT_DIRECTORY, OUTPUT_TO_UNIQUE, MLP_test_image_h, MLP_IMAGE_COLUMNS, MLP_IMAGE_ROWS, MLP_IMAGE_SLICES, MLP_IMAGE_VOXELS, true );
	//double* x = (double*) calloc(4, sizeof(double) );
	//double* y = (double*) calloc(4, sizeof(double) );
	//double* z = (double*) calloc(4, sizeof(double) );

	//double* x_d, *y_d, *z_d;
	////sinogram_filtered_h = (float*) calloc( NUM_BINS, sizeof(float) );
	//cudaMalloc((void**) &x_d, 4*sizeof(double));
	//cudaMalloc((void**) &y_d, 4*sizeof(double));
	//cudaMalloc((void**) &z_d, 4*sizeof(double));

	//cudaMemcpy( x_d, x, 4*sizeof(double), cudaMemcpyHostToDevice);
	//cudaMemcpy( y_d, y, 4*sizeof(double), cudaMemcpyHostToDevice);
	//cudaMemcpy( z_d, z, 4*sizeof(double), cudaMemcpyHostToDevice);

	//dim3 dimBlock( 1 );
	//dim3 dimGrid( 1 );   	
	//test_func_device<<< dimGrid, dimBlock >>>( x_d, y_d, z_d );

	//cudaMemcpy( x, x_d, 4*sizeof(double), cudaMemcpyDeviceToHost);
	//cudaMemcpy( y, y_d, 4*sizeof(double), cudaMemcpyDeviceToHost);
	//cudaMemcpy( z, z_d, 4*sizeof(double), cudaMemcpyDeviceToHost);

	//for( unsigned int i = 0; i < 4; i++)
	//{
	//	printf("%3f\n", x[i] );
	//	printf("%3f\n", y[i] );
	//	printf("%3f\n", z[i] );
	//	//cout << x[i] << endl; // -8.0
	//	//cout << y[i] << endl;
	//	//cout << z[i] << endl;
	//}
}
