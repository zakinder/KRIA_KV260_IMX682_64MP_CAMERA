# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst         *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# -- $Author: Hartfiel, John $
# -- $Email: j.hartfiel@trenz-electronic.de $
# --------------------------------------------------------------------
# -- Change History:
# ------------------------------------------
# -- $Date: 2016/02/02 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/06/30  | $Author: Hartfiel, John
# -- - miscellaneous
# ------------------------------------------
# -- $Date:  2017/09/04  | $Author: Hartfiel, John
# -- - add new document history style
# ------------------------------------------
# -- $Date:  2019/01/18  | $Author: Hartfiel, John
# -- - add run_board_selection as selection
# ------------------------------------------
# -- $Date:  2019/01/28  | $Author: Hartfiel, John
# -- - new location for sdsoc_pfm.tcl
# ------------------------------------------
# -- $Date:   2019/01/28 | $Author: Hartfiel, John
# -- - new location for sdsoc_pfm.tcl
# ------------------------------------------
# -- $Date:  2020/02/25  | $Author: Hartfiel, John
# -- - remove program flash bin and flash mcs
# ------------------------------------------
# -- $Date:  2020/03/02  | $Author: Hartfiel, John
# -- - check project path
# ------------------------------------------
# -- $Date:  2021/07/26  | $Author: Hartfiel, John
# -- - add petalinux tcl
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------
puts "-----------------------------------------------------------------------"
#load source scripts
source ../scripts/script_settings.tcl
source ../scripts/script_environment.tcl
source ../scripts/script_vivado.tcl
source ../scripts/script_te_utils.tcl
source ../scripts/script_external.tcl
source ../scripts/script_petalinux.tcl
source ../scripts/script_designs.tcl
source ../scripts/script_usrcommands.tcl
#todo remove sdsoc it's obsolete
source ../scripts/script_sdsoc.tcl  
#sources from other programs:
# source ../scripts/main.tcl
# source ../scripts/script_vitis.tcl
set sdsoc_available "0"
catch {set sdsoc_available $::env(SDSOC_AVAILABLE)}
if {$sdsoc_available} {
  set x_dir ""
  set x_vers ""
  catch {set x_dir $::env(XILDIR)}
  catch {set x_vers $::env(VIVADO_VERSION)}
  set sdsoc_tcl "${x_dir}/Vivado/${x_vers}/scripts/ipintegrator/sdsoc_pfm.tcl"
  puts "INFO:(TE) Source Xilinx SDSoC Scripts (${x_dir}/Vivado/${x_vers}/scripts/ipintegrator/sdsoc_pfm.tcl)."
  source -notrace ${sdsoc_tcl}
}
puts "-----------------------------------------------------------------------"

namespace eval ::TE {
  namespace eval INIT {
    variable my_script $argv0
    #

    proc return_option {option} {
      global argc
      global argv
      
      if { $argc <= [expr $option + 1]} { 
      puts "ERROR:(TE) Read Parameter failed"
      show_help
      } else {  
      puts "INFO:(TE) Parameter Option Value: [lindex $argv [expr $option + 1]]"
      return [lindex $argv [expr $option + 1]]
      }
    }

    proc show_help_batchfile_commands {} {
      variable my_script
      puts "--TODO: Rework Info for main"
      puts "INFO:(TE) Batch-File TCL-Script start options:"
      puts "write: vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs <Options>"
      puts "Options:"
      puts "Programming:"
      puts "--TODO: explanation"
      puts "Create/Run Vivado project:"
      puts "--run            : run option: \
                                          -1-no nothing is done \
                                          0 -open existing project(default) \
                                          1 -create selected boardpart project \
                                          2 -run selected boardpart project \
                                          3 -run all boardpart project"
      puts "--boardpart            : Trenz Board ID from TEXXXX_boardfiles.csv  (you can use ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list)"
      puts "--gui                  : gui mode option:\
                                                      0 -disable(default) \
                                                      1 -before project generation \
                                                      2 -after project generation"
      puts "--clean                : clean project option:\
                                                           0 -no(default) \
                                                           1 -vivado project \
                                                           2 -vivado and hsi workspace \
                                                           3 -all (vivado, hsi and sdk workspace )\
                                                           4 -all and prebuilt (vivado, hsi and sdk workspace and prebuilt)"
      puts "--help                 : display this help and exit"
      puts ""
      puts "Example: vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --part xc7z020clg484-1 --boardpart trenz.biz:te0720-02-1cf:part0:1.0 --clean"
    }

    proc main {} {
      global argc
      global argv
      #
      set use_board_selection false
      set use_teprocedure "NA"
      set use_labtoolsonly false
      set use_run_labtools false
      set use_clear_all false
      set use_run_prebuild_sdk false
      set use_zynq_programming false
      set use_mcs_programming false
      set use_bit_programming false
      set use_basefolder false
      set use_programming_app "NA"
      set use_vivadogui 0
      set use_run 0
      set use_clean 0
      set use_board "NA"
      cd ..

      puts "-----------------------------------------------------------------------"
      init_pathvar
      #
      puts "-----------------------------------------------------------------------"
      #
      if {$argc == 0} {
      puts ""
      puts "INFO:(TE) Default configuration will be used." 
      puts ""
      } else {
        for {set option 0} {$option < $argc} {incr option} {
          puts "INFO:(TE) Parameter Index: $option"
          puts "INFO:(TE) Parameter Option: [lindex $argv $option]"
          switch [lindex $argv $option] { 
          "--clear_all"       { set use_clear_all true }
          "--run_board_selection"  { set use_board_selection true }
          "--run_te_procedure"    { set use_teprocedure [return_option $option]; incr option }
          "--run_labtools"        { set use_run_labtools true }
          "--program_bit"         { set use_bit_programming true }
          "--program_swapp"       { set use_programming_app [return_option $option]; incr option  }
          "--use_basefolder"      { set use_basefolder [return_option $option]; incr option  }
          "--labtools"		        { set use_labtoolsonly true }
          "--run"		              { set use_run [return_option $option]; incr option  }
          "--boardpart"		        { set use_board [return_option $option]; incr option }
          "--gui"		              { set use_vivadogui [return_option $option]; incr option   }
          "--clean"		            { set use_clean [return_option $option]; incr option   }
          "--help"		            { show_help_batchfile_commands }
          ""		                  { }
            default               { puts "Warning:(TE) unrecognised option: [lindex $argv $option]"; show_help }
          }
        }
      }
          # "--run_prebuild_sdk"    { set use_run_prebuild_sdk true }
          # "--program_bin"        { set use_zynq_programming true }
          # "--program_mcs"         { set use_mcs_programming true }
          



      # check path length for win os only
      switch [TE::UTILS::get_host_os] {
        "windows" {
          if { [string length $TE::VPROJ_PATH] > 80 } {
            puts "CRITICAL WARNING: (TE) The host OS only allows 260 characters in a normal path. The project is stored in a path with more than 80 characters ([string length $TE::VPROJ_PATH] are used). If you experience issues with IP, Block Designs, or files not being found, please consider moving the project to a location with a shorter path. Alternately consider using _use_virtual_drive.cmd (it used the OS subst command) to map part of the path to a drive letter."
            puts "Continue? y/N"
            gets stdin someVar
            if { [string match -nocase "Y" $someVar ]} {
              TE::UTILS::te_msg TE_INIT-185 {CRITICAL WARNING} "Start Project with path which is longer that 80 characters"
            } else {
              TE::UTILS::te_msg TE_INIT-184 INFO "Termination by user, to long project path was detected"
              return
            }
          }

        }
        "unix" {

        }
      }
      # check for space characters
      if {[string match -nocase "* *"  $TE::VPROJ_PATH]} {
        puts "ERROR:(TE) Current Project path: $TE::VPROJ_PATH "
        puts "ERROR:(TE) Directory contains spaces, please remove spaces from project path, project creation is aborted, press any key to exit"
        gets stdin someVar
        TE::UTILS::te_msg TE_INIT-186 {ERROR} "Directory contains spaces, please remove spaces from project path, project creation is aborted"
        return -code error
      }
      # start 
      set starttime [clock seconds]
      
      
      puts "-----------------------------------------------------------------------"
      if {$use_clear_all} {
        if {[catch {clear_project_all } result]} { puts "ERROR:(TE) Script (TE::INIT::clear_project_all) failed: $result."; return -code error}
      } elseif {$use_board_selection } {
        if {[catch {run_board_selection } result]} { puts "ERROR:(TE) Script (TE::INIT::run_board_selection) failed: $result."; return -code error}
      } elseif {$use_teprocedure ne "NA"} {
        if {[catch {run_te_procedure $use_teprocedure $use_board} result]} { puts "ERROR:(TE) Script (TE::INIT::run_te_procedure) failed: $result."; return -code error}
      } elseif {$use_run_labtools} {
        if {[catch {run_labtools $use_board } result]} { puts "ERROR:(TE) Script (TE::INIT::run_labtools) failed: $result."; return -code error}
      } elseif {$use_run_prebuild_sdk} {
        if {[catch {run_sdk $use_board } result]} { puts "ERROR:(TE) Script (TE::INIT::run_sdk) failed: $result."; return -code error}
      } elseif {$use_bit_programming} {
        if {[catch {program_fpga_bit $use_basefolder $use_board $use_programming_app $use_labtoolsonly} result]} { puts "ERROR:(TE) Script (TE::INIT::program_fpga_bit) failed: $result."; return -code error}
      } elseif {$use_mcs_programming} {
        if {[catch {program_fpga_mcs $use_basefolder $use_board $use_programming_app $use_labtoolsonly} result]} { puts "ERROR:(TE) Script (TE::INIT::program_fpga_mcs) failed: $result."; return -code error}
      } elseif {$use_zynq_programming} {
        if {[catch {program_zynq_bin $use_basefolder $use_board $use_programming_app $use_labtoolsonly} result]} { puts "ERROR:(TE) Script (TE::INIT::program_zynq_bin) failed: $result."; return -code error}
      } else {
        if {[catch {run_project $use_board $use_run  $use_vivadogui $use_clean} result]} { puts "ERROR:(TE) Script (TE::INIT::run_project) failed: $result."; return -code error}
      }
      puts "-----------------------------------------------------------------------"
      set stoptime [clock seconds]
      set timeelapsed [expr $stoptime -$starttime]
      
      set report_file ${TE::LOG_PATH}/time_elapsed.txt
      set fp_w [open ${report_file} "w"]
      puts $fp_w "Times elapsed..."
      puts $fp_w "$timeelapsed seconds"
      puts $fp_w "..."
      close $fp_w
      
      #---------------------------------------------
    }



    if {[catch {main} result]} {
      puts "ERROR:(TE) Script (TE::main) failed: $result."
    }
	}
}