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
 

aio_require 'main'
 
 
class CApp
 
  
  def init_app
    #begin 定义属性's
 






    #定义UI

 
	frm=main_frm.val
	#$hwin=NewHFrm frm.win32_handle.val

	new_win(frm) { |win|
 		win.align_size.val=AlignSizeToTextHeight

 		win.name=:xxx

		#new_win(win) {|win|#main bar

			#win.align_type.val=AlignTypeClient
			win.childs_align_type.val=AlignTypeRight

			new_win(win,CWinFrameTitleBar) {|win| 
				#main frame title bar
 
				win.align_type.val=AlignTypeClient
				win.title.val="AIO (v0.0.0)"
 

			}
 
			new_btns(win,FunWinClose,FunWinMaximize,FunWinMinimize)
			 
			win.childs_align_type.val=AlignTypeLeft
			#new_btns(win,FunWinClose,FunWinMaximize,FunWinMinimize)
			 
		#}
	}
 
	new_win(frm) {|win|#status bar
		win.align_type.val=AlignTypeBottom
		win.align_size.val=AlignSizeToTextHeight
		new_win(win,CWin,:status_bar) {|win|
			win.align_type.val=AlignTypeClient
		}

 
	}
 
  end  
end 

 
new_obj(CApp)

p "程序正常结束"
 