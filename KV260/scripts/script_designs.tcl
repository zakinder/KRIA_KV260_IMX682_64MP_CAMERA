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
# -- $Date: 2016/02/04 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2010/03/06  | $Author: Hartfiel, John
# -- - miscellaneous
# ------------------------------------------
# -- $Date:  2017/09/06  | $Author: Hartfiel, John
# -- - add new document history style
# -- - add sdsoc generation
# ------------------------------------------
# -- $Date:  2018/05/09  | $Author: Hartfiel, John
# -- - add prod export on development generation
# ------------------------------------------
# -- $Date:  2018/06/06  | $Author: Hartfiel, John
# -- - modified prod export on development generation for different apps
# ------------------------------------------
# -- $Date:  2018/11/26  | $Author: Hartfiel, John
# -- - replace copy_prod_export with beta_hw_export_binary
# ------------------------------------------
# -- $Date:  2019/02/08  | $Author: Hartfiel, John
# -- - add run_board_selection, rework generate_board_file_project_all
# ------------------------------------------
# -- $Date:  2019/02/14  | $Author: Hartfiel, John
# -- - add design_settings.tcl
# ------------------------------------------
# -- $Date:  2019/03/11  | $Author: Hartfiel, John
# -- - add design_settings.tcl --> bugfix file check
# ------------------------------------------
# -- $Date:  2019/05/29  | $Author: Hartfiel, John
# -- - bugfix production export
# ------------------------------------------
# -- $Date:  2019/09/13  | $Author: Hartfiel, John
# -- - new message in case gui will opend
# ------------------------------------------
# -- $Date:  2019/11/05  | $Author: Hartfiel, John
# -- - modify run_current_project_all
# ------------------------------------------
# -- $Date:  2019/12/04  | $Author: Hartfiel, John
# -- - replace hsi with vitis sdk
# ------------------------------------------
# -- $Date:  2019/12/17  | $Author: Hartfiel, John
# -- - changed vitis parameter
# ------------------------------------------
# -- $Date:  2020/01/09  | $Author: Hartfiel, John
# -- - run_board_selection add possibility to disable block design version control
# -- - run_board_selection add prod id binaries export
# ------------------------------------------
# -- $Date:  2020/01/31  | $Author: Hartfiel, John
# -- - run_board_selection add labtools support for prebuitls
# ------------------------------------------
# -- $Date:  2020/02/14  | $Author: Hartfiel, John
# -- - run_board_selection add labtools support for prebuitls
# -- - generate_board_file_project_all  add ingore version control
# ------------------------------------------
# -- $Date:  2020/02/21  | $Author: Hartfiel, John
# -- - run_board_selection version remove patch version number
# ------------------------------------------
# -- $Date:  2020/04/07  | $Author: Hartfiel, John
# -- -modify basic_inits
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval ::TE {
  namespace eval INIT {
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # initial functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--basic_inits: initial some variables and list 
    proc basic_inits {} {
      if {[file exists ${TE::SET_PATH}/design_settings.tcl]} {
        TE::UTILS::te_msg TE_INIT-182 INFO "Source ${TE::SET_PATH}/design_settings.tcl."
        if {[catch {source ${TE::SET_PATH}/design_settings.tcl} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-80 ERROR "Script (source design_settings.tcl) failed: $result."; return -code error}
      }
      if {[catch {TE::ENV::set_add_env} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-202 ERROR "Script (TE::INIT::set_add_env) failed: $result."; return -code error}
      if {[catch {TE::INIT::print_version} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-71 ERROR "Script (TE::INIT::print_version) failed: $result."; return -code error}
      if {[catch {TE::INIT::print_environment_settings} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-72 ERROR "Script (TE::INIT::print_environment_settings) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_pathvar} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-73 ERROR "Script (TE::INIT::init_pathvar) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_boardlist} result]} {abort_status "Error Initialization..."; create_allboardfiles_status;create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-74 ERROR "Script (TE::INIT::init_boardlist) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_app_list} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-75 ERROR "Script (TE::INIT::init_app_list) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_zip_ignore_list} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-76 ERROR "Script (TE::INIT::init_zip_ignore_list) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_mod_list} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-77 ERROR "Script (TE::INIT::init_mod_list) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_usr_tcl} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-78 ERROR "Script (TE::INIT::init_usr_tcl) failed: $result."; return -code error}
      if {[file exists ${TE::SET_PATH}/development_settings.tcl]} {
        TE::UTILS::te_msg TE_INIT-79 INFO "Source ${TE::SET_PATH}/development_settings.tcl."
        if {[catch {source ${TE::SET_PATH}/development_settings.tcl} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-80 ERROR "Script (source development_settings.tcl) failed: $result."; return -code error}
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished initial functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # cmd functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--run_board_selection:  select board interactive 
    proc run_board_selection {} {
      TE::UTILS::te_msg TE_INIT-89 INFO "Run TE::INIT::run_board_selection"
      
      
      
      
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-83 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}

      #set vivado_version [version -short]
      set vivado_version "[lindex [split [version -short ] "."]  0].[lindex [split [version -short ] "."]  1]"
      
      set bd_version [TE::UTILS::get_bd_vivado_version]
      set vivado_version_full [version]
      set vivado_lab false
      if {[string match -nocase "*Vivado Lab*" $vivado_version_full ] } {
        set vivado_lab true
        if {![string match "*$vivado_version*" $bd_version] && ![string match "NA" $bd_version]} {
        
          puts "-----------------------"
          puts "Warning: Design was generated with Vivado <$bd_version> , but is now being run in <$vivado_version> of Vivado Lab. There may have been  changes between ltx files definition of Vivado <$bd_version> and <$vivado_version>, which could impact functionality."
          puts "Please Agree that you understand this warning to continue (y/N):"
          gets stdin someVar
          if {[string match -nocase "y" $someVar ] } {
            set TE::VERSION_CONTROL false
          } else {
            exit -1;
          }
        }
      } else {

        if {![string match "*$vivado_version*" $bd_version] && ![string match "NA" $bd_version]} {
        
          puts "-----------------------"
          puts "Warning: This block design was generated using Vivado <$bd_version> without IP versions in the create_bd_cell commands, but is now being run in <$vivado_version> of Vivado. There may have been major IP version changes between Vivado <$bd_version> and <$vivado_version>, which could impact the parameter settings of the IPs."
          puts "Should version control be deactivated (y/N):"
          gets stdin someVar
          if {[string match -nocase "y" $someVar ] } {
            set TE::VERSION_CONTROL false
          }
        }
      }
      set someVar "L"
      set saved_someVar $someVar
      set tmpList $TE::BDEF::BOARD_DEFINITION
      set tmpList2 $tmpList
      
      set first_time true
      set small_list false

      # Output the results
      set last_input ?
      while {! [string match -nocase "Q" $someVar ] } {
        set last_input $someVar
        puts "Last Input:<$someVar>"
        if {[string match -nocase "L" $someVar ] } {
          set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list]  
          set tmpList $tmpList2
          set someVar Q
        } elseif {[string match -nocase  "R" $someVar ] } {
          set tmpList $TE::BDEF::BOARD_DEFINITION
          set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list]  
          set tmpList $tmpList2
          set someVar Q
        } elseif {[string match -nocase "ID" $someVar ] || [string is integer -strict $someVar] } {
          if {[string length  $someVar ] == 6 && [string is integer -strict $someVar] } {
          
             if {[catch {set an [TE::EXT::run_serial $someVar]} result]} {set an "$result"}
             set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::PRODID} $an $small_list]  
            if {[llength $tmpList2] != 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No ID matched with $an ($someVar), try again:"   
              set someVar Q    
            } 
            set tmpList $tmpList2
          } else {
            puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*1*"
            puts "Go back to top menu with 'q' or 'Q'"
            puts "Step 2: Insert ID:"
            if {![string is integer -strict $someVar] } {
              gets stdin someVar
            }
            if {![string match -nocase  "Q" $someVar ]} {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::ID} $someVar $small_list]  
              if {[llength $tmpList2] < 2 } {
                set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
                puts "No ID matched with $someVar, try again:"   
                set someVar Q    
              }
              set tmpList $tmpList2
            }
          }
        } elseif {[string match -nocase  "AN" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*-1*"
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert Article Number:"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ]} {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::PRODID} $someVar $small_list]  
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No ID matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }
        } elseif {[string match -nocase "FPGA" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*xc*"
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert FPGA/SoC Part Name:"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ] } {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::PARTNAME} $someVar $small_list]  
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No ID matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }
        } elseif {[string match -nocase  "PCB" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*01*"
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert PCB Revision Number:"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ]} {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::PCB_REV} $someVar $small_list]  
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No ID matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }
        } elseif {[string match -nocase  "DDR" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*1*"
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert DDR Size:"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ] } {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::DDR_SIZE} $someVar $small_list]  
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No ID matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }
        } elseif {[string match -nocase "FLASH" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*32*"
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert Flash Size:"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ]} {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::FLASH_SIZE} $someVar $small_list]  
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No ID matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }
        } elseif {[string match -nocase "EMMC" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*4*."
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert eMMC Size:"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ]} {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::EMMC_SIZE} $someVar $small_list] 
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No ID matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }          
        } elseif {[string match -nocase "OTHERS" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*4*."
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert selection :"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ]} {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::OTHERS} $someVar $small_list] 
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No OTHERS matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }          
        } elseif {[string match -nocase "NOTES" $someVar ] } {
          puts "Note: Input will be compared with list elements, wildcard * possible. Ex.*4*."
          puts "Go back to top menu with 'q' or 'Q'"
          puts "Step 2: Insert selection :"
          gets stdin someVar
          if {![string match -nocase "Q" $someVar ]} {
            set tmpList2 [TE::UTILS::print_boardlist $tmpList ${TE::BDEF::NOTES} $someVar $small_list] 
            if {[llength $tmpList2] < 2 } {
              set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list] 
              puts "No NOTES matched with $someVar, try again:"              
            }
            set tmpList $tmpList2
          }          
        }  elseif {[string match -nocase "full" $someVar ]} {
          set small_list false
          puts "Full Table view enabled"
          puts "------------------------------------------------------------------------"
          set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list]  
          set tmpList $tmpList2
          set someVar Q
        } elseif {[string match -nocase "small" $someVar ]} {
          set small_list true
          puts "Small Table view enabled"
          puts "------------------------------------------------------------------------"
          set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list]  
          set tmpList $tmpList2
          set someVar Q
        } else {
          puts "Unknown input '$someVar'"
          set someVar Q
          puts "------------------------------------------------------------------------"
        }
        puts "------------------------------------------------------------------------"
        if {$first_time} {
          puts "For better table view please resize windows to full screen!"
          puts "------------------------------------------------------------------------"
          set first_time false
        }
        if {[llength $tmpList] < 2 } {
          puts "Restore module list"
          set tmpList $TE::BDEF::BOARD_DEFINITION
          puts "------------------------------------------------------------------------"
        }
        
        if {[llength $tmpList] == 2 } {
          puts "You like to start with this device? y/N"
          gets stdin someVar
          if { [string match -nocase "Y" $someVar ]} {
           break
          } 
          set tmpList $TE::BDEF::BOARD_DEFINITION
          set tmpList2 [TE::UTILS::print_boardlist $tmpList 0 NA $small_list]  
          set tmpList $tmpList2
          set someVar Q
          puts "------------------------------------------------------------------------"
        }
        if {[string match -nocase "Q" $someVar ]} {
        
          puts "------------------"
          puts "Select Module will be done in 2 steps: "
          puts "-----"
          puts "Step 1: (select column filter): "
          puts "-Change module list size (for small monitors only), press: 'full' or 'small' "
          puts "-Display current module list, press: 'L' or 'l' "
          puts "-Restore whole module list, press: 'R' or 'r' "
          puts "-Reduce List by ID, press: 'ID' or 'id' or insert ID columns value directly(filter step is bypassed and id number is used) "
          puts "-Reduce List by Article Number, press: 'AN' or 'an' "
          puts "-Reduce List by SoC/FPGA, press: 'FPGA' or 'fpga' "
          puts "-Reduce List by PCB REV, press: 'PCB' or 'pcb' "
          puts "-Reduce List by DDR, press: 'DDR' or 'ddr' "
          puts "-Reduce List by Flash, press: 'FLASH' or 'flash' "
          puts "-Reduce List by EMMC, press: 'EMMC' or 'emmc' "
          puts "-Reduce List by Others, press: 'OTHERS' or 'others' "
          puts "-Reduce List by Notes, press: 'NOTES' or 'notes' "
          puts "-Exit without selection, press: 'Q' or 'q' "
          puts "-----------------------"
          puts "Please Enter Option: "
          gets stdin someVar
          set saved_someVar $someVar
        } else {
          set someVar $saved_someVar
        }
        
        
      }
      if { [string match -nocase "Y" $someVar ]} {
        
        set selected [lindex $tmpList 1]
        TE::UTILS::mod_configfile [lindex $selected ${TE::BDEF::ID}] true
        if {$vivado_lab} {
          puts "What would you like to do?"
          puts "- Open LabTools and open delivery binary folder, press 0"
          puts "- Open LabTools project, press 1"
          puts "- Both, press 2"
          gets stdin someVar
          if { [string match -nocase "0" $someVar ] || [string match -nocase "2" $someVar ]} {
            TE::INIT::init_board [lindex $selected ${TE::BDEF::ID}] ${TE::BDEF::ID}
            set location [TE::UTILS::copy_user_export]
            [catch {exec {*}[auto_execok start] "" [file nativename $location]}]
          }
          if {![string match -nocase "0" $someVar ]} {
             puts "Test |[lindex $selected ${TE::BDEF::ID}]|"
             TE::INIT::run_labtools [lindex $selected ${TE::BDEF::ID}]
          }
        } else {
          puts "What would you like to do?"
          puts "- Create and open delivery binary folder, press 0"
          puts "- Create vivado project, press 1"
          puts "- Both, press 2"
          gets stdin someVar
          if { [string match -nocase "0" $someVar ] || [string match -nocase "2" $someVar ]} {
            TE::INIT::init_board [lindex $selected ${TE::BDEF::ID}] ${TE::BDEF::ID}
            set location [TE::UTILS::copy_user_export]
            [catch {exec {*}[auto_execok start] "" [file nativename $location]}]
          }
          if {![string match -nocase "0" $someVar ]} {
            TE::INIT::run_project [lindex $selected ${TE::BDEF::ID}] 1 1 2
          }
        
        }
        
      } else {
        puts "Exit"
      }
      
    }
    #--------------------------------
    #--run_te_procedure: run tcl Function from cmd file
    proc run_te_procedure {TCL_PROCEDURE BOARD} {
      TE::UTILS::te_msg TE_INIT-81 INFO "Run TE::INIT::run_te_procedure $TCL_PROCEDURE $BOARD"
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-82 ERROR "Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      #Attention not all Procedures can start directly from shell
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-83 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {[catch {init_board [TE::BDEF::find_id $BOARD] 0} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-84 ERROR "Script (TE::INIT::init_board /[TE::BDEF::find_id/]) failed: $result."; return -code error}
      if {[catch {eval $TCL_PROCEDURE} result]} {abort_status "Error Run TE-TCLProcedure from batch file..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-85 ERROR "Script (${TCL_PROCEDURE}) failed: $result."; return -code error}
    }
    #--------------------------------
    #--clear_project_all:todo:use run_te_procedure
    proc clear_project_all {} {
      TE::UTILS::te_msg TE_INIT-86 INFO "Run TE::INIT::clear_project_all "
      if {[catch {TE::UTILS::clean_all_generated_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-87 ERROR "Script (TE::UTILS::clean_all_generated_files) failed: $result."; return -code error}
    }
    #--------------------------------
    #--run_labtools:todo:use run_te_procedure
    proc run_labtools {BOARD} {
      TE::UTILS::te_msg TE_INIT-88 INFO "Run TE::INIT::run_labtools $BOARD"
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-89 ERROR "Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-90 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {[catch {init_board [TE::BDEF::find_id $BOARD] 0} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-91 ERROR "Script (TE::INIT::init_board /[TE::BDEF::find_id/]) failed: $result."; return -code error}
      if {[catch {TE::INIT::generate_labtools_project GUI} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-92 ERROR "Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
    }
    #--------------------------------
    #--program_zynq_bin:
    proc program_zynq_bin {USE_BASEFOLDER BOARD SWAPP LABTOOLS} {
      TE::UTILS::te_msg TE_INIT-93 INFO "Run TE::INIT::program_zynq_bin $USE_BASEFOLDER $BOARD $SWAPP $LABTOOLS"
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-94 ERROR "Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      set return_filename ""
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-95 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {$LABTOOLS} {
        if {[catch {TE::INIT::generate_labtools_project} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-96 ERROR "Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP -used_basefolder_binfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-97 ERROR "Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-98 ERROR "Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        }
      } else {
        #dummi project need for jtag reboot memory
        set curpath [pwd]
        if {[catch {TE::INIT::generate_dummi_project} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-169 ERROR "Script (TE::INIT::generate_dummi_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP -used_basefolder_binfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-99 ERROR "Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-100 ERROR "Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        }
        if {[catch {TE::INIT::delete_dummi_project $curpath} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-101 ERROR "Script (TE::INIT::delete_dummi_project) failed: $result."; return -code error}
      }
      TE::UTILS::te_msg TE_INIT-102 INFO "Programming Flash without Error (Programming File: ${return_filename})  \n \
        ------"
    }
    #--------------------------------
    #--program_fpga_mcs:
    proc program_fpga_mcs {USE_BASEFOLDER BOARD SWAPP LABTOOLS} {
      TE::UTILS::te_msg TE_INIT-103 INFO "Run TE::INIT::program_fpga_mcs $USE_BASEFOLDER $BOARD $SWAPP $LABTOOLS"
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-104 ERROR "Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      set return_filename ""
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-105 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {$LABTOOLS} {
        if {[catch {TE::INIT::generate_labtools_project} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-106 ERROR "Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP -used_basefolder_mcsfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-107 ERROR "Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-108 ERROR "Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        }
      } else {
        #dummi project need for jtag reboot memory
        set curpath [pwd]
        if {[catch {TE::INIT::generate_dummi_project} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-109 ERROR "Script (TE::INIT::generate_dummi_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP -used_basefolder_mcsfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-110 ERROR "Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-111 ERROR "Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        }
        if {[catch {TE::INIT::delete_dummi_project $curpath} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-112 ERROR "Script (TE::INIT::delete_dummi_project) failed: $result."; return -code error}
      }
      TE::UTILS::te_msg TE_INIT-113 INFO "Programming Flash without Error (Programming File: ${return_filename})  \n \
        ------"
    }
    #--------------------------------
    #--program_fpga_bit:
    proc program_fpga_bit {USE_BASEFOLDER BOARD SWAPP LABTOOLS} {
      TE::UTILS::te_msg TE_INIT-114 INFO "Run TE::INIT::program_fpga_bit $USE_BASEFOLDER $BOARD $SWAPP $LABTOOLS"
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-115 ERROR "Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      set return_filename ""
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-116 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {$LABTOOLS} {
        if {[catch {TE::INIT::generate_labtools_project} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-117 ERROR "Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
          if {$USE_BASEFOLDER} {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP -used_basefolder_bitfile]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-118 ERROR "Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          } else {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-119 ERROR "Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          }
        } else {
        #dummi project need for jtag reboot memory
        set curpath [pwd]
        if {[catch {TE::INIT::generate_dummi_project} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-120 ERROR "Script (TE::INIT::generate_dummi_project) failed: $result."; return -code error}
          if {$USE_BASEFOLDER} {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP -used_basefolder_bitfile]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-121 ERROR "Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          } else {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-122 ERROR "Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          }
        if {[catch {TE::INIT::delete_dummi_project $curpath} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-123 ERROR "Script (TE::INIT::delete_dummi_project) failed: $result."; return -code error}
      }
      TE::UTILS::te_msg TE_INIT-124 INFO "Programming FPGA without Error (Programming File: ${return_filename})  \n \
        ------"
    }
    #--------------------------------
    #--run_sdk:
    proc run_sdk {BOARD} {
      TE::UTILS::te_msg TE_INIT-125 INFO "Run TE::INIT::run_sdk $BOARD"
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-126 ERROR "Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-127 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {[catch {TE::sw_run_sdk -prebuilt_hdf [TE::BDEF::find_id $BOARD]} result]} {abort_status "Error external SDK starting..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-128 ERROR "Script (TE::sw_run_sdk) failed: $result."; return -code error}
    }
    #--------------------------------
    #--run_project: VIVADO project
    proc run_project {BOARD RUN GUI CLEAN} {
      TE::UTILS::te_msg TE_INIT-129 INFO "Run TE::INIT::run_project $BOARD $RUN $GUI $CLEAN"
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-130 ERROR "Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-131 ERROR "Script (TE::INIT::basic_inits) failed: $result."; return -code error}

      switch $CLEAN {
        0 {}
        1 {
            if {[catch {TE::UTILS::clean_vivado_project} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-132 ERROR "Script (TE::UTILS::clean_vivado_project) failed: $result."; return -code error}
          }
        2 {
            if {[catch {TE::UTILS::clean_vivado_project} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-133 ERROR "Script (TE::UTILS::clean_vivado_project) failed: $result."; return -code error}
            if {[catch {TE::UTILS::clean_workspace_sdk} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-134 ERROR "Script (TE::UTILS::clean_workspace_sdk) failed: $result."; return -code error}
          }
        3 {
            if {[catch {TE::UTILS::clean_all_generated_files} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-135 ERROR "Script (TE::UTILS::clean_all_generated_files) failed: $result."; return -code error}
          }
        4 {
            if {[catch {TE::UTILS::clean_all_generated_files;TE::UTILS::clean_prebuilt_all} result]} {abort_status "Error Initialization..."; create_allboardfiles_status;  TE::UTILS::te_msg TE_INIT-136 ERROR "Script (TE::UTILS::clean_all_generated_files , TE::UTILS::clean_prebuilt_all) failed: $result."; return -code error}
          }
        default {abort_status "Error Initialization..."; create_allboardfiles_status; return -code error "Error: Design clean option $CLEAN not available, use [show_help]";}
      }
      if {$RUN > 0 } {
        if {[catch {init_board [TE::BDEF::find_id $BOARD] 0} result]} {abort_status "Error Initialization..."; create_allboardfiles_status;  TE::UTILS::te_msg TE_INIT-137 ERROR "Script (TE::INIT::init_board /[TE::BDEF::find_id/]) failed: $result."; return -code error}
      }
      
      switch $RUN {
        -1 {TE::UTILS::te_msg TE_INIT-138 INFO " Clear only Mode selected..."}
        0 {start_existing_project $GUI }
        1 {generate_single_project $GUI }
        2 {generate_single_project_all $GUI }
        3 {generate_board_file_project_all $GUI 0}
        4 {generate_board_file_project_all $GUI 1}
        default {abort_status "Error Initialization..."; create_allboardfiles_status; return -code error "Error: Design run option $OPT not available, use [show_help]";}
      }
      TE::UTILS::te_msg TE_INIT-139 INFO "Run project finished without Error. \n \
        ------"
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished cmd functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # project design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--generate_dummi_project: for external programming without labtools and sdk only 
    proc generate_dummi_project {} {
      file mkdir $TE::VPROJ_PATH/tmp 
      cd $TE::VPROJ_PATH/tmp 
      TE::UTILS::te_msg TE_INIT-140 STATUS "Create temporary vivado project in: [pwd]"
      ::create_project -force tmp $TE::VPROJ_PATH/tmp 
    }  
    #--------------------------------
    #--delete_dummi_project: for external programming without labtools and sdk only 
    proc delete_dummi_project {oldpath} {
      ::close_project
      TE::UTILS::te_msg TE_INIT-141 STATUS "Delete temporary vivado project in: [pwd]"
      cd $oldpath
      if {[catch {file delete -force -- $TE::VPROJ_PATH/tmp} result ]} {      
        # somtimes is locked from other process
        # puts "Info:(TE) Can't delete temporary folder."
      }
    }
    #--------------------------------
    #--start_existing_project: 
    proc start_existing_project {GUI} {
      if { [file exists $TE::VPROJ_PATH] } { 
        cd  $TE::VPROJ_PATH
        if { [file exists ${TE::VPROJ_NAME}.xpr] } { 
          TE::UTILS::te_msg TE_INIT-142 STATUS "Open existing project (File: ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.xpr)."
          if {[catch {TE::VIV::open_project} result]} { TE::UTILS::te_msg TE_INIT-143 ERROR "Script (TE::VIV::open_project) failed: $result."; return -code error}
          if {$GUI >= 1} {
            TE::UTILS::te_msg TE_INIT-147 STATUS "Start GUI...all other messages will be print inside the GUI TCL console of Vivado"
            start_gui
          }
        } else {
            return -code error "Error: $TE::VPROJ_NAME.xpr not found in [pwd]";
          }
      } else {
        return -code error "Error: ${TE::VPROJ_PATH}/$TE::VPROJ_NAME.xpr not found";
      }	
      #---------------------------------------------
    }
    #--------------------------------
    #--generate_single_project: 
    proc generate_single_project {GUI } {
      if { [file exists $TE::VPROJ_PATH] } { 
        cd  $TE::VPROJ_PATH
      } else {
       TE::UTILS::te_msg TE_INIT-144 STATUS "Generate new project (Path: ${TE::VPROJ_PATH})."
       file mkdir $TE::VPROJ_PATH
       cd  $TE::VPROJ_PATH
      }
      # this is only need in case vivado version is changed over cmd, I dn't know why
      set vivado_version "[lindex [split [version -short ] "."]  0].[lindex [split [version -short ] "."]  1]"
      file mkdir ${TE::VPROJ_PATH}/$vivado_version
      #end buxfix 
      #
      if { [file exists *.xpr] } { 
        return -code error "Error: Project folder not empty, clear [pwd]";
      } else {
       if {[catch {TE::VIV::create_project} result]} { TE::UTILS::te_msg TE_INIT-145 ERROR "Script (TE::VIV::create_project) failed: $result."; return -code error}
        if {$GUI == 1} { 
          TE::UTILS::te_msg TE_INIT-147 STATUS "Start GUI...all other messages will be print inside the GUI TCL console of Vivado"
          start_gui
        }
        if {[catch {TE::VIV::import_design} result]} { TE::UTILS::te_msg TE_INIT-146 ERROR "Script (TE::VIV::import_design) failed: $result."; return -code error}
        if {$GUI == 2} { 
          TE::UTILS::te_msg TE_INIT-147 STATUS "Start GUI...all other messages will be print inside the GUI TCL console of Vivado"
          start_gui
        }
      }	
    }
    #--------------------------------
    #--generate_single_project_all: 
    proc generate_single_project_all {GUI} {
      if {$GUI == 1} { generate_single_project 1 } else {generate_single_project 0 }
      #--------------------------------------------------------
      run_current_project_all
      #--------------------------------------------------------
      if {$GUI == 2} { 
        TE::UTILS::te_msg TE_INIT-147 STATUS "Start GUI...all other messages will be print inside the GUI TCL console of Vivado"
        start_gui
      }
    }
    #--------------------------------
    #--generate_board_file_project_all: 
    proc generate_board_file_project_all {GUI SDSOC} {
      set TE::VERSION_CONTROL false
      set doneList [list]
      set tmpList  [list]
      foreach sublist $TE::BDEF::BOARD_DEFINITION {
        set rundesign true
        set id [lindex $sublist ${TE::BDEF::ID}]
        if {$id ne "ID" } {
          if {[llength $TE::DESIGNRUNS] > 0} {
            if {[lsearch -exact $TE::DESIGNRUNS $id] == -1 } {
              TE::UTILS::te_msg TE_INIT-147 STATUS "Skip ID(ignore): $id"
              set rundesign false
            }
          }
          if { [lsearch -exact $doneList $id] != -1} {
            TE::UTILS::te_msg TE_INIT-181 STATUS "Skip ID(done): $id"
            set rundesign false
          }
          if {$rundesign == true} {
            TE::UTILS::te_msg TE_INIT-148 STATUS "Run project id $id (Path: [pwd]) \n \
            ------"
            if {[catch {TE::UTILS::clean_vivado_project} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-149 ERROR "Script (TE::UTILS::clean_vivado_project) failed: $result."; return -code error}
            if {[catch {TE::UTILS::clean_workspace_sdk} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-150 ERROR "Script (TE::UTILS::clean_workspace_sdk) failed: $result."; return -code error}
            if {[catch {init_board $id 0} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-151 ERROR "Script (TE::init_board) failed: $result."; return -code error}
            if {[catch {generate_single_project_all  0} result]} {abort_status "Error generate projects..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-152 ERROR "Script (TE::generate_single_project_all) failed: $result."; return -code error}
            if {$SDSOC == 1 } {
              if {[catch {TE::ADV::beta_util_sdsoc_project} result]} {abort_status "Error generate projects..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-170 ERROR "Script (TE::generate_single_project_all) failed: $result."; return -code error}
            }

            TE::VIV::close_project
            
            set tmpList [TE::UTILS::print_boardlist $TE::BDEF::BOARD_DEFINITION $TE::BDEF::SHORTNAME [lindex $sublist ${TE::BDEF::SHORTNAME}] false true]
            foreach internal $tmpList {
              lappend doneList [lindex $internal ${TE::BDEF::ID}]
            }
          }
        }
      }

      if {[catch {TE::ADV::beta_hw_export_binary -all} result]} {abort_status "Error Initialization..."; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-171 ERROR "Script (TE::ADV::beta_hw_export_binary) failed: $result."; return -code error}
      create_allboardfiles_status
    }
    #--------------------------------
    #--run_current_project_all: 
    proc run_current_project_all {} {
      # if {[catch {TE::VIV::build_design ${TE::GEN_HW_BIT} ${TE::GEN_HW_MCS} ${TE::GEN_HW_RPT}} result]} {TE::VIV::report_summary;set message "Error:(TE) Script (TE::VIV::build_design) failed: $result."; abort_status $emessage; puts $emessage; return -code error}
      set hw_options [list]
      if {!${TE::GEN_SW_USEPREBULTHDF}} {
        if {!${TE::GEN_HW_BIT}} {lappend hw_options "-disable_bitgen"; TE::UTILS::te_msg TE_INIT-153 WARNING "Auto-generation of Bit-file is disabled."}
        if {!${TE::GEN_HW_RPT}} {lappend hw_options "-disable_reports"; TE::UTILS::te_msg TE_INIT-154 WARNING "Auto-generation of Report-file is disabled."}
        if {!${TE::GEN_HW_HDF}} {lappend hw_options "-disable_hdf"; TE::UTILS::te_msg TE_INIT-155 WARNING "Auto-generation of HDF-file is disabled."}
        if {!${TE::GEN_HW_MCS}} {lappend hw_options "-disable_mcsgen"; TE::UTILS::te_msg TE_INIT-156 WARNING "Auto-generation of MCS-file is disabled."}
        if {[catch {eval TE::hw_build_design ${hw_options}} result]} {TE::VIV::report_summary;set emessage "Error: Script (TE::hw_build_design) failed: $result."; abort_status $emessage;  create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-157 ERROR "$emessage" ; return -code error}
      }    
      #----------------------------------------------------------
      set sw_options [list]
      lappend sw_options "-clear"
      lappend sw_options "-no_gui"
      lappend sw_options "-all"
      if {!${TE::GEN_SW_HSI}}     {lappend sw_options "-dis_xsct"; TE::UTILS::te_msg TE_INIT-158 WARNING "Auto-generation of ELF-files is disabled."}
      if {!${TE::GEN_SW_BIF}}     {lappend sw_options "-dis_bif"; TE::UTILS::te_msg TE_INIT-159 WARNING "Auto-generation of BIF-files is disabled."}
      if {!${TE::GEN_SW_BIN}}     {lappend sw_options "-dis_bin"; TE::UTILS::te_msg TE_INIT-160 WARNING "Auto-generation of BIN-files is disabled."}
      if {!${TE::GEN_SW_BITMCS}}  {lappend sw_options "-dis_bitmcs"; TE::UTILS::te_msg TE_INIT-161 WARNING "Auto-generation of BIT-files and MCS-files is disabled."}
      if {${TE::GEN_SW_USEPREBULTHDF}}  {lappend sw_options "-prebuilt_hdf_only"; lappend sw_options "$TE::SHORTDIR"; TE::UTILS::te_msg TE_INIT-162 WARNING "Prebuilt HDF is used."}
      if {${TE::GEN_SW_FORCEBOOTGEN}}  {lappend sw_options "-force_bin"; TE::UTILS::te_msg TE_INIT-163 WARNING "Force Boot.bin is used."}
      if {[catch {eval TE::sw_run_vitis ${sw_options}} result]} { set emessage "Error: Script (TE::sw_run_vitis) failed: $result."; abort_status $emessage; create_allboardfiles_status; TE::UTILS::te_msg TE_INIT-164 ERROR "$emessage" ; return -code error}
      abort_status "Ok"
    }
    #--------------------------------
    #--generate_labtools_project: 
    proc generate_labtools_project { {gui ""} } {
      if { [file exists $TE::VLABPROJ_PATH] } { 
        cd  $TE::VLABPROJ_PATH
        if { [file exists ${TE::VPROJ_NAME}.lpr] } { 
          if {[catch {TE::VLAB::open_project} result]} { TE::UTILS::te_msg TE_INIT-165 ERROR "Script (TE::VLAB::open_project) failed: $result."; return -code error}
        } else {
          if {[catch {TE::VLAB::create_project} result]} { TE::UTILS::te_msg TE_INIT-166 ERROR "Script (TE::VLAB::create_project) failed: $result."; return -code error}
        }
      } else {
       TE::UTILS::te_msg TE_INIT-167 STATUS "Generate new project (Path: $TE::VLABPROJ_PATH)"
       file mkdir $TE::VLABPROJ_PATH
       cd  $TE::VLABPROJ_PATH
       if {[catch {TE::VLAB::create_project} result]} { TE::UTILS::te_msg TE_INIT-168 ERROR "Script (TE::VLAB::create_project) failed: $result."; return -code error}
      }	
      if {$gui ne ""} {
        TE::UTILS::te_msg TE_INIT-147 STATUS "Start GUI...all other messages will be print inside the GUI TCL console of Vivado"
        start_gui
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished project design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # status files functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--remove_status_files: 
    proc remove_status_files {} {
      if { [file exists ${TE::LOG_PATH}/allboardparts.txt] } {
        file delete -force ${TE::LOG_PATH}/allboardparts.txt
      }
      if { [file exists ${TE::LOG_PATH}/status.txt] } {
        file delete -force ${TE::LOG_PATH}/status.txt
      }
    }
    #--------------------------------
    #--create_allboardfiles_status: 
    proc create_allboardfiles_status {} {
      set report_file ${TE::LOG_PATH}/allboardparts.txt
      set fp_w [open ${report_file} "w"]
      puts $fp_w "it's generate only for powershell polling..."
      close $fp_w
    }
    #--------------------------------
    #--abort_status: 
    proc abort_status {message} {
      set report_file ${TE::LOG_PATH}/status.txt

      if { ![file exists ${report_file}]} {
        set fp_w [open ${report_file} "w"]
        puts $fp_w "Run ${TE::BOARDPART} with Status $message"
        close $fp_w
      } else {
        set fp_a [open ${report_file} "a"]
        puts $fp_a "Run ${TE::BOARDPART} with Status $message"
        close $fp_a
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished status files functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  puts "INFO:(TE) Load Designs script finished"
}


