module main

import os
#flag windows -I C:\vlangnvmbr
#flag windows -L C:\vlangnvmbr
#flag -llibchatllm
#include "libchatllm.h"

@[typedef]
struct C.PrintCallback {
	user_data voidptr
	print_type int
	utf8_str &char
}

@[typedef]
struct C.EndCallback {
	user_data voidptr
}

fn C.chatllm_create() voidptr
fn C.chatllm_append_param(obj voidptr, param &char)
fn C.chatllm_start(obj voidptr, print_callback fn (voidptr, int, &char), end_callback fn (voidptr), user_data voidptr) int
fn C.chatllm_set_gen_max_tokens(obj voidptr, gen_max_tokens int)
fn C.chatllm_restart(obj voidptr, sys_prompt &char)
fn C.chatllm_user_input(obj voidptr, input &char) int
fn C.chatllm_set_ai_prefix(obj voidptr, prefix &char) int
fn C.chatllm_tool_input(obj voidptr, input &char) int
fn C.chatllm_tool_completion(obj voidptr, completion &char) int
fn C.chatllm_text_tokenize(obj voidptr, text &char) int
fn C.chatllm_text_embedding(obj voidptr, text &char) int
fn C.chatllm_qa_rank(obj voidptr, question &char, answer &char) int
fn C.chatllm_rag_select_store(obj voidptr, store_name &char) int
fn C.chatllm_abort_generation(obj voidptr)
fn C.chatllm_show_statistics(obj voidptr)
fn C.chatllm_save_session(obj voidptr, file_name &char) int
fn C.chatllm_load_session(obj voidptr, file_name &char) int

enum PrintType {
	print_chat_chunk = 0
	println_meta = 1
	println_error = 2
	println_ref = 3
	println_rewritten_query = 4
	println_history_user = 5
	println_history_ai = 6
	println_tool_calling = 7
	println_embedding = 8
	println_ranking = 9
	println_token_ids = 10
}

fn chatllm_print(user_data voidptr, print_type int, utf8_str &char) {
	unsafe {
		match PrintType(print_type) {
			.print_chat_chunk {
				print(cstring_to_vstring(utf8_str))
			}
			else {
				println(cstring_to_vstring(utf8_str))
			}
		}
	}
}

fn chatllm_end(user_data voidptr) {
	println('')
}

fn main() {
	obj := C.chatllm_create()
	args := os.args
	for arg in args[1..] {
		C.chatllm_append_param(obj, arg.str)
	}

	r := C.chatllm_start(obj, chatllm_print, chatllm_end, voidptr(0))
	if r != 0 {
		println('>>> chatllm_start error: $r')
		return
	}

	mut user_input_result := 0
	for {
		print('You  > ')
		input := os.input('')
		if input.len == 0 {
			continue
		}

		print('A.I. > ')
		user_input_result = C.chatllm_user_input(obj, input.str)
		if user_input_result != 0 {
			println('>>> chatllm_user_input error: $user_input_result')
			break
		}
	}
}