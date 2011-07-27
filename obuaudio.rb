#! /usr/local/bin/ruby -w
# -*- coding: UTF-8 -*-

#
# 调用obu_maint.mk_arm_audioidx,将生成的语音索引文件与客户端本地目录比较,产生索引与差异.
#
require 'date'
require 'fileutils'
require 'oci8'

load 'obuaudio.conf'
in_taskid       = AudioConfigure::OPTIONS[:task]
in_directory    = AudioConfigure::OPTIONS[:directory]
in_file_extname = AudioConfigure::OPTIONS[:ext]

def get_req_filelist(p_dir, p_ext)
  filelist = []
  # Loop file in directory.
  Dir.foreach(p_dir) do |a_file|
    filelist << a_file if a_file.end_with? p_ext
  end
  filelist
end

def get_oci_link
  tnsnames = '(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 172.30.215.104)(PORT = 1521)))(CONNECT_DATA =(SERVICE_NAME = DPDB)(INSTANCE_NAME = DPDB2)))'
  OCI8.new('obuer', 'obuer', tnsnames)
end

def main_swapper
  connection = get_oci_link
  yield connection
  connection.logoff
end

# main
main_swapper do |connection|
  file_list     = get_req_filelist in_directory, in_file_extname
  now_str       = Time.now.strftime('%Y%m%d_%H%M%S')
  out_directory = File.join(in_directory, now_str)
  outfile_diff  = "diff_#{now_str}.txt"
  outfile       = "audio.idx_#{now_str}.txt"

  if File.exist?(in_directory)
    Dir.chdir(in_directory) do |path|
      Dir.mkdir(now_str)
      query = "select merge_content from table(obu_maint.merge_task_audio(:i_taskid))"

      templist = []
      File.open(File.join(out_directory, outfile), 'w+') do |handle|
        connection.exec(query, in_taskid) do |rows|
          rows.each do |merge_content|
            # Inbound audio file.
            merge_content.read.to_s.each_line do |line|
              handle.puts line # write to outfile
              pos = line.index('=')
              templist << line[pos+1..-1].strip.split('+') if pos # split filename to templist
            end if merge_content && merge_content.size > 1

          end
        end
      end

      File.open(File.join(out_directory, outfile_diff), 'w+') do |file|
        for one_diff in templist.flatten.uniq - file_list
          file.puts one_diff
        end
      end

      for one_file in templist.flatten.uniq & file_list
        FileUtils.copy_file(one_file, File.join(out_directory, one_file))
      end
    end
  else
    puts "Error: #{in_directory} not exist."
  end
end