; ModuleID = 'af_xdp_kern.c'
source_filename = "af_xdp_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, %union.anon }
%union.anon = type { %struct.anon }
%struct.anon = type { i32, i32 }
%struct.udphdr = type { i16, i16, i16, i16 }
%struct.pktgen_hdr = type { i32, i32, i32, i32 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !0
@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !52
@__const.xdp_sock_prog.____fmt = private unnamed_addr constant [20 x i8] c"AAAAAAAAAAAAAAAAAA\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !62
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_sock_prog(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_sock" !dbg !97 {
  %2 = alloca i32, align 4
  %3 = alloca [20 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !110, metadata !DIExpression()), !dbg !196
  %4 = bitcast i32* %2 to i8*, !dbg !197
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #5, !dbg !197
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !198
  %6 = load i32, i32* %5, align 4, !dbg !198, !tbaa !199
  call void @llvm.dbg.value(metadata i32 %6, metadata !111, metadata !DIExpression()), !dbg !196
  store i32 %6, i32* %2, align 4, !dbg !204, !tbaa !205
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !206
  %8 = load i32, i32* %7, align 4, !dbg !206, !tbaa !207
  %9 = zext i32 %8 to i64, !dbg !208
  %10 = inttoptr i64 %9 to i8*, !dbg !209
  call void @llvm.dbg.value(metadata i8* %10, metadata !116, metadata !DIExpression()), !dbg !196
  %11 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !210
  %12 = load i32, i32* %11, align 4, !dbg !210, !tbaa !211
  %13 = zext i32 %12 to i64, !dbg !212
  %14 = inttoptr i64 %13 to i8*, !dbg !213
  call void @llvm.dbg.value(metadata i8* %14, metadata !117, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata i64 %13, metadata !118, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata i32 2, metadata !179, metadata !DIExpression()), !dbg !196
  %15 = getelementptr inbounds [20 x i8], [20 x i8]* %3, i64 0, i64 0, !dbg !214
  call void @llvm.lifetime.start.p0i8(i64 20, i8* nonnull %15) #5, !dbg !214
  call void @llvm.dbg.declare(metadata [20 x i8]* %3, metadata !181, metadata !DIExpression()), !dbg !214
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(20) %15, i8* noundef nonnull align 1 dereferenceable(20) getelementptr inbounds ([20 x i8], [20 x i8]* @__const.xdp_sock_prog.____fmt, i64 0, i64 0), i64 20, i1 false), !dbg !214
  %16 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %15, i32 noundef 20) #5, !dbg !214
  call void @llvm.lifetime.end.p0i8(i64 20, i8* nonnull %15) #5, !dbg !215
  call void @llvm.dbg.value(metadata i8* %14, metadata !112, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !216, metadata !DIExpression()), !dbg !227
  call void @llvm.dbg.value(metadata i8* %10, metadata !223, metadata !DIExpression()), !dbg !227
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !224, metadata !DIExpression()), !dbg !227
  call void @llvm.dbg.value(metadata i8* %14, metadata !225, metadata !DIExpression()), !dbg !227
  call void @llvm.dbg.value(metadata i32 14, metadata !226, metadata !DIExpression()), !dbg !227
  %17 = getelementptr i8, i8* %14, i64 14, !dbg !229
  %18 = icmp ugt i8* %17, %10, !dbg !231
  br i1 %18, label %60, label %19, !dbg !232

19:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %14, metadata !225, metadata !DIExpression()), !dbg !227
  call void @llvm.dbg.value(metadata i8* %17, metadata !112, metadata !DIExpression()), !dbg !196
  %20 = getelementptr inbounds i8, i8* %14, i64 12, !dbg !233
  %21 = bitcast i8* %20 to i16*, !dbg !233
  %22 = load i16, i16* %21, align 1, !dbg !233, !tbaa !234
  call void @llvm.dbg.value(metadata i16 %22, metadata !180, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !196
  %23 = icmp ne i16 %22, 8, !dbg !237
  %24 = getelementptr i8, i8* %14, i64 34
  %25 = icmp ugt i8* %24, %10
  %26 = select i1 %23, i1 true, i1 %25, !dbg !239
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !132, metadata !DIExpression(DW_OP_deref)), !dbg !196
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !240, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.value(metadata i8* %10, metadata !246, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !247, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.value(metadata i8* %17, metadata !248, metadata !DIExpression()), !dbg !250
  br i1 %26, label %60, label %27, !dbg !239

27:                                               ; preds = %19
  %28 = load i8, i8* %17, align 4, !dbg !252
  %29 = shl i8 %28, 2, !dbg !253
  %30 = and i8 %29, 60, !dbg !253
  call void @llvm.dbg.value(metadata i8 %30, metadata !249, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !250
  %31 = icmp ult i8 %30, 20, !dbg !254
  br i1 %31, label %60, label %32, !dbg !256

32:                                               ; preds = %27
  %33 = zext i8 %30 to i64
  call void @llvm.dbg.value(metadata i64 %33, metadata !249, metadata !DIExpression()), !dbg !250
  %34 = getelementptr i8, i8* %17, i64 %33, !dbg !257
  %35 = icmp ugt i8* %34, %10, !dbg !259
  br i1 %35, label %60, label %36, !dbg !260

36:                                               ; preds = %32
  call void @llvm.dbg.value(metadata i8* %34, metadata !112, metadata !DIExpression()), !dbg !196
  %37 = getelementptr i8, i8* %14, i64 23, !dbg !261
  %38 = load i8, i8* %37, align 1, !dbg !261, !tbaa !262
  call void @llvm.dbg.value(metadata i8 %38, metadata !186, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !196
  %39 = icmp eq i8 %38, 17, !dbg !264
  br i1 %39, label %40, label %60, !dbg !265

40:                                               ; preds = %36
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !266, metadata !DIExpression()), !dbg !276
  call void @llvm.dbg.value(metadata i8* %10, metadata !272, metadata !DIExpression()), !dbg !276
  call void @llvm.dbg.value(metadata %struct.udphdr** undef, metadata !273, metadata !DIExpression()), !dbg !276
  call void @llvm.dbg.value(metadata i8* %34, metadata !275, metadata !DIExpression()), !dbg !276
  %41 = getelementptr inbounds i8, i8* %34, i64 8, !dbg !278
  %42 = bitcast i8* %41 to %struct.udphdr*, !dbg !278
  %43 = inttoptr i64 %9 to %struct.udphdr*, !dbg !280
  %44 = icmp ugt %struct.udphdr* %42, %43, !dbg !281
  %45 = select i1 %44, i8* %34, i8* %41, !dbg !282
  call void @llvm.dbg.value(metadata i8* %45, metadata !112, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata i32 undef, metadata !187, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !284, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.value(metadata i8* %10, metadata !290, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.value(metadata %struct.pktgen_hdr** undef, metadata !291, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.value(metadata i8* %45, metadata !292, metadata !DIExpression()), !dbg !293
  %46 = getelementptr inbounds i8, i8* %45, i64 16, !dbg !295
  %47 = bitcast i8* %46 to %struct.pktgen_hdr*, !dbg !295
  %48 = inttoptr i64 %9 to %struct.pktgen_hdr*, !dbg !297
  %49 = icmp ugt %struct.pktgen_hdr* %47, %48, !dbg !298
  br i1 %49, label %60, label %50, !dbg !299

50:                                               ; preds = %40
  call void @llvm.dbg.value(metadata i8* %45, metadata !292, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.value(metadata %struct.pktgen_hdr* %47, metadata !112, metadata !DIExpression()), !dbg !196
  %51 = bitcast i8* %45 to i32*, !dbg !300
  %52 = load i32, i32* %51, align 4, !dbg !300, !tbaa !302
  %53 = icmp eq i32 %52, 1441373118, !dbg !304
  call void @llvm.dbg.value(metadata i1 %53, metadata !187, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !283
  br i1 %53, label %54, label %60, !dbg !305

54:                                               ; preds = %50
  call void @llvm.dbg.value(metadata i32* %2, metadata !111, metadata !DIExpression(DW_OP_deref)), !dbg !196
  %55 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* noundef nonnull %4) #5, !dbg !306
  %56 = icmp eq i8* %55, null, !dbg !306
  br i1 %56, label %60, label %57, !dbg !307

57:                                               ; preds = %54
  %58 = load i32, i32* %2, align 4, !dbg !308, !tbaa !205
  call void @llvm.dbg.value(metadata i32 %58, metadata !111, metadata !DIExpression()), !dbg !196
  %59 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 noundef %58, i64 noundef 0) #5, !dbg !309
  call void @llvm.dbg.value(metadata i32 %59, metadata !190, metadata !DIExpression()), !dbg !310
  br label %60

60:                                               ; preds = %40, %50, %57, %32, %27, %1, %54, %36, %19
  %61 = phi i32 [ 2, %19 ], [ 2, %36 ], [ 2, %54 ], [ 2, %1 ], [ 2, %27 ], [ 2, %32 ], [ 2, %50 ], [ %59, %57 ], [ 2, %40 ], !dbg !196
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #5, !dbg !311
  ret i32 %61, !dbg !311
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!92, !93, !94, !95}
!llvm.ident = !{!96}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 15, type: !54, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !45, globals: !51, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "af_xdp_kern.c", directory: "/home/amartin/flujos/libs/xdp", checksumkind: CSK_MD5, checksum: "17ff076d469e12d042d3ff9af56ccc41")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 5431, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "5ad8bc925dae1ec87bbb04b3148b183b")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 28, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "078a32220dc819f6a7e2ea3cecc4e133")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!38 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!39 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!40 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!41 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!42 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!43 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!44 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!45 = !{!46, !47, !48}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !49, line: 24, baseType: !50)
!49 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!50 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!51 = !{!0, !52, !62, !68, !78, !85}
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 22, type: !54, isLocal: false, isDefinition: true)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !55, line: 33, size: 160, elements: !56)
!55 = !DIFile(filename: "libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/amartin/flujos/libs/xdp", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!56 = !{!57, !58, !59, !60, !61}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !54, file: !55, line: 34, baseType: !7, size: 32)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !54, file: !55, line: 35, baseType: !7, size: 32, offset: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !54, file: !55, line: 36, baseType: !7, size: 32, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !54, file: !55, line: 37, baseType: !7, size: 32, offset: 96)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !54, file: !55, line: 38, baseType: !7, size: 32, offset: 128)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 202, type: !64, isLocal: false, isDefinition: true)
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 32, elements: !66)
!65 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!66 = !{!67}
!67 = !DISubrange(count: 4)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !70, line: 152, type: !71, isLocal: true, isDefinition: true)
!70 = !DIFile(filename: "libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/amartin/flujos/libs/xdp", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DISubroutineType(types: !73)
!73 = !{!74, !75, !77, null}
!74 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !65)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !49, line: 27, baseType: !7)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !70, line: 33, type: !80, isLocal: true, isDefinition: true)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DISubroutineType(types: !82)
!82 = !{!46, !46, !83}
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !70, line: 1254, type: !87, isLocal: true, isDefinition: true)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DISubroutineType(types: !89)
!89 = !{!74, !46, !77, !90}
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !49, line: 31, baseType: !91)
!91 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!92 = !{i32 7, !"Dwarf Version", i32 5}
!93 = !{i32 2, !"Debug Info Version", i32 3}
!94 = !{i32 1, !"wchar_size", i32 4}
!95 = !{i32 7, !"frame-pointer", i32 2}
!96 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!97 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 126, type: !98, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !109)
!98 = !DISubroutineType(types: !99)
!99 = !{!74, !100}
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 5442, size: 192, elements: !102)
!102 = !{!103, !104, !105, !106, !107, !108}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !101, file: !6, line: 5443, baseType: !77, size: 32)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !101, file: !6, line: 5444, baseType: !77, size: 32, offset: 32)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !101, file: !6, line: 5445, baseType: !77, size: 32, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !101, file: !6, line: 5447, baseType: !77, size: 32, offset: 96)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !101, file: !6, line: 5448, baseType: !77, size: 32, offset: 128)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !101, file: !6, line: 5450, baseType: !77, size: 32, offset: 160)
!109 = !{!110, !111, !112, !116, !117, !118, !132, !162, !171, !179, !180, !181, !186, !187, !190}
!110 = !DILocalVariable(name: "ctx", arg: 1, scope: !97, file: !3, line: 126, type: !100)
!111 = !DILocalVariable(name: "index", scope: !97, file: !3, line: 130, type: !74)
!112 = !DILocalVariable(name: "nh", scope: !97, file: !3, line: 132, type: !113)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !3, line: 30, size: 64, elements: !114)
!114 = !{!115}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !113, file: !3, line: 31, baseType: !46, size: 64)
!116 = !DILocalVariable(name: "data_end", scope: !97, file: !3, line: 133, type: !46)
!117 = !DILocalVariable(name: "data", scope: !97, file: !3, line: 134, type: !46)
!118 = !DILocalVariable(name: "eth", scope: !97, file: !3, line: 135, type: !119)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !121, line: 168, size: 112, elements: !122)
!121 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!122 = !{!123, !128, !129}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !120, file: !121, line: 169, baseType: !124, size: 48)
!124 = !DICompositeType(tag: DW_TAG_array_type, baseType: !125, size: 48, elements: !126)
!125 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!126 = !{!127}
!127 = !DISubrange(count: 6)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !120, file: !121, line: 170, baseType: !124, size: 48, offset: 48)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !120, file: !121, line: 171, baseType: !130, size: 16, offset: 96)
!130 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !131, line: 25, baseType: !48)
!131 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!132 = !DILocalVariable(name: "iph", scope: !97, file: !3, line: 136, type: !133)
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !135, line: 87, size: 160, elements: !136)
!135 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "042b09a58768855e3578a0a8eba49be7")
!136 = !{!137, !139, !140, !141, !142, !143, !144, !145, !146, !148}
!137 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !134, file: !135, line: 89, baseType: !138, size: 4, flags: DIFlagBitField, extraData: i64 0)
!138 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !49, line: 21, baseType: !125)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !134, file: !135, line: 90, baseType: !138, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !134, file: !135, line: 97, baseType: !138, size: 8, offset: 8)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !134, file: !135, line: 98, baseType: !130, size: 16, offset: 16)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !134, file: !135, line: 99, baseType: !130, size: 16, offset: 32)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !134, file: !135, line: 100, baseType: !130, size: 16, offset: 48)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !134, file: !135, line: 101, baseType: !138, size: 8, offset: 64)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !134, file: !135, line: 102, baseType: !138, size: 8, offset: 72)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !134, file: !135, line: 103, baseType: !147, size: 16, offset: 80)
!147 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !131, line: 31, baseType: !48)
!148 = !DIDerivedType(tag: DW_TAG_member, scope: !134, file: !135, line: 104, baseType: !149, size: 64, offset: 96)
!149 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !134, file: !135, line: 104, size: 64, elements: !150)
!150 = !{!151, !157}
!151 = !DIDerivedType(tag: DW_TAG_member, scope: !149, file: !135, line: 104, baseType: !152, size: 64)
!152 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !149, file: !135, line: 104, size: 64, elements: !153)
!153 = !{!154, !156}
!154 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !152, file: !135, line: 104, baseType: !155, size: 32)
!155 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !131, line: 27, baseType: !77)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !152, file: !135, line: 104, baseType: !155, size: 32, offset: 32)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !149, file: !135, line: 104, baseType: !158, size: 64)
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !149, file: !135, line: 104, size: 64, elements: !159)
!159 = !{!160, !161}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !158, file: !135, line: 104, baseType: !155, size: 32)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !158, file: !135, line: 104, baseType: !155, size: 32, offset: 32)
!162 = !DILocalVariable(name: "udph", scope: !97, file: !3, line: 137, type: !163)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !165, line: 23, size: 64, elements: !166)
!165 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!166 = !{!167, !168, !169, !170}
!167 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !164, file: !165, line: 24, baseType: !130, size: 16)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !164, file: !165, line: 25, baseType: !130, size: 16, offset: 16)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !164, file: !165, line: 26, baseType: !130, size: 16, offset: 32)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !164, file: !165, line: 27, baseType: !147, size: 16, offset: 48)
!171 = !DILocalVariable(name: "pkth", scope: !97, file: !3, line: 138, type: !172)
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !173, size: 64)
!173 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "pktgen_hdr", file: !3, line: 35, size: 128, elements: !174)
!174 = !{!175, !176, !177, !178}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "pgh_magic", scope: !173, file: !3, line: 37, baseType: !155, size: 32)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "seq_num", scope: !173, file: !3, line: 38, baseType: !155, size: 32, offset: 32)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !173, file: !3, line: 39, baseType: !155, size: 32, offset: 64)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "tv_usec", scope: !173, file: !3, line: 40, baseType: !155, size: 32, offset: 96)
!179 = !DILocalVariable(name: "action", scope: !97, file: !3, line: 140, type: !77)
!180 = !DILocalVariable(name: "nh_type", scope: !97, file: !3, line: 141, type: !74)
!181 = !DILocalVariable(name: "____fmt", scope: !182, file: !3, line: 143, type: !183)
!182 = distinct !DILexicalBlock(scope: !97, file: !3, line: 143, column: 2)
!183 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 160, elements: !184)
!184 = !{!185}
!185 = !DISubrange(count: 20)
!186 = !DILocalVariable(name: "nh_proto", scope: !97, file: !3, line: 149, type: !74)
!187 = !DILocalVariable(name: "l", scope: !188, file: !3, line: 159, type: !74)
!188 = distinct !DILexicalBlock(scope: !189, file: !3, line: 157, column: 31)
!189 = distinct !DILexicalBlock(scope: !97, file: !3, line: 157, column: 6)
!190 = !DILocalVariable(name: "ret_val", scope: !191, file: !3, line: 175, type: !195)
!191 = distinct !DILexicalBlock(scope: !192, file: !3, line: 172, column: 47)
!192 = distinct !DILexicalBlock(scope: !193, file: !3, line: 172, column: 8)
!193 = distinct !DILexicalBlock(scope: !194, file: !3, line: 168, column: 11)
!194 = distinct !DILexicalBlock(scope: !188, file: !3, line: 168, column: 6)
!195 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !74)
!196 = !DILocation(line: 0, scope: !97)
!197 = !DILocation(line: 130, column: 6, scope: !97)
!198 = !DILocation(line: 130, column: 23, scope: !97)
!199 = !{!200, !201, i64 16}
!200 = !{!"xdp_md", !201, i64 0, !201, i64 4, !201, i64 8, !201, i64 12, !201, i64 16, !201, i64 20}
!201 = !{!"int", !202, i64 0}
!202 = !{!"omnipotent char", !203, i64 0}
!203 = !{!"Simple C/C++ TBAA"}
!204 = !DILocation(line: 130, column: 10, scope: !97)
!205 = !{!201, !201, i64 0}
!206 = !DILocation(line: 133, column: 39, scope: !97)
!207 = !{!200, !201, i64 4}
!208 = !DILocation(line: 133, column: 28, scope: !97)
!209 = !DILocation(line: 133, column: 20, scope: !97)
!210 = !DILocation(line: 134, column: 34, scope: !97)
!211 = !{!200, !201, i64 0}
!212 = !DILocation(line: 134, column: 23, scope: !97)
!213 = !DILocation(line: 134, column: 15, scope: !97)
!214 = !DILocation(line: 143, column: 2, scope: !182)
!215 = !DILocation(line: 143, column: 2, scope: !97)
!216 = !DILocalVariable(name: "nh", arg: 1, scope: !217, file: !3, line: 46, type: !220)
!217 = distinct !DISubprogram(name: "parse_ethhdr", scope: !3, file: !3, line: 46, type: !218, scopeLine: 49, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !222)
!218 = !DISubroutineType(types: !219)
!219 = !{!74, !220, !46, !221}
!220 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!221 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!222 = !{!216, !223, !224, !225, !226}
!223 = !DILocalVariable(name: "data_end", arg: 2, scope: !217, file: !3, line: 47, type: !46)
!224 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !217, file: !3, line: 48, type: !221)
!225 = !DILocalVariable(name: "eth", scope: !217, file: !3, line: 50, type: !119)
!226 = !DILocalVariable(name: "hdrsize", scope: !217, file: !3, line: 51, type: !74)
!227 = !DILocation(line: 0, scope: !217, inlinedAt: !228)
!228 = distinct !DILocation(line: 145, column: 12, scope: !97)
!229 = !DILocation(line: 52, column: 14, scope: !230, inlinedAt: !228)
!230 = distinct !DILexicalBlock(scope: !217, file: !3, line: 52, column: 6)
!231 = !DILocation(line: 52, column: 19, scope: !230, inlinedAt: !228)
!232 = !DILocation(line: 52, column: 6, scope: !217, inlinedAt: !228)
!233 = !DILocation(line: 58, column: 14, scope: !217, inlinedAt: !228)
!234 = !{!235, !236, i64 12}
!235 = !{!"ethhdr", !202, i64 0, !202, i64 6, !236, i64 12}
!236 = !{!"short", !202, i64 0}
!237 = !DILocation(line: 146, column: 14, scope: !238)
!238 = distinct !DILexicalBlock(scope: !97, file: !3, line: 146, column: 6)
!239 = !DILocation(line: 146, column: 6, scope: !97)
!240 = !DILocalVariable(name: "nh", arg: 1, scope: !241, file: !3, line: 61, type: !220)
!241 = distinct !DISubprogram(name: "parse_iphdr", scope: !3, file: !3, line: 61, type: !242, scopeLine: 64, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !245)
!242 = !DISubroutineType(types: !243)
!243 = !{!74, !220, !46, !244}
!244 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!245 = !{!240, !246, !247, !248, !249}
!246 = !DILocalVariable(name: "data_end", arg: 2, scope: !241, file: !3, line: 62, type: !46)
!247 = !DILocalVariable(name: "iphdr", arg: 3, scope: !241, file: !3, line: 63, type: !244)
!248 = !DILocalVariable(name: "iph", scope: !241, file: !3, line: 65, type: !133)
!249 = !DILocalVariable(name: "hdrsize", scope: !241, file: !3, line: 66, type: !74)
!250 = !DILocation(line: 0, scope: !241, inlinedAt: !251)
!251 = distinct !DILocation(line: 150, column: 11, scope: !97)
!252 = !DILocation(line: 71, column: 17, scope: !241, inlinedAt: !251)
!253 = !DILocation(line: 71, column: 21, scope: !241, inlinedAt: !251)
!254 = !DILocation(line: 73, column: 13, scope: !255, inlinedAt: !251)
!255 = distinct !DILexicalBlock(scope: !241, file: !3, line: 73, column: 5)
!256 = !DILocation(line: 73, column: 5, scope: !241, inlinedAt: !251)
!257 = !DILocation(line: 77, column: 14, scope: !258, inlinedAt: !251)
!258 = distinct !DILexicalBlock(scope: !241, file: !3, line: 77, column: 6)
!259 = !DILocation(line: 77, column: 24, scope: !258, inlinedAt: !251)
!260 = !DILocation(line: 77, column: 6, scope: !241, inlinedAt: !251)
!261 = !DILocation(line: 83, column: 14, scope: !241, inlinedAt: !251)
!262 = !{!263, !202, i64 9}
!263 = !{!"iphdr", !202, i64 0, !202, i64 0, !202, i64 1, !236, i64 2, !236, i64 4, !236, i64 6, !202, i64 8, !202, i64 9, !236, i64 10, !202, i64 12}
!264 = !DILocation(line: 157, column: 15, scope: !189)
!265 = !DILocation(line: 157, column: 6, scope: !97)
!266 = !DILocalVariable(name: "nh", arg: 1, scope: !267, file: !3, line: 105, type: !220)
!267 = distinct !DISubprogram(name: "parse_udphdr", scope: !3, file: !3, line: 105, type: !268, scopeLine: 108, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !271)
!268 = !DISubroutineType(types: !269)
!269 = !{!74, !220, !46, !270}
!270 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!271 = !{!266, !272, !273, !274, !275}
!272 = !DILocalVariable(name: "data_end", arg: 2, scope: !267, file: !3, line: 106, type: !46)
!273 = !DILocalVariable(name: "udphdr", arg: 3, scope: !267, file: !3, line: 107, type: !270)
!274 = !DILocalVariable(name: "len", scope: !267, file: !3, line: 109, type: !74)
!275 = !DILocalVariable(name: "h", scope: !267, file: !3, line: 110, type: !163)
!276 = !DILocation(line: 0, scope: !267, inlinedAt: !277)
!277 = distinct !DILocation(line: 160, column: 6, scope: !188)
!278 = !DILocation(line: 112, column: 8, scope: !279, inlinedAt: !277)
!279 = distinct !DILexicalBlock(scope: !267, file: !3, line: 112, column: 6)
!280 = !DILocation(line: 112, column: 14, scope: !279, inlinedAt: !277)
!281 = !DILocation(line: 112, column: 12, scope: !279, inlinedAt: !277)
!282 = !DILocation(line: 112, column: 6, scope: !267, inlinedAt: !277)
!283 = !DILocation(line: 0, scope: !188)
!284 = !DILocalVariable(name: "nh", arg: 1, scope: !285, file: !3, line: 87, type: !220)
!285 = distinct !DISubprogram(name: "parse_pktgenhdr", scope: !3, file: !3, line: 87, type: !286, scopeLine: 90, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !289)
!286 = !DISubroutineType(types: !287)
!287 = !{!74, !220, !46, !288}
!288 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!289 = !{!284, !290, !291, !292}
!290 = !DILocalVariable(name: "data_end", arg: 2, scope: !285, file: !3, line: 88, type: !46)
!291 = !DILocalVariable(name: "pkthdr", arg: 3, scope: !285, file: !3, line: 89, type: !288)
!292 = !DILocalVariable(name: "h", scope: !285, file: !3, line: 92, type: !172)
!293 = !DILocation(line: 0, scope: !285, inlinedAt: !294)
!294 = distinct !DILocation(line: 165, column: 5, scope: !188)
!295 = !DILocation(line: 94, column: 8, scope: !296, inlinedAt: !294)
!296 = distinct !DILexicalBlock(scope: !285, file: !3, line: 94, column: 6)
!297 = !DILocation(line: 94, column: 14, scope: !296, inlinedAt: !294)
!298 = !DILocation(line: 94, column: 12, scope: !296, inlinedAt: !294)
!299 = !DILocation(line: 94, column: 6, scope: !285, inlinedAt: !294)
!300 = !DILocation(line: 100, column: 9, scope: !301, inlinedAt: !294)
!301 = distinct !DILexicalBlock(scope: !285, file: !3, line: 100, column: 6)
!302 = !{!303, !201, i64 0}
!303 = !{!"pktgen_hdr", !201, i64 0, !201, i64 4, !201, i64 8, !201, i64 12}
!304 = !DILocation(line: 100, column: 18, scope: !301, inlinedAt: !294)
!305 = !DILocation(line: 168, column: 6, scope: !188)
!306 = !DILocation(line: 172, column: 8, scope: !192)
!307 = !DILocation(line: 172, column: 8, scope: !193)
!308 = !DILocation(line: 175, column: 52, scope: !191)
!309 = !DILocation(line: 175, column: 24, scope: !191)
!310 = !DILocation(line: 0, scope: !191)
!311 = !DILocation(line: 200, column: 1, scope: !97)
