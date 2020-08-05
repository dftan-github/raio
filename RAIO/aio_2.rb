#encoding:utf-8
$source_mode=false
$app_path=File.dirname(__FILE__) + "/"
#File.binwrite $app_path+"components/aio_require", RubyVM::InstructionSequence.compile(File.read $app_path+"ruby/aio_require.rb").to_binary
if $source_mode
    #使用纯源码方式运行
    require_relative 'ruby/aio_require'
else
    #使用虚拟码运行
    RubyVM::InstructionSequence.load_from_binary(File.binread $app_path+"Components/aio_require").eval     
end
#require_relative 'aio_require'

aio_require 'main'
#o=YAML.load_file("d:/config.txt")
#File.write "d:/config2.txt",YAML::dump(o)
#p "load done"
class CApp
  def show_propertys(win_name,prop_type)
    parent=get_win(win_name)
    return unless parent
    new_prop(parent,time_for_show_caret)
    new_prop(parent,show_dyn_prompt,CWinPropbool)
    new_prop(parent,ui_config,CWinPropbool)
    new_prop(parent,length_unit,CWinPropOption)
    new_prop(parent,user_type,CWinPropOption)
    new_prop(parent,prop_int)
    new_prop(parent,prop_int)
    new_prop(parent,prop_int)
    new_prop(parent,prop_mesure_float)
    #fill_prop(parent,4)

  end  
  def init_app
    #begin 定义属性's

    def_prop(light_adj,127)
   

    def_prop(worktable_pos.x,0.0){|prop|
      prop.title.val=mls "X"
      prop.llimit.val=-100.0
      prop.ulimit.val=100.0
    }
    def_prop(worktable_pos.y,0.0){|prop|prop.title.val=mls "Y"}
    def_prop(worktable_pos.z,0.0){|prop|prop.title.val=mls "Z"}

    def_prop(time_for_show_caret,0.5){|prop|
      prop.title.val=mls "定时显示光标"
      prop.default.val=0.0
      prop.llimit.val=0.1
      prop.ulimit.val=1.0
      prop.mouse_wheel.val=0.01
      prop.unit.val=UnitTypeS
    }

    def_prop(show_dyn_prompt,true){|prop|
      prop.title.val=mls "显示动态提示"
      prop.on_set_val<<lambda{|obj,val|
        dyn_prompt_bar=get_win :DynPromptBar #windows.val['DynPromptBar']
        return unless dyn_prompt_bar
        
        if show_dyn_prompt.val
         dyn_prompt_bar.align_size.val=show_dyn_prompt.old_val.val
        else
          show_dyn_prompt.old_val.val=dyn_prompt_bar.align_size.val
         dyn_prompt_bar.align_size.val=0
        end

        dyn_prompt_bar.parent_win.val.need_resize.val=DirtyCRect

      }
    }

    def_prop(prop_int,127){|prop|
      prop.title.val=mls "亮度"
      prop.default.val=0
      prop.llimit.val=0
      prop.ulimit.val=255
      prop.mouse_wheel.val=1

    }
    def_mesure_prop(prop_mesure_float,-0.0){|prop|
      prop.title.val=mls "半径"
      prop.unit.val=UnitTypeMM
      prop.default.val=0.0
      prop.std.val=0.0
      prop.correct.val=0.05
      prop.llimit.val=-0.5
      prop.ulimit.val=0.5
      prop.mouse_wheel.val=0.01

    }
    def_prop(cmd_line,""){|prop|
      prop.title.val=mls "命令行"
      prop.on_set_val<<lambda{|obj,val|
        cmd_line.val.strip!
        if cmd_line.val.empty?

        else
          win=get_win(:cmd_line_history)
          win.add_item cmd_line.val, key_down?(VK_CONTROL)
     
          cmd_line.val="",NoNotical
        end

      }
    }

    def_prop(user_type,PermissionSuper){|prop|
      prop.title.val=mls "用户类型"
      prop.vals.val=[PermissionUser,PermissionEngine,PermissionAdmin,PermissionSuper]
      prop.onclick_fun.val=lambda{|sender|
        return true if user_type.val.id.val >= sender.val.val.id.val
        frm=get_win(:permission_check)


        #get_win(:permission_check).frm_rect.val.set([72,41,299,312])
        #dbg get_win(:permission_check).frm_rect.val.to_str

          
        frm.win_visible.val=true if frm

        #move_window $main_frm.win32_handle.val,CRect.new(0,0,1920,1080)
        false
      }
    }
    def_prop(ui_config,false){|prop|
      prop.title.val="配置UI"
    }

    
    def_prop(test_mesure_val,0){|prop|

    }

    def_prop(length_unit,UnitTypeMM){|prop|
      prop.title.val=mls "长度单位"
      prop.vals.val=[UnitTypeMM,UnitTypeInch,UnitTypeMil]
    }















    #定义UI


    qq.val="160228050@qq.com"
    frm=main_frm.val
    #$hwin=NewHFrm frm.win32_handle.val

    new_win(frm) { |win|
        win.align_size.val=AlignSizeToTextHeight

        win.name=:xxx

        #new_win(win) {|win|#main bar

            #win.align_type.val=AlignTypeClient
            win.childs_align_type.val=AlignTypeRight

            new_win(win) {|win|
                win.align_type.val=AlignTypeClient
                win.title.val="AIO (v0.0.0)"
                def win.on_render_board(dc)
                    apply_pen(dc,RGB(255,0,0),5,PS_SOLID) do

                      UseObjects(dc,GetStockObject(NULL_BRUSH)) do
                        rc=CRect.new client_rect.val
                        rc.offset! scroll_pos.val
                        Rectangle(dc,rc.left,rc.top,rc.right,rc.bottom)
                      end

                    end                
                end
                def win.on_msg_lb_down(flags,pt,win)
                     #注意运行时win2=CObj,win=CWin,奇怪，真实应该是相同的

                     #pp win2
                    hwnd=win.get_frm.win32_handle.val

                    return if 0!=IsZoomed(hwnd)

                    SendMessage(hwnd,WM_SYSCOMMAND, SC_MOVE | 4, MAKELONG(pt.x,pt.y))                    

                end
                def win.on_msg_lb_dbclk(flags,pt,win)
                    cb=lambda{|win|
                        if win.win_visible.val
                            if win.class==CWinBtn
                                case win.fun_type.val
                                when FunWinMaximize
                                    ShowWindow(win.get_frm.win32_handle.val,SW_MAXIMIZE)
                                    win.fun_type.val=FunWinNormal
                                    return false
                                when FunWinNormal
                                    ShowWindow(win.get_frm.win32_handle.val,SW_NORMAL)
                                    win.fun_type.val=FunWinMaximize
                                    return false
                                end
                            end
                        end

                        true
                    }

                    win.parent_win.val.each_win(true,false,&cb)
    
                end
            }
            new_btns(win,FunWinClose,FunWinMaximize,FunWinMinimize)
            
            win.childs_align_type.val=AlignTypeLeft
            new_btns(win,FunWinClose,FunWinMaximize,FunWinMinimize)
            
        #}
    }
    new_win(frm) {|win|#status bar
        win.align_type.val=AlignTypeBottom
        win.align_size.val=AlignSizeToTextHeight
        new_win(win,CWin,:status_bar) {|win|
            win.align_type.val=AlignTypeClient
        }

        new_win(win) {|win|
            win.align_type.val=AlignTypeRight
            win.align_size.val=100
        }
        new_win(win,CWin,:cmd_statistics){|win|
            win.align_type.val=AlignTypeRight
            win.align_size.val=150

        }        
        prop=new_prop_win(win,prop_int,CWinProp){|prop|
              prop.show_title.val=false
            prop.align_type.val=AlignTypeRight
            prop.align_size.val=200
            def prop.on_msg_lb_down(flags,pt,win)
                #self.begin_edit
                                

            end
            def prop.on_msg_lb_dbclk(flags,pt,win)
                #self.begin_edit
                                

            end
            def prop.end_edit
                return
                super
                return if $edit_win
                self.begin_edit        
                    
            end
        }
    }

  
    new_win(frm,CWin,:right_bar){|win|
        win.align_type.val=AlignTypeRight
        win.align_size.val=600

        new_win(win,CWinTab) {|win|
            win.align_type.val=AlignTypeClient
            #win.align_size.val=600
            names={app_prop:"程序属性",cmd_proc:"命令属性",doc_proc:"文档属性"}
             
            names.each do |name,title|
                new_page(win,CWinPropGrid,name) {|win|
    
    
                    win.title.val=title
                    if name==:app_prop
                    new_win(win){|win|
                        win.align_type.val=AlignTypeRight
                        win.align_size.val=150
                    }
                end
                    
                }
            end

            new_page(win,CWinGrid,:report) {|win|
                win.title.val="报表"
                win.c2.width.val=200
                win.r7.height.val=40
                row_titles=%W(测量值 上公差 标准值 下公差 最大值 最小值).to_a
                win.fixed_rows.val=row_titles.size+1
                0.upto(row_titles.size-1){|r|
                    win.send("r#{r+1}c0").val=row_titles[r]
                }

                col_titles=%W(长 宽 高 半径 真圆度).to_a
                0.upto(col_titles.size-1){|c|
                    win.send("r0c#{c+1}").val=col_titles[c]
                }

                    LOGFONT.new { |lf|
                      lf[:lfHeight] = DPIAwareFontHeight(40)
                      lf[:lfItalic] = 1
                      lf[:lfFaceName].to_ptr.put_bytes(0, mls("宋体"))

                      win.r7c2.font.val = CreateFontIndirect(lf)
                      win.r7c2.bk_color.val=rgb(0,255,0)
                      win.r7c2.fg_color.val=rgb(255,0,0)


                    }    


                win.r7c2.val="123.24"
                0.upto(row_titles.size-1){|r|
                    0.upto(col_titles.size-1){|c|
                        win.send("r#{r+1}c#{c+1}").val="#{r},#{c}"
                    }
                }

                win.r1c1.val=11
                win.r2c1.val=22
                win.r10c2.formula.val="[r0c0*3,[r1c1:r3c2].sum,r4c3:r5c4].sum"
                win.r22c29.val='aaa'
  
             }
              #win.active_page.val=0

        }
        new_win(win){|win|
            
            win.align_size.val=300
            new_win(win,CWinPropGrid,:coor_bar){|win|
                win.align_type.val=AlignTypeClient
                win.align_size.val=100
                win.prop_split.val=100
              def win.get_item_height(win)
                  return super unless win.parent_win.val.client_rect.val
        

                win.parent_win.val.client_rect.val.height / 3
              end
                  new_prop(win,worktable_pos.x)
                new_prop(win,worktable_pos.y)
                new_prop(win,worktable_pos.z)
            }
            new_win(win,CWinLightCtrl){|win|
                win.align_type.val=AlignTypeRight
                win.align_size.val=100
                win.light_bottom.val= new_obj(CObj,"light_bottom"){|obj| obj.title.val=mls "底光"}

                win.light_top.val=new_obj(CObj,"light_top"){|obj| obj.title.val=mls"上光"}
                win.light_laser.val=new_obj(CObj,"light_laser"){|obj| obj.title.val=mls"激光"}
                win.light_env.val=new_obj(CObj,"light_env"){|obj| obj.title.val=mls"环境光"}
                areas=[]
                8.times do |area|
                    huans=[]
                    4.times do |huan|
                        light=CObj.new
                        light.name="#{huan}c#{area}a"
                        light.title.val=mls"#{huan+1}环#{area+1}区"
                        light.huan.val=huan
                        light.area.val=area
                        light.val=0
                        huans<<light
                    end
                    areas<<huans
                end
    
                win.lights.val=areas

            

                prop=new_prop_win(win,light_adj,CWinProp){|prop|
                      #prop.show_title.val=false
                    prop.align_type.val=AlignTypeBottom
                    prop.align_size.val=AlignSizeToTextHeight
                    prop.val_align_style.val=DT_VCENTER | DT_CENTER | DT_SINGLELINE
                
                    def prop.get_val_str(org_val=false)
                        return super(org_val) if self.editing?
                        return super(org_val) if self !=$win_under_mouse
                        
                        return super(org_val) unless idle_area.val.pt_in_rect? $mouse_pos
                         light_adj.val.to_s

                    end
                    def prop.on_msg_lb_down(flags,pt,win)
                        return super if self==$edit_win
                            light_adj.val=    light_adj.val    

                            if self.parent_win.val.selects.val
                
                                self.parent_win.val.selects.val.each do |light|
                                    light.val=light_adj.val
    
                                end
                            end
                    
                        self.parent_win.val.win_dirty.val=true            

                    end
                    def prop.on_msg_mouse_move(flags,pt,win)
                        return super if self==$edit_win
                        rc=self.idle_area.val.deflaterect 10,0,10,0
    
                        if rc.pt_in_rect? pt
                            self.light_adj.val=((pt.x-rc.left)*(255.0/rc.width)).to_i
                        else
                            if pt.x<=rc.left
                                self.light_adj.val=0
                            else
                                self.light_adj.val=255
                            end
                        end
                        self.parent_win.val.win_dirty.val= true
                    end
                                          
                }    

            }
        }

    }
  
    new_win(frm) {|win|
        win.align_type.val=AlignTypeClient
        #win.align_size.val=200
        new_win(win,CWin,:canvas){|win|
            win.align_type.val=AlignTypeClient
        }
    
        prop=new_prop_win(win,cmd_line,CWinProp,:cmd_line){|prop|
            #命令行
            prop.align_type.val=AlignTypeBottom
            prop.align_size.val=AlignSizeToTextHeight
            def prop.on_msg_lb_down(flags,pt,win)

                if self != $edit_win
                    self.begin_edit
                else
                    super
                end
                

            end
            def prop.end_edit(update=true)
                super
                return if $edit_win
                self.begin_edit        
                    
            end
        }

        
        pw=new_win(win,CWinCmdLineHistory,:cmd_line_history){|win|
            win.align_type.val=AlignTypeBottom
            win.align_size.val=300
            def win.can_child_render_board?(child)
                false
            end
        }


    }

  end  
end

new_obj(CApp)

p "程序正常结束"