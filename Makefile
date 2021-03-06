##########################################################################
#                                                                        #
#  The Why platform for program certification                            #
#                                                                        #
#  Copyright (C) 2002-2011                                               #
#                                                                        #
#    Jean-Christophe FILLIATRE, CNRS & Univ. Paris-sud 11                #
#    Claude MARCHE, INRIA & Univ. Paris-sud 11                           #
#    Yannick MOY, Univ. Paris-sud 11                                     #
#    Romain BARDOU, Univ. Paris-sud 11                                   #
#                                                                        #
#  Secondary contributors:                                               #
#                                                                        #
#    Thierry HUBERT, Univ. Paris-sud 11  (former Caduceus front-end)     #
#    Nicolas ROUSSET, Univ. Paris-sud 11 (on Jessie & Krakatoa)          #
#    Ali AYAD, CNRS & CEA Saclay         (floating-point support)        #
#    Sylvie BOLDO, INRIA                 (floating-point support)        #
#    Jean-Francois COUCHOT, INRIA        (sort encodings, hyps pruning)  #
#    Mehdi DOGGUY, Univ. Paris-sud 11    (Why GUI)                       #
#                                                                        #
#  This software is free software; you can redistribute it and/or        #
#  modify it under the terms of the GNU Lesser General Public            #
#  License version 2.1, with the special exception on linking            #
#  described in file LICENSE.                                            #
#                                                                        #
#  This software is distributed in the hope that it will be useful,      #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  #
#                                                                        #
##########################################################################

WHYLIB=./lib
VERBOSEMAKE ?= no

ifeq ($(VERBOSEMAKE),yes)
 QUIET =
else
 QUIET = yes
endif

# where to install the binaries
DESTDIR =
prefix=.
datarootdir=${prefix}/share
exec_prefix=${prefix}
BINDIR=$(DESTDIR)${exec_prefix}/bin
LIBDIR=$(DESTDIR)${exec_prefix}/lib

EXE=
STRIP=

# where to install the man page
MANDIR=$(DESTDIR)${datarootdir}/man

# other variables
OCAMLC   = ocamlc.opt
OCAMLOPT = ocamlfind ocamlopt.opt -linkpkgs -package ocamlgraph
OCAMLOPT = ocamlfind opt -linkpkg -package ocamlgraph
OCAMLDEP = ocamldep.opt
OCAMLLEX = ocamllex.opt
OCAMLYACC= ocamlyacc
OCAMLDOC = ocamldoc.opt
OCAMLLIB = /home/ghasshee/.opam/4.12.0/lib/ocaml
OCAMLBEST= opt
OCAMLVERSION = 4.12.0
CAMLP4   = 

INCLUDES = -I src -I jc -I c -I java -I intf -I tools -I mix -I ml
BFLAGS   = -w Z -warn-error A -dtypes -g $(INCLUDES)  -I +threads 
OFLAGS   = -w Z -warn-error A -dtypes $(INCLUDES)  -I +threads 

LCFLAGS = -L/usr/lib -L/usr/local/lib/ocaml

APRONLIB = 
APRONLIBS = 
APRONBYTLIBS = $(APRONLIBS:.cmxa=.cma)

FRAMAC= no

ifeq ($(FRAMAC),yes)
JESSIE_PLUGIN_BYTE= jessie_plugin.byte
JESSIE_PLUGIN_OPT= jessie_plugin.opt
JESSIE_PLUGIN_BEST= jessie_plugin.$(OCAMLBEST)
.PHONY: $(JESSIE_PLUGIN_BYTE) $(JESSIE_PLUGIN_OPT)
endif

enable_local=no

ATPLIB = -I atp

COQC7  = coqc -v7
COQC8  = coqc
COQDEP = coqdep
COQLIB = "/nix/store/vdib43za3avsmmllvdc44xj8cajxcc18-coq-8.13.2/lib/coq"
COQVER = v8.1

VO7= lib/coq-v7/WhyInt.vo lib/coq-v7/WhyArrays.vo  lib/coq-v7/WhyBool.vo \
     lib/coq-v7/WhyTuples.vo  lib/coq-v7/WhyPermut.vo \
     lib/coq-v7/WhySorted.vo  lib/coq-v7/Why.vo     lib/coq-v7/WhyReal.vo \
     lib/coq-v7/WhyExn.vo lib/coq-v7/WhyCoqCompat.vo \
     lib/coq-v7/WhyLemmas.vo  lib/coq-v7/WhyTactics.vo lib/coq-v7/WhyCM.vo

V7FILES=$(VO7:.vo=.v)

VO8= lib/coq/WhyInt.vo lib/coq/WhyArrays.vo  lib/coq/WhyBool.vo \
     lib/coq/WhyTuples.vo  lib/coq/WhyPermut.vo lib/coq/WhyCoqCompat.vo \
     lib/coq/WhySorted.vo  \
     lib/coq/WhyExn.vo lib/coq/WhyLemmas.vo  lib/coq/WhyTactics.vo \
     lib/coq/WhyPrelude.vo lib/coq/WhyCM.vo lib/coq/Why.vo lib/coq/WhyReal.vo \
      \
     lib/coq/jessie_why.vo \
     

V8FILES=$(VO8:.vo=.v)

PVSFILES = lib/pvs/why.pvs lib/pvs/jessie.pvs lib/pvs/whyfloat.pvs
PVSLIB = /lib

GENERATED = src/version.ml src/rc.ml src/xml.ml \
	    src/lexer.ml src/parser.mli \
            src/parser.ml src/linenum.ml \
            jc/numconst.ml jc/jc_stdlib.ml \
	    jc/jc_lexer.ml jc/jc_parser.mli jc/jc_parser.ml \
	    jc/jc_ai.ml \
	    java/java_parser.mli java/java_parser.ml java/java_lexer.ml \
	    ml/parsing/parser.mli ml/parsing/parser.ml ml/parsing/lexer.ml \
	    ml/parsing/linenum.ml \
	    c/cversion.ml c/clexer.ml c/cparser.ml c/cparser.mli \
	    c/cllexer.ml c/clparser.ml c/clparser.mli c/cpp.ml c/cconst.ml \
	    intf/hilight.ml intf/whyhilight.ml \
	    intf/tagsplit.ml intf/config.ml \
	    tools/why2html.ml  tools/cvcl_split.ml \
	    tools/simplify_split.ml tools/smtlib_split.ml tools/rv_split.ml \
	    tools/zenon_split.ml tools/ergo_split.ml \
	    tools/simplify_lexer.ml tools/simplify_parser.mli \
	    tools/simplify_parser.ml \
	    tools/toolstat_lex.ml \
	    tools/toolstat_pars.ml tools/toolstat_pars.mli \
	    mix/mix_lexer.ml mix/mix_parser.mli mix/mix_parser.ml \
	    lib/why3/why3.conf


# main targets
##############

BINARY=bin/why.$(OCAMLBEST)
WHYCONFIG=bin/why-config.$(OCAMLBEST)
JESSIE=bin/jessie.$(OCAMLBEST)
KRAKATOA=bin/krakatoa.$(OCAMLBEST)
JESSICA=bin/jessica.$(OCAMLBEST)
STATICBINARY=bin/why.static
WHY2HTML=bin/why2html.$(OCAMLBEST)
RVMERGE=bin/rv_merge.$(OCAMLBEST)
DP=bin/why-dp.$(OCAMLBEST)
CPULIMIT=bin/why-cpulimit
WHYOBFUSCATOR=bin/why-obfuscator.$(OCAMLBEST)
WHYSTAT=bin/why-stat.$(OCAMLBEST)
TOOLSTAT=bin/tool-stat.$(OCAMLBEST)
SIMPLIFY2WHY=bin/simplify2why.$(OCAMLBEST)
REGTEST=regtest.$(OCAMLBEST)

TOOLS=$(WHY2HTML) $(DP) $(CPULIMIT) $(RVMERGE) $(WHYOBFUSCATOR) \
      $(SIMPLIFY2WHY) $(WHYSTAT) $(TOOLSTAT)

ifeq ($(OCAMLBEST),opt)
JCLIB=jc/jc.cmo jc/jc.cmx jc/jc.o
else
JCLIB=jc/jc.cmo
endif

all: all-without-frama-c-plugin .depend $(JESSIE_PLUGIN_BEST)

all-without-frama-c-plugin: $(BINARY) $(WHYCONFIG) check $(JESSIE) $(KRAKATOA) coq-yes pvs-no $(TOOLS) gwhy-no $(JCLIB) $(REGTEST)

# refrain parallel make (-j nn) from starting ocaml compilation too early
*.cm*: .depend

opt: bin/why.opt bin/gwhy.opt bin/jessie.opt bin/krakatoa.opt \
	$(JESSIE_PLUGIN_OPT)
byte: bin/why.byte bin/gwhy.byte bin/jessie.byte bin/krakatoa.byte \
	$(JESSIE_PLUGIN_BYTE)

.PHONY: check

WHYLIBS=lib/why/bool.why lib/why/integer.why lib/why/divisions.why \
	lib/why/real.why lib/why/arrays.why \
	lib/why/jessie.why lib/why/jessie_bitvectors.why \
	lib/why/mybag.why \
	lib/why/mix.why \
	lib/why/floats_common.why lib/why/floats_strict.why \
	lib/why/floats_full.why lib/why/floats_multi_rounding.why 



PRELUDE=lib/why/prelude.why $(WHYLIBS)

# sanity check: the prelude files do typecheck
check: $(BINARY) $(PRELUDE)
	WHYLIB=lib $(BINARY) --no-pervasives -tc lib/why/prelude.why
	for f in $(WHYLIBS) ; do \
		WHYLIB=lib $(BINARY) -tc $$f; \
	done

#lib/coq/float_common_Gappa_why.v: lib/why/floats_common.why
#	WHYLIB=lib $(BINARY) -tc -output $@ $<

# why-config
WHYCONFIGCMO = src/rc.cmo src/version.cmo tools/dpConfig.cmo tools/whyConfig.cmo
WHYCONFIGCMX = $(WHYCONFIGCMO:.cmo=.cmx)

bin/why-config.opt: $(WHYCONFIGCMX)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) $(OFLAGS) -o $@ unix.cmxa str.cmxa $^
	$(STRIP) $@

bin/why-config.byte: $(WHYCONFIGCMO)
	# $(if $(QUIET),@echo 'Linking  $@' &&)
	$(OCAMLC) $(BFLAGS) -o $@ unix.cma str.cma $^


# why
CMO_EXPORT =  src/lib.cmo src/rc.cmo src/loc.cmo \
	   src/ident.cmo src/print_real.cmo  \
	   src/effect.cmo src/pp.cmo src/option_misc.cmo \
	   src/parser.cmo src/lexer.cmo src/report.cmo \
           src/explain.cmo 	\
	   src/xml.cmo src/project.cmo

CMO = src/lib.cmo src/rc.cmo tools/dpConfig.cmo \
      src/version.cmo src/options.cmo src/linenum.cmo src/loc.cmo \
	   src/ident.cmo src/print_real.cmo  \
	   src/effect.cmo src/pp.cmo src/option_misc.cmo src/misc.cmo 	\
	   src/parser.cmo src/lexer.cmo src/report.cmo \
           src/env.cmo src/mapenv.cmo src/rename.cmo src/explain.cmo src/util.cmo \
           src/ltyping.cmo src/typing.cmo src/wp.cmo src/fastwp.cmo \
           src/monad.cmo src/mlize.cmo src/red.cmo src/vcg.cmo \
	   src/predDefExpansor.cmo src/encoding_mono_inst.cmo \
	   src/encoding_rec.cmo src/encoding_pred.cmo src/encoding_strat.cmo \
	   src/encoding_mono.cmo src/monomorph.cmo src/encoding.cmo \
	   src/pvs.cmo src/hol4.cmo src/gappa.cmo \
	   src/holl.cmo src/harvey.cmo src/simplify.cmo  \
           src/regen.cmo src/mizar.cmo src/smtlib.cmo src/coq.cmo \
	   src/zenon.cmo src/z3.cmo src/cvcl.cmo tools/calldp.cmo \
	   src/xml.cmo src/project.cmo \
	   src/why3_kw.cmo src/why3.cmo src/pretty.cmo  \
           src/unionfind.cmo src/theoryreducer.cmo \
           src/theory_filtering.cmo src/hypotheses_filtering.cmo \
           src/dispatcher.cmo src/isabelle.cmo src/ocaml.cmo  \
	   src/main.cmo
CMX      = $(CMO:.cmo=.cmx)

bin/why.opt: $(CMX) src/why.cmx
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) $(OFLAGS) -o $@ unix.cmxa str.cmxa nums.cmxa graph.cmxa $^
	# $(STRIP) $@

bin/why.byte: $(CMO) src/why.cmo
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLC) $(BFLAGS) -o $@ unix.cma str.cma nums.cma graph.cma $^

bin/why.static: $(CMX) src/why.cmx
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) -cclib -static $(OFLAGS) -o $@ unix.cmxa str.cmxa nums.cmxa graph.cmxa $^
	$(STRIP) $@

bin/top: $(CMO)
	ocamlmktop $(BFLAGS) -o $@ str.cma $^

# world-why-web
# WWEBCMO = src/lib.cmo src/rc.cmo src/version.cmo src/options.cmo src/loc.cmo\
# 	 src/ident.cmo  src/effect.cmo src/pp.cmo \
# 	src/option_misc.cmo\
# 	src/misc.cmo src/parser.cmo src/lexer.cmo src/report.cmo\
# 	 src/env.cmo src/rename.cmo src/explain.cmo src/util.cmo src/xml.cmo\
# 	src/project.cmo src/pretty.cmo src/wserver.cmo src/whyweb.cmo
# WWEBCMX = $(WWEBCMO:.cmo=.cmx)

# src/wserver.ml: src/wserver.ml4
# 	camlp4r pa_ifdef.cmo pr_o.cmo -DUNIX -DNOFORK  -impl $^ -o $@

# bin/whyweb.opt: $(WWEBCMX)
# 	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) \
# 	      $(OFLAGS) -thread -o $@ str.cmxa unix.cmxa threads.cmxa $^
# 	$(STRIP)    $@


# jessie
JCCML_EXPORT = src/why3_kw.ml jc/output.ml \
	jc/jc_common_options.ml jc/jc_stdlib.ml \
	jc/jc_envset.ml jc/jc_region.ml jc/jc_fenv.ml \
	jc/jc_constructors.ml \
	jc/jc_pervasives.ml jc/jc_iterators.ml jc/jc_type_var.ml \
	jc/jc_output_misc.ml jc/jc_poutput.ml jc/jc_output.ml jc/jc_noutput.ml
JCCMO_EXPORT = $(CMO_EXPORT) $(JCCML_EXPORT:.ml=.cmo)
JCCMX_EXPORT = $(JCCMO_EXPORT:.cmo=.cmx)
JCCMI_EXPORT = jc/jc_ast.cmi jc/jc_env.cmi jc/jc.cmi $(JCCMO_EXPORT:.cmo=.cmi)

JCCMO = src/version.cmo \
	 $(JCCMO_EXPORT) \
	jc/jc_options.cmo \
	jc/jc_name.cmo \
	jc/jc_struct_tools.cmo \
	jc/jc_norm.cmo jc/jc_typing.cmo \
	jc/numconst.cmo \
	jc/jc_parser.cmo jc/jc_lexer.cmo \
	jc/jc_separation.cmo \
	jc/jc_callgraph.cmo \
	jc/jc_effect.cmo \
	jc/jc_ai.cmo \
	jc/jc_interp_misc.cmo jc/jc_invariants.cmo \
	jc/jc_pattern.cmo \
	jc/jc_frame_notin.cmo \
	jc/jc_interp.cmo \
	jc/jc_frame.cmo \
	jc/jc_make.cmo jc/jc_main.cmo
JCCMX = $(JCCMO:.cmo=.cmx)

jc/jc_stdlib.ml: jc/jc_stdlib_lt312.ml jc/jc_stdlib_ge312.ml jc/jc_stdlib_ge40.ml
	rm -f $@
	case $(OCAMLVERSION) in \
         3.0*|3.10*|3.11*) cp jc/jc_stdlib_lt312.ml $@ ;; \
         3.12*) cp jc/jc_stdlib_ge312.ml $@ ;; \
         4.0*) cp jc/jc_stdlib_ge40.ml $@ ;; \
        esac
	cp jc/jc_stdlib_ge40.ml jc/jc_stdlib.ml 
	chmod -w $@

$(JCCMX_EXPORT): OFLAGS:=$(OFLAGS) -for-pack Jc

atp/atp.cmx:
	make -C atp atp.cmx

atp/atp.cmo:
	make -C atp atp.cmo

jc/jc.cmi jc/jc.cmo: $(JCCMO_EXPORT)
	$(OCAMLC) $(BFLAGS) -pack -o jc/jc.cmo src/ast.cmi $^

jc/jc.cmx jc/jc.o: $(JCCMX_EXPORT)
	$(OCAMLOPT) $(OFLAGS) -pack -o $@ src/ast.cmi $^

ppc: jc/jc.cmi jc/jc.cmo jc/jc.cmx

bin/jessie.opt: $(JCCMX)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) $(OFLAGS) $(APRONLIB) $(APRONLIBS) $(ATPLIB) -o $@ \
		unix.cmxa str.cmxa nums.cmxa graph.cmxa $^
	$(STRIP)    $@

bin/jessie.byte: $(JCCMO)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLC) $(BFLAGS) $(APRONLIB) $(APRONBYTLIBS) $(ATPLIB) -o $@ \
		unix.cma str.cma nums.cma graph.cma $^

# Frama-C plugin for Jessie
ifeq ($(FRAMAC),yes)
JESSIE_PLUGIN_PATH=frama-c-plugin
$(JESSIE_PLUGIN_BYTE): jc/jc.cmo $(JCCMO) $(CMO)
	$(MAKE) -C $(JESSIE_PLUGIN_PATH) depend
	$(MAKE) -C $(JESSIE_PLUGIN_PATH) Jessie.cma

$(JESSIE_PLUGIN_OPT): $(JCLIB) $(JCCMX) $(CMX)
	$(MAKE) -C $(JESSIE_PLUGIN_PATH) depend
	$(MAKE) -C $(JESSIE_PLUGIN_PATH)

install:
	$(MAKE) -C $(JESSIE_PLUGIN_PATH) install
clean::
	$(MAKE) -C $(JESSIE_PLUGIN_PATH) clean
endif

# krakatoa
# CAUTION! NEVER ADD jc/jc_options.cmo INTO THIS LIST
KCMO = src/lib.cmo src/version.cmo \
	src/loc.cmo src/pp.cmo src/option_misc.cmo \
	src/why3_kw.cmo jc/output.cmo jc/jc_stdlib.cmo \
	jc/jc_envset.cmo jc/jc_common_options.cmo \
	jc/jc_region.cmo jc/jc_fenv.cmo jc/numconst.cmo jc/jc_constructors.cmo \
	jc/jc_pervasives.cmo jc/jc_name.cmo \
	jc/jc_iterators.cmo jc/jc_type_var.cmo jc/jc_output_misc.cmo \
	jc/jc_poutput.cmo jc/jc_output.cmo jc/jc_noutput.cmo jc/output.cmo \
	java/java_options.cmo java/java_pervasives.cmo \
	java/java_abstract.cmo \
	java/java_parser.cmo java/java_lexer.cmo java/java_syntax.cmo \
	java/java_typing.cmo java/java_callgraph.cmo \
	java/java_analysis.cmo java/java_interp.cmo \
	java/java_main.cmo
KCMX = $(KCMO:.cmo=.cmx)

bin/krakatoa.opt: $(KCMX)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) $(OFLAGS) -o $@ \
		unix.cmxa nums.cmxa graph.cmxa $^
	$(STRIP)    $@

bin/krakatoa.byte: $(KCMO)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLC) $(BFLAGS) -o $@ \
	 	 unix.cma nums.cma graph.cma $^


# jessica

JESSICACMO = ml/ml_misc.cmo ml/ml_options.cmo ml/ml_pervasives.cmo \
	ml/ml_env.cmo ml/ml_constant.cmo ml/ml_type.cmo ml/ml_pattern.cmo \
	ml/ml_interp.cmo ml/ml_main.cmo
JESSICACMI = ml/ml_options.cmi ml/ml_env.cmi ml/ml_pattern.cmi

JESSICACMX = $(JESSICACMO:.cmo=.cmx)
MLCMO = src/loc.cmo src/pp.cmo src/option_misc.cmo jc/jc_stdlib.cmo \
	jc/jc_envset.cmo jc/jc_common_options.cmo \
	jc/jc_region.cmo jc/jc_fenv.cmo jc/numconst.cmo jc/jc_constructors.cmo \
	jc/jc_pervasives.cmo jc/jc_name.cmo \
	jc/jc_iterators.cmo jc/jc_output_misc.cmo \
	jc/jc_poutput.cmo jc/jc_output.cmo jc/jc_noutput.cmo \
	$(JESSICACMO)
MLCMX = $(MLCMO:.cmo=.cmx)

# The following files must be compiled with different includes and with the
# -for-pack option
OCAMLCMO = ml/utils/config.cmo ml/utils/clflags.cmo \
	ml/utils/misc.cmo ml/utils/terminfo.cmo ml/utils/warnings.cmo \
	ml/utils/consistbl.cmo ml/utils/tbl.cmo \
	ml/parsing/linenum.cmo ml/parsing/location.cmo \
	ml/parsing/syntaxerr.cmo \
	ml/parsing/longident.cmo ml/parsing/parser.cmo ml/parsing/lexer.cmo \
	ml/typing/ident.cmo ml/typing/path.cmo ml/typing/types.cmo \
	ml/typing/oprint.cmo ml/typing/btype.cmo ml/typing/predef.cmo \
	ml/typing/datarepr.cmo ml/typing/subst.cmo ml/typing/env.cmo \
	ml/typing/primitive.cmo ml/typing/ctype.cmo ml/typing/printtyp.cmo \
	ml/typing/includeclass.cmo ml/typing/parmatch.cmo \
	ml/typing/stypes.cmo ml/typing/typedtree.cmo \
	ml/typing/includecore.cmo ml/typing/typetexp.cmo ml/typing/mtype.cmo \
	ml/typing/typedecl.cmo ml/typing/unused_var.cmo \
	ml/typing/typecore.cmo ml/typing/typeclass.cmo \
	ml/typing/includemod.cmo ml/typing/typemod.cmo
OCAMLCMINOIMPL = ml/parsing/asttypes.cmi ml/parsing/parsetree.cmi \
	ml/typing/outcometree.cmi
OCAMLCMI = $(OCAMLCMINOIMPL) ml/utils/config.cmi ml/utils/clflags.cmi \
	ml/utils/misc.cmi ml/utils/terminfo.cmi ml/utils/warnings.cmi \
	ml/utils/consistbl.cmi ml/utils/tbl.cmi \
	ml/parsing/linenum.cmi ml/parsing/location.cmi ml/parsing/parser.cmi \
	ml/parsing/lexer.cmi ml/parsing/longident.cmi ml/parsing/syntaxerr.cmi \
	ml/typing/btype.cmi ml/typing/ctype.cmi ml/typing/datarepr.cmi \
	ml/typing/env.cmi ml/typing/ident.cmi ml/typing/includeclass.cmi \
	ml/typing/includecore.cmi ml/typing/includemod.cmi ml/typing/mtype.cmi \
	ml/typing/oprint.cmi ml/typing/parmatch.cmi \
	ml/typing/path.cmi ml/typing/predef.cmi ml/typing/primitive.cmi \
	ml/typing/printtyp.cmi ml/typing/stypes.cmi ml/typing/subst.cmi \
	ml/typing/typeclass.cmi ml/typing/typecore.cmi ml/typing/typedecl.cmi \
	ml/typing/typedtree.cmi ml/typing/typemod.cmi ml/typing/types.cmi \
	ml/typing/typetexp.cmi ml/typing/unused_var.cmi
OCAMLCMX = $(OCAMLCMO:.cmo=.cmx)

MLINCLUDES = -I ml/utils -I ml/parsing -I ml/typing

# The following dependencies are not found by ocamldep because there is no
# file ml/ml_ocaml.ml or ml/ml_ocaml.mli.
$(JESSICACMO): ml/ml_ocaml.cmo
$(JESSICACMX): ml/ml_ocaml.cmx
$(JESSICACMI): ml/ml_ocaml.cmo

ml/parsing/%.cmi: ml/parsing/%.mli
	$(if $(QUIET),@echo 'Ocamlc   $@' &&) \
		$(OCAMLC) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/parsing/$*.mli

ml/parsing/%.cmx: ml/parsing/%.ml
	$(if $(QUIET),@echo 'Ocamlopt $@' &&) \
		$(OCAMLOPT) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/parsing/$*.ml

ml/parsing/%.cmo: ml/parsing/%.ml
	$(if $(QUIET),@echo 'Ocamlc   $@' &&) \
		$(OCAMLC) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/parsing/$*.ml

ml/typing/%.cmi: ml/typing/%.mli
	$(if $(QUIET),@echo 'Ocamlc   $@' &&) \
		$(OCAMLC) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/typing/$*.mli

ml/typing/%.cmx: ml/typing/%.ml
	$(if $(QUIET),@echo 'Ocamlopt $@' &&) \
		$(OCAMLOPT) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/typing/$*.ml

ml/typing/%.cmo: ml/typing/%.ml
	$(if $(QUIET),@echo 'Ocamlc   $@' &&) \
		$(OCAMLC) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/typing/$*.ml

ml/utils/%.cmi: ml/utils/%.mli
	$(if $(QUIET),@echo 'Ocamlc   $@' &&) \
		$(OCAMLC) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/utils/$*.mli

ml/utils/%.cmx: ml/utils/%.ml
	$(if $(QUIET),@echo 'Ocamlopt $@' &&) \
		$(OCAMLOPT) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/utils/$*.ml

ml/utils/%.cmo: ml/utils/%.ml
	$(if $(QUIET),@echo 'Ocamlc   $@' &&) \
		$(OCAMLC) -c $(MLINCLUDES) -for-pack Ml_ocaml ml/utils/$*.ml

ml/ml_ocaml.cmx: $(OCAMLCMINOIMPL) $(OCAMLCMX)
	$(if $(QUIET),@echo 'Ocamlopt $@' &&) \
		$(OCAMLOPT) -c $(MLINCLUDES) -pack -o $@ $^

ml/ml_ocaml.cmo: $(OCAMLCMINOIMPL) $(OCAMLCMO)
	$(if $(QUIET),@echo 'Ocamlc   $@' &&) \
		$(OCAMLC) -c $(MLINCLUDES) -pack -o $@ $^

bin/jessica.opt: ml/ml_ocaml.cmx $(MLCMX)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) $(OFLAGS) -o $@ \
		unix.cmxa nums.cmxa graph.cmxa $^
	$(STRIP)    $@

bin/jessica.byte: ml/ml_ocaml.cmo $(MLCMO)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLC) $(BFLAGS) -o $@ \
	 	 unix.cma nums.cma graph.cma $^


# demixify

MIXCMO=src/pp.cmo mix/mix_parser.cmo mix/mix_lexer.cmo mix/mix_cfg.cmo \
       mix/mix_seq.cmo mix/mix_interp.cmo mix/mix_main.cmo
MIXCMX = $(MIXCMO:.cmo=.cmx)

bin/demixify.opt: $(MIXCMX)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) $(OFLAGS) -o $@ $^
	$(STRIP)    $@

bin/demixify.byte: $(MIXCMO)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLC) $(BFLAGS) -o $@ $^

# graphical interface
WVCMO = $(CMO) intf/navig.cmo intf/hilight.cmo intf/viewer.cmo
WVCMX = $(WVCMO:.cmo=.cmx)

bin/why-viewer.opt: $(WVCMX)
	$(OCAMLOPT) $(OFLAGS) -o $@ unix.cmxa gramlib.cmxa str.cmxa lablgtk.cmxa $^
	$(STRIP) $@

bin/why-viewer.byte: $(WVCMO)
	$(OCAMLC) $(BFLAGS) -o $@ unix.cma gramlib.cma str.cma lablgtk.cma $^

# graphical interface
GCMO = $(CMO) intf/colors.cmo intf/tags.cmo intf/tools.cmo intf/tagsplit.cmo\
	      intf/astprinter.cmo intf/astnprinter.cmo intf/astpprinter.cmo\
	      intf/model.cmo intf/cache.cmo intf/gConfig.cmo intf/hilight.cmo\
	      intf/whyhilight.cmo intf/pprinter.cmo intf/preferences.cmo intf/stat.cmo
GCMX = $(GCMO:.cmo=.cmx)

gwhy-yes: bin/gwhy.$(OCAMLBEST)
gwhy-no:
gwhy: bin/gwhy.$(OCAMLBEST)

bin/gwhy.opt: $(GCMX)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) $(OFLAGS) -o $@ unix.cmxa threads.cmxa nums.cmxa str.cmxa graph.cmxa lablgtk.cmxa gtkThread.cmx $^
	$(STRIP)    $@

bin/gwhy.static: $(GCMX)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLOPT) -cclib -static $(OFLAGS) -o $@ unix.cmxa threads.cmxa nums.cmxa str.cmxa graph.cmxa lablgtk.cmxa gtkThread.cmx $^
	$(STRIP)    $@

bin/gwhy.byte: $(GCMO)
	$(if $(QUIET),@echo 'Linking  $@' &&) $(OCAMLC) $(BFLAGS) -o $@ unix.cma str.cma nums.cma graph.cma lablgtk.cma threads.cma gtkThread.cmo $^

# tools
regtest.opt: tools/regtest.ml
	$(OCAMLOPT) $(OFLAGS) -thread -o $@ unix.cmxa str.cmxa threads.cmxa $^

regtest.byte: tools/regtest.ml
	$(OCAMLC) $(BFLAGS) -thread -o $@ unix.cma str.cma threads.cma $^

bin/why2html.byte: tools/why2html.ml
	$(OCAMLC) $(BFLAGS) -o $@ $^

bin/why2html.opt: tools/why2html.ml
	$(OCAMLOPT) $(OFLAGS) -o $@ $^

SIMPLIFYTOWHYCMO=src/ident.cmo src/pp.cmo \
                 tools/simplify_parser.cmo tools/simplify_lexer.cmo \
                 tools/simplify_towhy.cmo
SIMPLIFYTOWHYCMX = $(SIMPLIFYTOWHYCMO:.cmo=.cmx)

bin/simplify2why.byte: $(SIMPLIFYTOWHYCMO)
	$(OCAMLC) $(BFLAGS) -o $@ $^

bin/simplify2why.opt: $(SIMPLIFYTOWHYCMX)
	$(OCAMLOPT) $(OFLAGS) -o $@ $^

DPCMO =  src/lib.cmo tools/cvcl_split.cmo tools/simplify_split.cmo tools/smtlib_split.cmo\
        tools/zenon_split.cmo tools/ergo_split.cmo tools/rv_split.cmo \
        src/rc.cmo tools/dpConfig.cmo src/version.cmo \
	tools/calldp.cmo tools/dp.cmo
DPCMX = $(DPCMO:.cmo=.cmx)

bin/why-dp.byte: $(DPCMO)
	$(OCAMLC) $(BFLAGS) -o $@ unix.cma str.cma $^

bin/why-dp.opt: $(DPCMX)
	$(OCAMLOPT) $(OFLAGS) -o $@ unix.cmxa str.cmxa $^

bin/why-cpulimit: tools/.c
	$(CC) -o $@ $^

bin/rv_merge.byte: tools/rv_merge.ml
	$(OCAMLC) $(BFLAGS) -o $@ $^

bin/rv_merge.opt: tools/rv_merge.ml
	$(OCAMLOPT) $(OFLAGS) -o $@ $^

OBFCMO=src/pp.cmo src/loc.cmo src/ident.cmo  \
       src/parser.cmo src/lexer.cmo src/print_real.cmo \
	tools/obfuscator.cmo
OBFCMX=$(OBFCMO:.cmo=.cmx)

bin/why-obfuscator.byte: $(OBFCMO)
	$(OCAMLC) $(BFLAGS) -o $@ nums.cma $^

bin/why-obfuscator.opt: $(OBFCMX)
	$(OCAMLOPT) $(OFLAGS) -o $@ nums.cmxa $^

STATCMO=src/pp.cmo src/loc.cmo src/ident.cmo  \
        src/parser.cmo src/lexer.cmo tools/whystat.cmo
STATCMX=$(STATCMO:.cmo=.cmx)

bin/why-stat.byte: $(STATCMO)
	$(OCAMLC) $(BFLAGS) -o $@ $^

bin/why-stat.opt: $(STATCMX)
	$(OCAMLOPT) $(OFLAGS) -o $@ $^

TOOLCMO=src/loc.cmo src/pp.cmo tools/toolstat_pars.cmo \
	tools/toolstat_lex.cmo tools/toolstat.cmo
TOOLCMX=$(TOOLCMO:.cmo=.cmx)

bin/tool-stat.byte: $(TOOLCMO)
	$(OCAMLC) $(BFLAGS) -o $@ $^

bin/tool-stat.opt: $(TOOLCMX)
	$(OCAMLOPT) $(OFLAGS) -o $@ $^

bin/cadlog.opt: src/version.cmx c/cversion.cmx tools/cadlog.cmx
	$(OCAMLOPT) unix.cmxa -o $@ $^

static:: $(STATICBINARY)

ifeq ($(enable_local),no)
LIBWHY3=$(LIBDIR)/why
else
LIBWHY3=$(PWD)/lib
endif

lib/why3/why3.conf: Makefile
	printf "[main]\n" > $@
	printf "loadpath=\"$(LIBWHY3)/why3\"\n" >> $@
	printf "\n" >> $@
	printf "[prover_modifiers]\n" >> $@
	printf "name=\"Coq\"\n" >> $@
	printf "option=\"-R $(LIBWHY3)/coq Why\"\n" >> $@
	printf "driver=\"$(LIBWHY3)/why3/coq.drv\"\n" >> $@
	printf "\n"  >> $@
	printf "[editor_modifiers coqide]\n" >> $@
	printf "option=\"-R $(LIBWHY3)/coq Why\"\n" >> $@
	printf "\n"  >> $@
	printf "[editor_modifiers proofgeneral-coq]\n" >> $@
	printf "option=\"--eval \\\\\"(setq coq-load-path (cons '(\\\\\\\\\\\\\"$(LIBWHY3)/coq\\\\\\\\\\\\\" \\\\\\\\\\\\\"Why\\\\\\\\\\\\\") coq-load-path))\\\\\"\"\n"  >> $@


########
# COQ
########

coq-no:
coq-yes: coq-v8.1
coq-v7: $(VO7)
coq-v8: $(VO8)
coq-v8.1: $(VO8)

########
# PVS
########

pvs-no:
pvs-yes: $(PVSFILES)

include Version

doc/version.tex src/version.ml c/cversion.ml: Version version.sh config.status
	BINDIR=$(BINDIR) LIBDIR=$(LIBDIR) COQVER=$(COQVER) ./version.sh

lib/coq/jessie_why.v: lib/why/jessie.why $(BINARY)
	WHYLIB=lib $(BINARY) --dir lib/coq --coq-v8 -coq-preamble \
        "Require Export Reals. Require Export Why." \
        --no-coq-use-dp lib/why/jessie.why

lib/pvs/jessie_why.pvs: lib/why/jessie.why $(BINARY)
	WHYLIB=lib $(BINARY) --dir lib/pvs --pvs --pvs-preamble "IMPORTING why" lib/why/jessie.why

# bench

.PHONY: bench test

WHYVO=lib/coq/Why.vo

bench:: $(BINARY) $(WHYVO)
	cd bench; sh ./bench "../$(BINARY)"
	make -C bench fastwp.bench.ergo
	make -C examples ergo
	#cd bench/provers; sh ./bench "../../$(BINARY)"

JCBENCHLOG=jessie-bench-`date +%d-%m-%y`.log

# Claude: does not work anymore, because someone modified bench/jc/bench
# GRRRRRRRRRRRR
# jc-bench:: $(JESSIE) bin/cadlog.opt
#	(cd bench/jc; sh ./bench 2>&1) | bin/cadlog.opt -jc $(JCBENCHLOG)

jc-fast-bench:: $(JESSIE)
	make -C bench/jc -f Makefile good.bench

JCAIBENCHLOG=jessie-ai-bench-`date +%d-%m-%y`.log

jc-ai-bench:: $(JESSIE) bin/cadlog.opt
	(cd bench/jc/ai; sh ./bench 2>&1) | bin/cadlog.opt -jc $(JCAIBENCHLOG)

JAVABENCHLOG=krakatoa-bench-`date +%d-%m-%y`.log

java-bench:: $(KRAKATOA) bin/cadlog.opt
	(cd bench/java; sh ./bench 2>&1) | bin/cadlog.opt -java $(JAVABENCHLOG)

ml-bench:: $(JESSICA) $(JESSIE)
	make -C bench/ml -f Makefile good.bench

bench-pvs:: $(BINARY) $(WHYVO)
	cd bench; sh ./bench "../$(BINARY) --valid" pvs

bench-tc:: $(BINARY) $(WHYVO)
	cd bench; sh ./bench "../$(BINARY) -tc"

test:: $(BINARY) $(WHYVO)
	[ ! -f bench/test.ml ] || $(BINARY) -d -V -coq bench/test.ml

.PHONY: examples examples-c

examples:: $(BINARY) $(WHYVO)
	make -C examples check

# debugging

db debug: bin/why.byte src/logic.cmo

#src/logic.ml: src/logic.mli
#	cp -f $^ $@

# java APIs
#################

java_api:
	(cd lib/java_api ; for i in java/lang/*.java; do \
		mkdir -p `dirname ../distr_java_api/$$i` ; \
		echo "Generating $$i" ; \
		KRAKATOALIB=.. ../../$(KRAKATOA) -abstract ../distr_java_api/$$i $$i || break ; done)

# installation
##############

install: install-binary install-lib install-man install-coq-yes install-pvs-no

BINARYFILES = $(BINARY) $(WHYCONFIG) $(JESSIE) $(KRAKATOA) \
	$(WHY2HTML) $(DP) $(CPULIMIT) $(RVMERGE) bin/gwhy.$(OCAMLBEST) \
	$(WHYSTAT) $(TOOLSTAT) $(WHYOBFUSCATOR) $(SIMPLIFY2WHY)

# install-binary should not depend on $(BINARYFILES); otherwise it
# enforces the compilation of gwhy, even when lablgtk2 is not installed
install-binary:
	mkdir -p $(BINDIR)
	cp -f $(BINARY) $(BINDIR)/why$(EXE)
	cp -f $(WHYCONFIG) $(BINDIR)/why-config$(EXE)
	cp -f $(JESSIE) $(BINDIR)/jessie$(EXE)
	cp -f $(KRAKATOA) $(BINDIR)/krakatoa$(EXE)
	cp -f bin/gwhy.sh $(BINDIR)/gwhy
	cp -f $(WHY2HTML) $(BINDIR)/why2html$(EXE)
	cp -f $(DP) $(BINDIR)/why-dp$(EXE)
	cp -f $(CPULIMIT) $(BINDIR)/why-cpulimit$(EXE)
	cp -f $(RVMERGE) $(BINDIR)/rv_merge$(EXE)
	cp -f $(WHYOBFUSCATOR) $(BINDIR)/why-obfuscator$(EXE)
	cp -f $(WHYSTAT) $(BINDIR)/why-stat$(EXE)
	cp -f $(TOOLSTAT) $(BINDIR)/tool-stat$(EXE)
	cp -f $(SIMPLIFY2WHY) $(BINDIR)/simplify2why$(EXE)
	if test -f bin/gwhy.$(OCAMLBEST); then \
		cp -f bin/gwhy.$(OCAMLBEST) $(BINDIR)/gwhy-bin$(EXE); \
	fi

install-lib: $(JCLIB) lib/why3/why3.conf
	mkdir -p $(LIBDIR)/why/why
	cp -f $(PRELUDE) $(LIBDIR)/why/why
	rm -rf $(LIBDIR)/why/why3
	mkdir -p $(LIBDIR)/why/why3
	cp -f lib/why3/why3.conf lib/why3/coq.drv lib/why3/jessie3theories.why lib/why3/jessie3.mlw lib/why3/jessie3_integer.why $(LIBDIR)/why/why3
	mkdir -p $(LIBDIR)/jessie
	cp -f $(JCLIB) $(JCCMI_EXPORT) $(LIBDIR)/jessie
	cd lib; cp -rf java_api $(LIBDIR)/why
	cd lib; cp -rf javacard_api $(LIBDIR)/why
	mkdir -p $(LIBDIR)/why/images
	cp -f lib/images/*.png $(LIBDIR)/why/images
	mkdir -p $(LIBDIR)/why/emacs
	cp -f lib/emacs/why.el $(LIBDIR)/why/emacs
#	remove CVS directories
	find $(LIBDIR) -name CVS | xargs $(RM) -r

install-man:
	mkdir -p $(MANDIR)/man1
	cp -f doc/*.1 $(MANDIR)/man1

install-coq-no:
install-coq-yes: install-coq-v8.1
install-coq-v7:
	mkdir -p $(LIBDIR)/why/coq7
	cp -f $(VO7) $(LIBDIR)/why/coq7
install-coq-v8 install-coq-v8.1:
	if test -w $(COQLIB) ; then \
	  rm -f $(COQLIB)/user-contrib/Why*.v* ; \
	  rm -f $(COQLIB)/user-contrib/caduceus*.v* $(COQLIB)/user-contrib/Caduceus*.v* ; \
	  rm -f $(COQLIB)/user-contrib/jessie*.v* $(COQLIB)/user-contrib/Jessie*.v* ; \
	  mkdir -p $(COQLIB)/user-contrib/Why ; \
	  cp -f $(VO8) $(COQLIB)/user-contrib/Why ; \
	else \
	  echo "Cannot copy to Coq standard library. Add \"-R $(LIBDIR)/why/coq Why\" to Coq options." ;\
	fi
	mkdir -p $(LIBDIR)/why/coq
	cp -f $(VO8) $(LIBDIR)/why/coq

install-pvs-no:
install-pvs-yes: $(PVSFILES)
	mkdir -p $(PVSLIB)/why
	cp $(PVSFILES) $(PVSFILES:.pvs=.prf) $(PVSLIB)/why
	cp lib/pvs/top.pvs lib/pvs/pvscontext.el $(PVSLIB)/why
	@echo "======  Compiling PVS theories, this may take some time ======"
	(cd $(PVSLIB)/why ; /run/current-system/sw/bin/pvs -batch -l pvscontext.el -q -v 2 > top.out)
	@echo "======  Done compiling PVS theories ======"

install-mizar-no:
install-mizar-yes:
	mkdir -p /mml/dict
	cp lib/mizar/why.miz /mml
	cp lib/mizar/dict/why.voc /mml/dict

local-install: $(BINARY) $(WHYCONFIG) $(JESSIE) bin/gwhy.$(OCAMLBEST) byte bin/gwhy.byte
	cp $(BINARY) $$HOME/bin/why
	cp $(WHYCONFIG) $$HOME/bin/why
	cp $(JESSIE) $$HOME/bin/jessie
	if test -f bin/gwhy.$(OCAMLBEST); then \
	  cp -f bin/gwhy.$(OCAMLBEST) $$HOME/bin/gwhy; \
	fi

local: install
# local: bin/why.opt $(WHY2HTML) $(DP) $(RVMERGE) coq-yes
# 	cp -f bin/why.opt $$HOME/bin/$$OSTYPE/why
# 	cp -f $(WHY2HTML) $$HOME/bin/$$OSTYPE/why2html
# 	cp -f $(DP) $$HOME/bin/$$OSTYPE/dp
# 	cp -f $(RVMERGE) $$HOME/bin/$$OSTYPE/rv_merge
# #	mkdir -p $(COQLIB)/contrib7/why
# #	cp -f $(VO7) $(VFILES) $(COQLIB)/contrib7/why
# #	mkdir -p $(COQLIB)/contrib/why
# #	cp -f $(VO8) $(VFILES) $(COQLIB)/contrib/why
# 	mkdir -p $(PVSLIB)/why
# 	cp $(PVSFILES) $(PVSLIB)/why
# 	mkdir -p $(MIZFILES)/mml/dict
# 	cp lib/mizar/why.miz $(MIZFILES)/mml
# 	cp lib/mizar/dict/why.voc $(MIZFILES)/mml/dict
# 	mkdir -p $$HOME/man/man1
# 	cp -f doc/*.1 $$HOME/man/man1

demons: $(STATICBINARY) doc/manual.ps
	cp -f $(STATICBINARY) /users/demons/demons/bin/$$OSTYPE/why
	cp doc/manual.ps /users/demons/demons/docs/why.ps

win: why.nsi
	"/cygdrive/c/Program Files (x86)/NSIS/makensis" /DVERSION=$(VERSION) why.nsi

zip:
	zip -A -r why-$(VERSION).zip c:/why/bin c:/why/lib c:/coq/lib/contrib/why c:/coq/lib/contrib7/why

# doc

DOC=doc/manual.ps doc/manual.html \
	doc/krakatoa.pdf doc/krakatoa.html \
	doc/main.pdf doc/main.html

doc:: $(DOC)


doc/manual.ps: doc/manual.tex doc/version.tex
	make -C doc manual.ps

# doc/version.tex: Version Makefile.in
#	echo '\newcommand{\whyversion}'"{$(VERSION)}" > $@
#	echo '\newcommand{\jessieversion}'"{$(JCVERSION)}" >> $@
#	echo '\newcommand{\krakatoaversion}'"{$(KVERSION)}" >> $@

doc/manual.html: doc/manual.tex doc/version.tex
	make -C doc manual.html

doc/krakatoa.pdf: doc/krakatoa.tex doc/version.tex
	make -C doc krakatoa.pdf

doc/krakatoa.html: doc/krakatoa.tex doc/version.tex
	make -C doc krakatoa.html

doc/main.pdf: doc/main.tex doc/version.tex
	make -C doc main.pdf

doc/main.html: doc/main.tex doc/version.tex
	make -C doc main.html


# API HTML DOC
##############

OCAMLDOCSRC = intf/model.mli $(WHYCONFIGCMO:.cmo=.ml) $(WHYCONFIGCMI:.cmi=.mli)
	# $(JCCMO:.cmo=.ml) $(JCCMI:.cmi=.mli)

apidoc: $(OCAMLDOCSRC)
	mkdir -p ocamldoc
	rm -f ocamldoc/*
	$(OCAMLDOC) -d ocamldoc -html $(INCLUDES)  $(OCAMLDOCSRC)


# special rules
###############

# CAMLP4= pa_extend.cmo pa_macro.cmo

# src/%.cmo: src/%.ml4
# 	$(OCAMLC) -c $(BFLAGS) -pp "$(CAMLP4) -DOCAML -impl" -impl $<

# src/%.cmx: src/%.ml4
# 	$(OCAMLOPT) -c $(OFLAGS) -pp "$(CAMLP4) -DOCAML -impl" -impl $<

# src/%.ml: src/%.ml4
# 	$(CAMLP4) pr_o.cmo -DOCAML -impl $< > $@

# generic rules
###############

.SUFFIXES: .mli .ml .cmi .cmo .cmx .mll .mly .v .vo .ml4

.mli.cmi:
	$(if $(QUIET),@echo 'Ocamlc   $<' &&) $(OCAMLC) $(APRONLIB) $(ATPLIB) -c $(BFLAGS) $<

.ml.cmi:
	$(if $(QUIET),@echo 'Ocamlc   $<' &&) $(OCAMLC) $(APRONLIB) $(ATPLIB) -c $(BFLAGS) $<

.ml.cmo:
	$(if $(QUIET),@echo 'Ocamlc   $<' &&) $(OCAMLC) $(APRONLIB) $(ATPLIB) -c $(BFLAGS) $<

.ml.o:
	$(OCAMLOPT) $(APRONLIB) $(ATPLIB) -c $(OFLAGS) $<

.ml.cmx:
	$(if $(QUIET),@echo 'Ocamlopt $<' &&) $(OCAMLOPT) $(APRONLIB) $(ATPLIB) -c $(OFLAGS) $<

.mll.ml:
	$(OCAMLLEX) $<

.mly.ml:
	$(OCAMLYACC) -v $<

.mly.mli:
	$(OCAMLYACC) -v $<

.ml4.ml:
	$(CAMLP4) pr_o.cmo -impl $< > $@

: COQEXTRAR += -R  Why3

lib/coq/%.vo: lib/coq/%.v
	$(COQC8) $(COQEXTRAR) -R lib/coq Why $<

lib/coq-v7/%.vo: lib/coq-v7/%.v
	$(COQC7) -I lib/coq-v7 $<

jc/jc_ai.ml: jc/jc_annot_inference.ml jc/jc_annot_fail.ml Makefile
	if test "no" = "yes" ; then \
	  echo "# 1 \"jc/jc_annot_inference.ml\"" > jc/jc_ai.ml; \
	  cat jc/jc_annot_inference.ml >> jc/jc_ai.ml; \
	else \
	  echo "# 1 \"jc/jc_annot_fail.ml\"" > jc/jc_ai.ml; \
	  cat jc/jc_annot_fail.ml >> jc/jc_ai.ml; \
	fi

# %_why.v: %.mlw $(BINARY)
# 	$(BINARY) -coq $*.mlw

# %_why.pvs: %.mlw $(BINARY)
# 	$(BINARY) -pvs $*.mlw

# Emacs tags
############

tags:
	find src -name "*.ml*" | sort -r | xargs \
	etags "--regex=/let[ \t]+\([^ \t]+\)/\1/" \
	      "--regex=/let[ \t]+rec[ \t]+\([^ \t]+\)/\1/" \
	      "--regex=/and[ \t]+\([^ \t]+\)/\1/" \
	      "--regex=/type[ \t]+\([^ \t]+\)/\1/" \
              "--regex=/exception[ \t]+\([^ \t]+\)/\1/" \
	      "--regex=/val[ \t]+\([^ \t]+\)/\1/" \
	      "--regex=/module[ \t]+\([^ \t]+\)/\1/"

otags:
	otags src/*.mli src/*.ml c/*.mli c/*.ml intf/*.mli intf/*.ml

wc:
	ocamlwc -p src/*.ml* jc/*.ml* c/*.ml* intf/*.ml* tools/*.ml* java/*.ml*

# distrib
#########

NAME=why-$(VERSION)
EXPORT=export/$(NAME)

WWW = /users/www-perso/projets/why
FTP = $(WWW)/download
WWWKRAKATOA = /users/www-perso/projets/krakatoa

FILES =src/*.ml* c/*.ml* jc/*.ml* java/*.ml* ml/*.ml* ml/*/*.ml* intf/*.ml* tools/*.ml* tools/*.c bin/gwhy.sh \
       mix/*.ml* \
       version.sh Version Makefile.in configure.in configure .depend .depend.coq \
       config/check_ocamlgraph.ml \
       README INSTALL COPYING LICENSE CHANGES \
       doc/Makefile doc/manual.ps doc/why.1 \
	examples-c/*/*.h examples-c/*/*.c \
	examples-c/Makefile examples-c/*/Makefile \
	examples-c/*/coq/*.v \
	examples/Makefile* \
	examples/*/*.mlw examples/*/*.why examples/*/*.v examples/*/*.sx \
	examples/*/.depend examples/*/Makefile \
	bench/bench.in bench/good*/*.mlw bench/good*/*.v \
        bench/c/bench bench/c/bench-files bench/c/*/*.c bench/c/*/*/*.c \
	bench/jc/bench bench/jc/good/*.jc \
	bench/java/bench bench/java/*/*.java bench/provers/*.mlw \
	tests/regtest.sh \
	tests/java/*.java tests/java/coq/*.v \
	tests/java/result/README tests/java/oracle/*.oracle \
	tests/c/*.c tests/c/*/coq/*.v \
	tests/c/result/README tests/c/oracle/*.oracle \
	lib/emacs/why.el \
	lib/coq*/*.v \
	lib/pvs/pvscontext.el lib/pvs/*.pvs lib/pvs/*.prf \
	lib/mizar/why.miz lib/mizar/dict/why.voc \
	lib/why/*.why lib/isabelle/*.thy lib/hol4/*.ml lib/harvey/*.rv \
	lib/why3/*.why lib/why3/*.mlw lib/why3/coq.drv \
	lib/java_api/java/*/*.java \
	lib/javacard_api/java/lang/*.java \
	lib/javacard_api/javacard/*/*.java \
	lib/javacard_api/javacardx/crypto/*.java \
	lib/javacard_api/com/sun/javacard/impl/*.java \
	lib/images/*.png \
	atp/*.ml atp/LICENSE.txt atp/Makefile atp/Mk_ml_file \
        frama-c-plugin/Makefile frama-c-plugin/configure \
	frama-c-plugin/*.ml* frama-c-plugin/share/jessie/*.h

#	ocamlgraph/configure.in ocamlgraph/configure ocamlgraph/.depend \
#	ocamlgraph/Makefile.in ocamlgraph/META.in ocamlgraph/*/*.ml* \

# ne pas distribuer ces tests-la	frama-c-plugin/tests/jessie/*.c

distrib export: source export-doc export-www export-examples 

export-www:
	echo "<#def version>$(VERSION)</#def>" > /users/demons/filliatr/www/why/version.prehtml
	echo "<#def cversion>$(CVERSION)</#def>" >> /users/demons/filliatr/www/why/version.prehtml
	make -C /users/demons/filliatr/www/why install

source: export/$(NAME).tar.gz
	cp CHANGES export/$(NAME).tar.gz $(FTP)

export/$(NAME).tar.gz: $(FILES)
	rm -rf $(EXPORT)
	mkdir -p $(EXPORT)/bin
	cp --parents $(FILES) $(EXPORT)
	cd $(EXPORT); rm -f $(GENERATED)
	cd export; tar cf $(NAME).tar $(NAME); gzip -f --best $(NAME).tar

tarball-for-framac:
	make tarball
	cp export/$(NAME).tar.gz export/why-for-framac.tar.gz

tarball:
	mkdir -p export
	cd export; rm -rf $(NAME) $(NAME).tar.gz
	make export/$(NAME).tar.gz

EXFILES = lib/coq*/*.v examples/*/*.v examples/*/*.mlw

export-examples:
	cp --parents $(EXFILES) $(WWW)
	make -C $(WWW)/examples clean depend
	echo "*** faire make all dans $(WWW)/examples ***"

export-doc: $(DOC) export-krakatoa-doc
	cp doc/manual.ps doc/manual.html $(WWW)/manual
	cp doc/logic_syntax.bnf $(WWW)/manual
	(cd $(WWW)/manual; hacha manual.html)

export-krakatoa-doc:
	cp doc/krakatoa.pdf doc/krakatoa.html doc/*.png $(WWWKRAKATOA)/manual
	(cd $(WWWKRAKATOA)/manual; hacha krakatoa.html)

OSTYPE  ?= linux

BINARYNAME = $(NAME)-$(OSTYPE)

linux: binary

ALLBINARYFILES = $(FILES) $(BINARYFILES)

binary: $(ALLBINARYFILES)
	mkdir -p export/$(BINARYNAME)
	cp --parents $(ALLBINARYFILES) export/$(BINARYNAME)
	(cd export; tar czf $(BINARYNAME).tar.gz $(BINARYNAME))
	cp export/$(BINARYNAME).tar.gz $(FTP)

# file headers
##############
headers:
	headache -c doc/headache_config.txt -h doc/header.txt \
		Makefile.in configure.in README \
		*/*.ml */*.ml[ily4] tools/*.c bench/c/good/*.c \
		bench/java/good/*.java \
		tests/java/*.java \
		tests/c/*.c \
		doc/*.tex

# myself
########

Makefile: Makefile.in config.status
	./config.status

config.status: configure
	./config.status --recheck

configure: configure.in
	autoconf

# clean and depend
##################

clean::
	rm -f src/*.cm[iox] src/*.o src/*~ src/*.annot src/*.output
	rm -f c/*.cm[iox] c/*.o c/*~ c/*.annot c/*.output
	rm -f intf/*.cm[iox] intf/*.o intf/*~ intf/*.annot
	rm -f tools/*.cm[iox] tools/*.o tools/*~ tools/*.annot
	rm -f jc/*.cm[iox] jc/*.o jc/*~ jc/*.annot jc/*.output
	rm -f java/*.cm[iox] java/*.o java/*~ java/*.annot java/*.output
	rm -f ml/*.cm[iox] ml/*.o ml/*~ ml/*.annot
	rm -f ml/parsing/*.cm[iox] ml/parsing/*.o ml/parsing/*~ \
		ml/parsing/*.annot ml/parsing/*.output
	rm -f ml/utils/*.cm[iox] ml/utils/*.o ml/utils/*~ ml/utils/*.annot
	rm -f ml/typing/*.cm[iox] ml/typing/*.o ml/typing/*~ ml/typing/*.annot
	rm -f bin/why.opt bin/why.byte bin/why.static bin/top
	rm -f bin/jessie.opt bin/jessie.byte
	rm -f bin/jessica.opt bin/jessica.byte
	rm -f bin/why-obfuscator.opt bin/why-obfuscator.byte
	rm -f bin/rv_merge.opt bin/rv_merge.byte
	rm -f bin/why-stat.opt bin/why-stat.byte
	rm -f bin/tool-stat.opt bin/tool-stat.byte
	rm -f bin/why2html.opt bin/why2html.byte
	rm -f bin/why-dp.opt bin/why-dp.byte
	rm -f bin/why-cpulimit
	rm -f lib/coq*/*.vo lib/coq*/*~
	rm -f $(GENERATED)
	make -C atp clean
	make -C doc clean
	if test -d examples-v7; then \
		make -C examples-v7 clean ; \
	fi
	make -C examples clean

dist-clean:: clean
	rm -f Makefile config.status config.cache config.log

coq-clean::
	rm -f lib/coq*/*.vo examples/*/*.vo
	rm .depend.coq

.PHONY: depend
.depend depend: $(GENERATED)
	rm -f .depend
	$(OCAMLDEP) -slash $(INCLUDES) src/*.ml src/*.mli jc/*.mli jc/*.ml c/*.mli c/*.ml java/*.mli java/*.ml intf/*.ml intf/*.mli tools/*.mli tools/*.ml mix/*.mli mix/*.ml ml/*.ml ml/*.mli > .depend
	$(OCAMLDEP) -slash $(MLINCLUDES) ml/parsing/*.ml ml/parsing/*.mli ml/typing/*.ml ml/typing/*.mli ml/utils/*.ml ml/utils/*.mli >> .depend
ifeq ($(FRAMAC),yes)
	$(MAKE) -C $(JESSIE_PLUGIN_PATH) depend
endif

.depend.coq: #lib/coq*/*.v
	if test yes = yes; then \
	  rm -f .depend.coq; \
	  $(COQDEP) -I lib/coq lib/coq/*.v > .depend.coq; \
	  $(COQDEP) -I lib/coq-v7 lib/coq-v7/*.v >> .depend.coq; \
	else touch .depend.coq; \
	fi

alldepend:
	make -C examples-v7 depend
	make -C examples depend

ifneq ($(MAKECMDGOALS),clean)
include .depend
include .depend.coq
endif

#################################################################
# Building the Why platform with ocamlbuild (OCaml 3.10 needed) #
#################################################################

# There used to be targets here but they are no longer useful.

# To build using Ocamlbuild:
# 1) Run "make Makefile" to ensure that the generated files (version.ml, ...)
# are generated.
# 2) Run Ocamlbuild with any target to generate the sanitization script.
# 3) Run ./sanitize to delete the generated files that shouldn't be generated
# (i.e. all lexers and parsers).
# 4) Run Ocamlbuild with the target you need, for example:
# ocamlbuild jc/jc_main.native

# You can also use the Makefile ./build.makefile which has some handy targets.
