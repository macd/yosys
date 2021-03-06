/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include "kernel/yosys.h"
#include "kernel/sigtools.h"
#include "kernel/mem.h"

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct OptMemPass : public Pass {
	OptMemPass() : Pass("opt_mem", "optimize memories") { }
	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    opt_mem [options] [selection]\n");
		log("\n");
		log("This pass performs various optimizations on memories in the design.\n");
		log("\n");
	}
	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing OPT_MEM pass (optimize memories).\n");

		size_t argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			// if (args[argidx] == "-nomux") {
			// 	mode_nomux = true;
			// 	continue;
			// }
			break;
		}
		extra_args(args, argidx, design);

		int total_count = 0;
		for (auto module : design->selected_modules()) {
			SigMap sigmap(module);
			FfInitVals initvals(&sigmap, module);
			for (auto &mem : Mem::get_selected_memories(module)) {
				bool changed = false;
				for (auto &port : mem.wr_ports) {
					if (port.en.is_fully_zero()) {
						port.removed = true;
						changed = true;
						total_count++;
					}
				}
				if (changed) {
					mem.emit();
				}

				if (mem.wr_ports.empty() && mem.inits.empty()) {
					// The whole memory array will contain
					// only State::Sx, but the embedded read
					// registers could have reset or init values.
					// They will probably be optimized away by
					// opt_dff later.
					for (int i = 0; i < GetSize(mem.rd_ports); i++) {
						mem.extract_rdff(i, &initvals);
						auto &port = mem.rd_ports[i];
						module->connect(port.data, Const(State::Sx, GetSize(port.data)));
					}
					mem.remove();
					total_count++;
				}
			}
		}

		if (total_count)
			design->scratchpad_set_bool("opt.did_something", true);
		log("Performed a total of %d transformations.\n", total_count);
	}
} OptMemPass;

PRIVATE_NAMESPACE_END
