; ModuleID = 'af_xdp_kern.c'
source_filename = "af_xdp_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !0
@xdp_puerto_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 2, i32 0 }, section "maps", align 4, !dbg !17
@__const.xdp_sock_prog.____fmt = private unnamed_addr constant [17 x i8] c"UDP1: puerto %d\0A\00", align 1
@__const.xdp_sock_prog.____fmt.1 = private unnamed_addr constant [14 x i8] c"TCP: cola %d\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !27
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @xdp_puerto_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_sock_prog(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_sock" !dbg !63 {
  %2 = alloca i32, align 4
  %3 = alloca [17 x i8], align 1
  %4 = alloca [14 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !75, metadata !DIExpression()), !dbg !95
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !96
  %6 = load i32, i32* %5, align 4, !dbg !96, !tbaa !97
  call void @llvm.dbg.value(metadata i32 %6, metadata !76, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i32* null, metadata !77, metadata !DIExpression()), !dbg !95
  %7 = bitcast i32* %2 to i8*, !dbg !102
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %7) #5, !dbg !102
  call void @llvm.dbg.value(metadata i32 1, metadata !79, metadata !DIExpression()), !dbg !95
  store i32 1, i32* %2, align 4, !dbg !103, !tbaa !104
  call void @llvm.dbg.value(metadata i32* %2, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !95
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_puerto_map to i8*), i8* noundef nonnull %7) #5, !dbg !105
  call void @llvm.dbg.value(metadata i8* %8, metadata !77, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i32 -1, metadata !80, metadata !DIExpression()), !dbg !95
  %9 = icmp eq i8* %8, null, !dbg !106
  br i1 %9, label %13, label %10, !dbg !108

10:                                               ; preds = %1
  %11 = bitcast i8* %8 to i32*, !dbg !105
  call void @llvm.dbg.value(metadata i32* %11, metadata !77, metadata !DIExpression()), !dbg !95
  %12 = load i32, i32* %11, align 4, !dbg !109, !tbaa !104
  call void @llvm.dbg.value(metadata i32 %12, metadata !80, metadata !DIExpression()), !dbg !95
  br label %13, !dbg !110

13:                                               ; preds = %10, %1
  %14 = phi i32 [ %12, %10 ], [ -1, %1 ], !dbg !95
  call void @llvm.dbg.value(metadata i32 %14, metadata !80, metadata !DIExpression()), !dbg !95
  switch i32 %6, label %22 [
    i32 1, label %15
    i32 2, label %19
  ], !dbg !111

15:                                               ; preds = %13
  %16 = getelementptr inbounds [17 x i8], [17 x i8]* %3, i64 0, i64 0, !dbg !112
  call void @llvm.lifetime.start.p0i8(i64 17, i8* nonnull %16) #5, !dbg !112
  call void @llvm.dbg.declare(metadata [17 x i8]* %3, metadata !81, metadata !DIExpression()), !dbg !112
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(17) %16, i8* noundef nonnull align 1 dereferenceable(17) getelementptr inbounds ([17 x i8], [17 x i8]* @__const.xdp_sock_prog.____fmt, i64 0, i64 0), i64 17, i1 false), !dbg !112
  %17 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %16, i32 noundef 17, i32 noundef %14) #5, !dbg !112
  call void @llvm.lifetime.end.p0i8(i64 17, i8* nonnull %16) #5, !dbg !113
  %18 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 noundef 1, i64 noundef 0) #5, !dbg !114
  br label %22, !dbg !115

19:                                               ; preds = %13
  %20 = getelementptr inbounds [14 x i8], [14 x i8]* %4, i64 0, i64 0, !dbg !116
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %20) #5, !dbg !116
  call void @llvm.dbg.declare(metadata [14 x i8]* %4, metadata !88, metadata !DIExpression()), !dbg !116
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(14) %20, i8* noundef nonnull align 1 dereferenceable(14) getelementptr inbounds ([14 x i8], [14 x i8]* @__const.xdp_sock_prog.____fmt.1, i64 0, i64 0), i64 14, i1 false), !dbg !116
  %21 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %20, i32 noundef 14, i32 noundef 2) #5, !dbg !116
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %20) #5, !dbg !117
  br label %22, !dbg !118

22:                                               ; preds = %13, %19, %15
  %23 = phi i32 [ %18, %15 ], [ 2, %19 ], [ 2, %13 ], !dbg !95
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %7) #5, !dbg !119
  ret i32 %23, !dbg !119
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
!llvm.module.flags = !{!58, !59, !60, !61}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 7, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !16, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "af_xdp_kern.c", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "3aab9a2a274c957b1d0e9e10ac617856")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!15}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !{!0, !17, !27, !33, !41, !51}
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "xdp_puerto_map", scope: !2, file: !3, line: 14, type: !19, isLocal: false, isDefinition: true)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !20, line: 33, size: 160, elements: !21)
!20 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!21 = !{!22, !23, !24, !25, !26}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !19, file: !20, line: 34, baseType: !7, size: 32)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !19, file: !20, line: 35, baseType: !7, size: 32, offset: 32)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !19, file: !20, line: 36, baseType: !7, size: 32, offset: 64)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !19, file: !20, line: 37, baseType: !7, size: 32, offset: 96)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !19, file: !20, line: 38, baseType: !7, size: 32, offset: 128)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 45, type: !29, isLocal: false, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 32, elements: !31)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!31 = !{!32}
!32 = !DISubrange(count: 4)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !35, line: 33, type: !36, isLocal: true, isDefinition: true)
!35 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DISubroutineType(types: !38)
!38 = !{!15, !15, !39}
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !35, line: 152, type: !43, isLocal: true, isDefinition: true)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DISubroutineType(types: !45)
!45 = !{!46, !47, !49, null}
!46 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !30)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !50, line: 27, baseType: !7)
!50 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !35, line: 1254, type: !53, isLocal: true, isDefinition: true)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = !DISubroutineType(types: !55)
!55 = !{!46, !15, !49, !56}
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !50, line: 31, baseType: !57)
!57 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!58 = !{i32 7, !"Dwarf Version", i32 5}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 7, !"frame-pointer", i32 2}
!62 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!63 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 22, type: !64, scopeLine: 23, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !74)
!64 = !DISubroutineType(types: !65)
!65 = !{!46, !66}
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !68)
!68 = !{!69, !70, !71, !72, !73}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !67, file: !6, line: 2857, baseType: !49, size: 32)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !67, file: !6, line: 2858, baseType: !49, size: 32, offset: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !67, file: !6, line: 2859, baseType: !49, size: 32, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !67, file: !6, line: 2861, baseType: !49, size: 32, offset: 96)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !67, file: !6, line: 2862, baseType: !49, size: 32, offset: 128)
!74 = !{!75, !76, !77, !79, !80, !81, !88}
!75 = !DILocalVariable(name: "ctx", arg: 1, scope: !63, file: !3, line: 22, type: !66)
!76 = !DILocalVariable(name: "index", scope: !63, file: !3, line: 24, type: !46)
!77 = !DILocalVariable(name: "puerto1", scope: !63, file: !3, line: 27, type: !78)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!79 = !DILocalVariable(name: "key_puerto", scope: !63, file: !3, line: 28, type: !46)
!80 = !DILocalVariable(name: "valor_puerto", scope: !63, file: !3, line: 30, type: !46)
!81 = !DILocalVariable(name: "____fmt", scope: !82, file: !3, line: 34, type: !85)
!82 = distinct !DILexicalBlock(scope: !83, file: !3, line: 34, column: 3)
!83 = distinct !DILexicalBlock(scope: !84, file: !3, line: 33, column: 15)
!84 = distinct !DILexicalBlock(scope: !63, file: !3, line: 33, column: 6)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 136, elements: !86)
!86 = !{!87}
!87 = !DISubrange(count: 17)
!88 = !DILocalVariable(name: "____fmt", scope: !89, file: !3, line: 38, type: !92)
!89 = distinct !DILexicalBlock(scope: !90, file: !3, line: 38, column: 3)
!90 = distinct !DILexicalBlock(scope: !91, file: !3, line: 37, column: 15)
!91 = distinct !DILexicalBlock(scope: !63, file: !3, line: 37, column: 6)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 112, elements: !93)
!93 = !{!94}
!94 = !DISubrange(count: 14)
!95 = !DILocation(line: 0, scope: !63)
!96 = !DILocation(line: 24, column: 22, scope: !63)
!97 = !{!98, !99, i64 16}
!98 = !{!"xdp_md", !99, i64 0, !99, i64 4, !99, i64 8, !99, i64 12, !99, i64 16}
!99 = !{!"int", !100, i64 0}
!100 = !{!"omnipotent char", !101, i64 0}
!101 = !{!"Simple C/C++ TBAA"}
!102 = !DILocation(line: 28, column: 2, scope: !63)
!103 = !DILocation(line: 28, column: 6, scope: !63)
!104 = !{!99, !99, i64 0}
!105 = !DILocation(line: 29, column: 12, scope: !63)
!106 = !DILocation(line: 31, column: 12, scope: !107)
!107 = distinct !DILexicalBlock(scope: !63, file: !3, line: 31, column: 5)
!108 = !DILocation(line: 31, column: 5, scope: !63)
!109 = !DILocation(line: 32, column: 18, scope: !107)
!110 = !DILocation(line: 32, column: 3, scope: !107)
!111 = !DILocation(line: 33, column: 6, scope: !63)
!112 = !DILocation(line: 34, column: 3, scope: !82)
!113 = !DILocation(line: 34, column: 3, scope: !83)
!114 = !DILocation(line: 35, column: 10, scope: !83)
!115 = !DILocation(line: 35, column: 3, scope: !83)
!116 = !DILocation(line: 38, column: 3, scope: !89)
!117 = !DILocation(line: 38, column: 3, scope: !90)
!118 = !DILocation(line: 39, column: 3, scope: !90)
!119 = !DILocation(line: 43, column: 1, scope: !63)
