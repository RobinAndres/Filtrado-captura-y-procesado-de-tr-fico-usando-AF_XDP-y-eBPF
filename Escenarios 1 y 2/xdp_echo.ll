; ModuleID = 'xdp_echo.c'
source_filename = "xdp_echo.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, %union.anon }
%union.anon = type { %struct.anon }
%struct.anon = type { i32, i32 }
%struct.tcphdr = type { i16, i16, i32, i32, i16, i16, i16, i16 }
%struct.udphdr = type { i16, i16, i16, i16 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !0
@xdp_puerto_map = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 4, i32 2, i32 0 }, section "maps", align 4, !dbg !53
@__const.xdp_echo_prog.____fmt = private unnamed_addr constant [10 x i8] c"PUERTO:%d\00", align 1
@__const.xdp_echo_prog.____fmt.3 = private unnamed_addr constant [10 x i8] c"TCPUERTO\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !63
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_echo_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_puerto_map to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_echo_prog(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_echo" !dbg !97 {
  %2 = alloca i32, align 4
  %3 = alloca [10 x i8], align 1
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca [10 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !109, metadata !DIExpression()), !dbg !225
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !226
  %8 = load i32, i32* %7, align 4, !dbg !226, !tbaa !227
  call void @llvm.dbg.value(metadata i32 %8, metadata !110, metadata !DIExpression()), !dbg !225
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !232
  %10 = load i32, i32* %9, align 4, !dbg !232, !tbaa !233
  %11 = zext i32 %10 to i64, !dbg !234
  %12 = inttoptr i64 %11 to i8*, !dbg !235
  call void @llvm.dbg.value(metadata i8* %12, metadata !115, metadata !DIExpression()), !dbg !225
  %13 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !236
  %14 = load i32, i32* %13, align 4, !dbg !236, !tbaa !237
  %15 = zext i32 %14 to i64, !dbg !238
  %16 = inttoptr i64 %15 to i8*, !dbg !239
  call void @llvm.dbg.value(metadata i8* %16, metadata !116, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i64 %15, metadata !117, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32 2, metadata !192, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i8* %16, metadata !111, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !240, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata i8* %12, metadata !247, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !248, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata i8* %16, metadata !249, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata i32 14, metadata !250, metadata !DIExpression()), !dbg !251
  %17 = getelementptr i8, i8* %16, i64 14, !dbg !253
  %18 = icmp ugt i8* %17, %12, !dbg !255
  br i1 %18, label %135, label %19, !dbg !256

19:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %16, metadata !249, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata i8* %17, metadata !111, metadata !DIExpression()), !dbg !225
  %20 = getelementptr inbounds i8, i8* %16, i64 12, !dbg !257
  %21 = bitcast i8* %20 to i16*, !dbg !257
  %22 = load i16, i16* %21, align 1, !dbg !257, !tbaa !258
  call void @llvm.dbg.value(metadata i16 %22, metadata !193, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !225
  %23 = icmp eq i16 %22, 8, !dbg !261
  br i1 %23, label %24, label %135, !dbg !263

24:                                               ; preds = %19
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !264, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i8* %12, metadata !270, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !271, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i8* %17, metadata !272, metadata !DIExpression()), !dbg !274
  %25 = getelementptr i8, i8* %16, i64 34, !dbg !276
  %26 = icmp ugt i8* %25, %12, !dbg !278
  br i1 %26, label %41, label %27, !dbg !279

27:                                               ; preds = %24
  %28 = load i8, i8* %17, align 4, !dbg !280
  %29 = shl i8 %28, 2, !dbg !281
  %30 = and i8 %29, 60, !dbg !281
  call void @llvm.dbg.value(metadata i8 %30, metadata !273, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !274
  %31 = icmp ult i8 %30, 20, !dbg !282
  br i1 %31, label %41, label %32, !dbg !284

32:                                               ; preds = %27
  %33 = zext i8 %30 to i64
  call void @llvm.dbg.value(metadata i64 %33, metadata !273, metadata !DIExpression()), !dbg !274
  %34 = getelementptr i8, i8* %17, i64 %33, !dbg !285
  %35 = icmp ugt i8* %34, %12, !dbg !287
  br i1 %35, label %41, label %36, !dbg !288

36:                                               ; preds = %32
  call void @llvm.dbg.value(metadata i8* %34, metadata !111, metadata !DIExpression()), !dbg !225
  %37 = bitcast i8* %17 to %struct.iphdr*, !dbg !289
  %38 = getelementptr i8, i8* %16, i64 23, !dbg !290
  %39 = load i8, i8* %38, align 1, !dbg !290, !tbaa !291
  %40 = zext i8 %39 to i32, !dbg !293
  br label %41, !dbg !294

41:                                               ; preds = %24, %27, %32, %36
  %42 = phi i8* [ %17, %24 ], [ %17, %27 ], [ %17, %32 ], [ %34, %36 ], !dbg !225
  %43 = phi %struct.iphdr* [ undef, %24 ], [ undef, %27 ], [ undef, %32 ], [ %37, %36 ]
  %44 = phi i32 [ -1, %24 ], [ -1, %27 ], [ -1, %32 ], [ %40, %36 ], !dbg !274
  call void @llvm.dbg.value(metadata i8* %42, metadata !111, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32 %44, metadata !194, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32* null, metadata !195, metadata !DIExpression()), !dbg !225
  %45 = bitcast i32* %2 to i8*, !dbg !295
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %45) #5, !dbg !295
  call void @llvm.dbg.value(metadata i32 1, metadata !197, metadata !DIExpression()), !dbg !225
  store i32 1, i32* %2, align 4, !dbg !296, !tbaa !297
  call void @llvm.dbg.value(metadata i32* %2, metadata !197, metadata !DIExpression(DW_OP_deref)), !dbg !225
  %46 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_puerto_map to i8*), i8* noundef nonnull %45) #5, !dbg !298
  call void @llvm.dbg.value(metadata i8* %46, metadata !195, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32 -1, metadata !198, metadata !DIExpression()), !dbg !225
  %47 = icmp eq i8* %46, null, !dbg !299
  br i1 %47, label %51, label %48, !dbg !301

48:                                               ; preds = %41
  %49 = bitcast i8* %46 to i32*, !dbg !298
  call void @llvm.dbg.value(metadata i32* %49, metadata !195, metadata !DIExpression()), !dbg !225
  %50 = load i32, i32* %49, align 4, !dbg !302, !tbaa !297
  call void @llvm.dbg.value(metadata i32 %50, metadata !198, metadata !DIExpression()), !dbg !225
  br label %51, !dbg !303

51:                                               ; preds = %48, %41
  %52 = phi i32 [ %50, %48 ], [ -1, %41 ], !dbg !225
  call void @llvm.dbg.value(metadata i32 %52, metadata !198, metadata !DIExpression()), !dbg !225
  switch i32 %44, label %133 [
    i32 6, label %53
    i32 17, label %88
  ], !dbg !304

53:                                               ; preds = %51
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !305, metadata !DIExpression()), !dbg !315
  call void @llvm.dbg.value(metadata i8* %12, metadata !311, metadata !DIExpression()), !dbg !315
  call void @llvm.dbg.value(metadata %struct.tcphdr** undef, metadata !312, metadata !DIExpression()), !dbg !315
  call void @llvm.dbg.value(metadata i8* %42, metadata !314, metadata !DIExpression()), !dbg !315
  %54 = getelementptr inbounds i8, i8* %42, i64 20, !dbg !317
  %55 = icmp ugt i8* %54, %12, !dbg !319
  br i1 %55, label %133, label %56, !dbg !320

56:                                               ; preds = %53
  %57 = getelementptr inbounds i8, i8* %42, i64 12, !dbg !321
  %58 = bitcast i8* %57 to i16*, !dbg !321
  %59 = load i16, i16* %58, align 4, !dbg !321
  %60 = lshr i16 %59, 2, !dbg !322
  %61 = and i16 %60, 60, !dbg !322
  %62 = zext i16 %61 to i32, !dbg !322
  call void @llvm.dbg.value(metadata i32 %62, metadata !313, metadata !DIExpression()), !dbg !315
  %63 = icmp ult i16 %61, 8, !dbg !323
  br i1 %63, label %133, label %64, !dbg !325

64:                                               ; preds = %56
  %65 = zext i16 %61 to i64
  %66 = getelementptr i8, i8* %42, i64 %65, !dbg !326
  %67 = icmp ugt i8* %66, %12, !dbg !328
  br i1 %67, label %133, label %68, !dbg !329

68:                                               ; preds = %64
  call void @llvm.dbg.value(metadata i8* %66, metadata !111, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32 %62, metadata !199, metadata !DIExpression()), !dbg !330
  %69 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i64 0, i64 0, !dbg !331
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %69) #5, !dbg !331
  call void @llvm.dbg.declare(metadata [10 x i8]* %3, metadata !202, metadata !DIExpression()), !dbg !331
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(10) %69, i8* noundef nonnull align 1 dereferenceable(10) getelementptr inbounds ([10 x i8], [10 x i8]* @__const.xdp_echo_prog.____fmt, i64 0, i64 0), i64 10, i1 false), !dbg !331
  %70 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %69, i32 noundef 10, i32 noundef %52) #5, !dbg !331
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %69) #5, !dbg !332
  %71 = bitcast i64* %4 to i8*, !dbg !333
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %71) #5, !dbg !333
  call void @llvm.dbg.value(metadata i64 32973504728220996, metadata !207, metadata !DIExpression()), !dbg !334
  store i64 32973504728220996, i64* %4, align 8, !dbg !333
  call void @llvm.dbg.value(metadata i8* %42, metadata !170, metadata !DIExpression()), !dbg !225
  %72 = getelementptr inbounds i8, i8* %42, i64 2, !dbg !333
  %73 = bitcast i8* %72 to i16*, !dbg !333
  %74 = load i16, i16* %73, align 2, !dbg !333, !tbaa !335
  %75 = call i16 @llvm.bswap.i16(i16 %74)
  %76 = zext i16 %75 to i32, !dbg !333
  call void @llvm.dbg.value(metadata i64* %4, metadata !207, metadata !DIExpression(DW_OP_deref)), !dbg !334
  %77 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %71, i32 noundef 8, i32 noundef %76) #5, !dbg !333
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %71) #5, !dbg !337
  %78 = bitcast i64* %5 to i8*, !dbg !338
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %78) #5, !dbg !338
  call void @llvm.dbg.value(metadata i64 28188318020560236, metadata !212, metadata !DIExpression()), !dbg !339
  store i64 28188318020560236, i64* %5, align 8, !dbg !338
  %79 = shl nuw nsw i32 %62, 24, !dbg !338
  call void @llvm.dbg.value(metadata i64* %5, metadata !212, metadata !DIExpression(DW_OP_deref)), !dbg !339
  %80 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %78, i32 noundef 8, i32 noundef %79) #5, !dbg !338
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %78) #5, !dbg !340
  %81 = load i16, i16* %73, align 2, !dbg !341, !tbaa !335
  %82 = trunc i32 %52 to i16, !dbg !342
  %83 = call i16 @llvm.bswap.i16(i16 %82), !dbg !342
  %84 = icmp eq i16 %81, %83, !dbg !343
  br i1 %84, label %85, label %133, !dbg !344

85:                                               ; preds = %68
  %86 = getelementptr inbounds [10 x i8], [10 x i8]* %6, i64 0, i64 0, !dbg !345
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %86) #5, !dbg !345
  call void @llvm.dbg.declare(metadata [10 x i8]* %6, metadata !214, metadata !DIExpression()), !dbg !345
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(10) %86, i8* noundef nonnull align 1 dereferenceable(10) getelementptr inbounds ([10 x i8], [10 x i8]* @__const.xdp_echo_prog.____fmt.3, i64 0, i64 0), i64 10, i1 false), !dbg !345
  %87 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %86, i32 noundef 10) #5, !dbg !345
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %86) #5, !dbg !346
  br label %133, !dbg !347

88:                                               ; preds = %51
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !348, metadata !DIExpression()) #5, !dbg !358
  call void @llvm.dbg.value(metadata i8* %12, metadata !354, metadata !DIExpression()) #5, !dbg !358
  call void @llvm.dbg.value(metadata %struct.udphdr** undef, metadata !355, metadata !DIExpression()) #5, !dbg !358
  call void @llvm.dbg.value(metadata i8* %42, metadata !357, metadata !DIExpression()) #5, !dbg !358
  %89 = getelementptr inbounds i8, i8* %42, i64 8, !dbg !360
  %90 = bitcast i8* %89 to %struct.udphdr*, !dbg !360
  %91 = inttoptr i64 %11 to %struct.udphdr*, !dbg !362
  %92 = icmp ugt %struct.udphdr* %90, %91, !dbg !363
  br i1 %92, label %133, label %93, !dbg !364

93:                                               ; preds = %88
  call void @llvm.dbg.value(metadata %struct.udphdr* %90, metadata !111, metadata !DIExpression()), !dbg !225
  %94 = getelementptr inbounds i8, i8* %42, i64 4, !dbg !365
  %95 = bitcast i8* %94 to i16*, !dbg !365
  %96 = load i16, i16* %95, align 2, !dbg !365, !tbaa !366
  %97 = call i16 @llvm.bswap.i16(i16 %96) #5
  call void @llvm.dbg.value(metadata i16 %97, metadata !356, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #5, !dbg !358
  %98 = icmp ult i16 %97, 8, !dbg !368
  br i1 %98, label %133, label %99, !dbg !370

99:                                               ; preds = %93
  call void @llvm.dbg.value(metadata i16 %97, metadata !356, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #5, !dbg !358
  call void @llvm.dbg.value(metadata i16 %97, metadata !356, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #5, !dbg !358
  call void @llvm.dbg.value(metadata i16 %97, metadata !218, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)), !dbg !371
  call void @llvm.dbg.value(metadata i8* %42, metadata !161, metadata !DIExpression()), !dbg !225
  %100 = getelementptr inbounds i8, i8* %42, i64 2, !dbg !372
  %101 = bitcast i8* %100 to i16*, !dbg !372
  %102 = load i16, i16* %101, align 2, !dbg !372, !tbaa !373
  %103 = trunc i32 %52 to i16
  %104 = call i16 @llvm.bswap.i16(i16 %103)
  %105 = icmp eq i16 %102, %104, !dbg !374
  br i1 %105, label %106, label %131, !dbg !375

106:                                              ; preds = %99
  call void @llvm.dbg.value(metadata i8* %16, metadata !376, metadata !DIExpression()), !dbg !387
  %107 = inttoptr i64 %15 to i16*, !dbg !389
  call void @llvm.dbg.value(metadata i16* %107, metadata !381, metadata !DIExpression()), !dbg !387
  %108 = load i16, i16* %107, align 2, !dbg !390, !tbaa !391
  call void @llvm.dbg.value(metadata i16 %108, metadata !383, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 16)), !dbg !387
  %109 = getelementptr inbounds i8, i8* %16, i64 2, !dbg !392
  %110 = bitcast i8* %109 to i16*, !dbg !392
  %111 = load i16, i16* %110, align 2, !dbg !392, !tbaa !391
  call void @llvm.dbg.value(metadata i16 %111, metadata !383, metadata !DIExpression(DW_OP_LLVM_fragment, 16, 16)), !dbg !387
  %112 = getelementptr inbounds i8, i8* %16, i64 4, !dbg !393
  %113 = bitcast i8* %112 to i16*, !dbg !393
  %114 = load i16, i16* %113, align 2, !dbg !393, !tbaa !391
  call void @llvm.dbg.value(metadata i16 %114, metadata !383, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 16)), !dbg !387
  %115 = getelementptr inbounds i8, i8* %16, i64 6, !dbg !394
  %116 = bitcast i8* %115 to i16*, !dbg !394
  %117 = load i16, i16* %116, align 2, !dbg !394, !tbaa !391
  store i16 %117, i16* %107, align 2, !dbg !395, !tbaa !391
  %118 = getelementptr inbounds i8, i8* %16, i64 8, !dbg !396
  %119 = bitcast i8* %118 to i16*, !dbg !396
  %120 = load i16, i16* %119, align 2, !dbg !396, !tbaa !391
  store i16 %120, i16* %110, align 2, !dbg !397, !tbaa !391
  %121 = getelementptr inbounds i8, i8* %16, i64 10, !dbg !398
  %122 = bitcast i8* %121 to i16*, !dbg !398
  %123 = load i16, i16* %122, align 2, !dbg !398, !tbaa !391
  store i16 %123, i16* %113, align 2, !dbg !399, !tbaa !391
  store i16 %108, i16* %116, align 2, !dbg !400, !tbaa !391
  store i16 %111, i16* %119, align 2, !dbg !401, !tbaa !391
  store i16 %114, i16* %122, align 2, !dbg !402, !tbaa !391
  call void @llvm.dbg.value(metadata %struct.iphdr* %43, metadata !131, metadata !DIExpression()), !dbg !225
  %124 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %43, i64 0, i32 8, i32 0, i32 0, !dbg !403
  %125 = load i32, i32* %124, align 4, !dbg !403, !tbaa !404
  call void @llvm.dbg.value(metadata i32 %125, metadata !221, metadata !DIExpression()), !dbg !405
  %126 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %43, i64 0, i32 8, i32 0, i32 1, !dbg !406
  %127 = load i32, i32* %126, align 4, !dbg !406, !tbaa !404
  store i32 %127, i32* %124, align 4, !dbg !407, !tbaa !404
  store i32 %125, i32* %126, align 4, !dbg !408, !tbaa !404
  call void @llvm.dbg.value(metadata i8* %42, metadata !161, metadata !DIExpression()), !dbg !225
  %128 = bitcast i8* %42 to i16*, !dbg !409
  %129 = load i16, i16* %128, align 2, !dbg !409, !tbaa !410
  call void @llvm.dbg.value(metadata i16 %129, metadata !224, metadata !DIExpression()), !dbg !405
  %130 = load i16, i16* %101, align 2, !dbg !411, !tbaa !373
  store i16 %130, i16* %128, align 2, !dbg !412, !tbaa !410
  store i16 %129, i16* %101, align 2, !dbg !413, !tbaa !373
  br label %133

131:                                              ; preds = %99
  %132 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 noundef %8, i64 noundef 0) #5, !dbg !414
  br label %133, !dbg !415

133:                                              ; preds = %93, %88, %64, %56, %53, %51, %106, %131, %85, %68
  %134 = phi i32 [ 1, %85 ], [ 2, %68 ], [ 3, %106 ], [ %132, %131 ], [ 2, %51 ], [ 2, %53 ], [ 2, %56 ], [ 2, %64 ], [ 2, %88 ], [ 2, %93 ], !dbg !225
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %45) #5, !dbg !416
  br label %135

135:                                              ; preds = %1, %19, %133
  %136 = phi i32 [ %134, %133 ], [ 2, %19 ], [ 2, %1 ], !dbg !225
  ret i32 %136, !dbg !416
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

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
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 156, type: !55, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !45, globals: !52, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_echo.c", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "c9c34347741731ccbc2fa651ade461e5")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
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
!45 = !{!46, !47, !48, !51}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !49, line: 24, baseType: !50)
!49 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!50 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !49, line: 27, baseType: !7)
!52 = !{!0, !53, !63, !69, !77, !85}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "xdp_puerto_map", scope: !2, file: !3, line: 163, type: !55, isLocal: false, isDefinition: true)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !56, line: 33, size: 160, elements: !57)
!56 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!57 = !{!58, !59, !60, !61, !62}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !55, file: !56, line: 34, baseType: !7, size: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !55, file: !56, line: 35, baseType: !7, size: 32, offset: 32)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !55, file: !56, line: 36, baseType: !7, size: 32, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !55, file: !56, line: 37, baseType: !7, size: 32, offset: 96)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !55, file: !56, line: 38, baseType: !7, size: 32, offset: 128)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 271, type: !65, isLocal: false, isDefinition: true)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 32, elements: !67)
!66 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!67 = !{!68}
!68 = !DISubrange(count: 4)
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !71, line: 33, type: !72, isLocal: true, isDefinition: true)
!71 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/amartin/tfg/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DISubroutineType(types: !74)
!74 = !{!46, !46, !75}
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !71, line: 152, type: !79, isLocal: true, isDefinition: true)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = !DISubroutineType(types: !81)
!81 = !{!82, !83, !51, null}
!82 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !66)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !71, line: 1254, type: !87, isLocal: true, isDefinition: true)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DISubroutineType(types: !89)
!89 = !{!82, !46, !51, !90}
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !49, line: 31, baseType: !91)
!91 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!92 = !{i32 7, !"Dwarf Version", i32 5}
!93 = !{i32 2, !"Debug Info Version", i32 3}
!94 = !{i32 1, !"wchar_size", i32 4}
!95 = !{i32 7, !"frame-pointer", i32 2}
!96 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!97 = distinct !DISubprogram(name: "xdp_echo_prog", scope: !3, file: !3, line: 171, type: !98, scopeLine: 172, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !108)
!98 = !DISubroutineType(types: !99)
!99 = !{!82, !100}
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !102)
!102 = !{!103, !104, !105, !106, !107}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !101, file: !6, line: 2857, baseType: !51, size: 32)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !101, file: !6, line: 2858, baseType: !51, size: 32, offset: 32)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !101, file: !6, line: 2859, baseType: !51, size: 32, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !101, file: !6, line: 2861, baseType: !51, size: 32, offset: 96)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !101, file: !6, line: 2862, baseType: !51, size: 32, offset: 128)
!108 = !{!109, !110, !111, !115, !116, !117, !131, !161, !170, !192, !193, !194, !195, !197, !198, !199, !202, !207, !212, !214, !218, !221, !224}
!109 = !DILocalVariable(name: "ctx", arg: 1, scope: !97, file: !3, line: 171, type: !100)
!110 = !DILocalVariable(name: "index", scope: !97, file: !3, line: 174, type: !82)
!111 = !DILocalVariable(name: "nh", scope: !97, file: !3, line: 175, type: !112)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !3, line: 16, size: 64, elements: !113)
!113 = !{!114}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !112, file: !3, line: 17, baseType: !46, size: 64)
!115 = !DILocalVariable(name: "data_end", scope: !97, file: !3, line: 176, type: !46)
!116 = !DILocalVariable(name: "data", scope: !97, file: !3, line: 177, type: !46)
!117 = !DILocalVariable(name: "eth", scope: !97, file: !3, line: 178, type: !118)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!119 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !120, line: 168, size: 112, elements: !121)
!120 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!121 = !{!122, !127, !128}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !119, file: !120, line: 169, baseType: !123, size: 48)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !124, size: 48, elements: !125)
!124 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!125 = !{!126}
!126 = !DISubrange(count: 6)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !119, file: !120, line: 170, baseType: !123, size: 48, offset: 48)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !119, file: !120, line: 171, baseType: !129, size: 16, offset: 96)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !130, line: 25, baseType: !48)
!130 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!131 = !DILocalVariable(name: "iph", scope: !97, file: !3, line: 179, type: !132)
!132 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!133 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !134, line: 87, size: 160, elements: !135)
!134 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "042b09a58768855e3578a0a8eba49be7")
!135 = !{!136, !138, !139, !140, !141, !142, !143, !144, !145, !147}
!136 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !133, file: !134, line: 89, baseType: !137, size: 4, flags: DIFlagBitField, extraData: i64 0)
!137 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !49, line: 21, baseType: !124)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !133, file: !134, line: 90, baseType: !137, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !133, file: !134, line: 97, baseType: !137, size: 8, offset: 8)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !133, file: !134, line: 98, baseType: !129, size: 16, offset: 16)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !133, file: !134, line: 99, baseType: !129, size: 16, offset: 32)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !133, file: !134, line: 100, baseType: !129, size: 16, offset: 48)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !133, file: !134, line: 101, baseType: !137, size: 8, offset: 64)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !133, file: !134, line: 102, baseType: !137, size: 8, offset: 72)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !133, file: !134, line: 103, baseType: !146, size: 16, offset: 80)
!146 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !130, line: 31, baseType: !48)
!147 = !DIDerivedType(tag: DW_TAG_member, scope: !133, file: !134, line: 104, baseType: !148, size: 64, offset: 96)
!148 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !133, file: !134, line: 104, size: 64, elements: !149)
!149 = !{!150, !156}
!150 = !DIDerivedType(tag: DW_TAG_member, scope: !148, file: !134, line: 104, baseType: !151, size: 64)
!151 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !148, file: !134, line: 104, size: 64, elements: !152)
!152 = !{!153, !155}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !151, file: !134, line: 104, baseType: !154, size: 32)
!154 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !130, line: 27, baseType: !51)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !151, file: !134, line: 104, baseType: !154, size: 32, offset: 32)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !148, file: !134, line: 104, baseType: !157, size: 64)
!157 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !148, file: !134, line: 104, size: 64, elements: !158)
!158 = !{!159, !160}
!159 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !157, file: !134, line: 104, baseType: !154, size: 32)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !157, file: !134, line: 104, baseType: !154, size: 32, offset: 32)
!161 = !DILocalVariable(name: "udph", scope: !97, file: !3, line: 180, type: !162)
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !164, line: 23, size: 64, elements: !165)
!164 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!165 = !{!166, !167, !168, !169}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !163, file: !164, line: 24, baseType: !129, size: 16)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !163, file: !164, line: 25, baseType: !129, size: 16, offset: 16)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !163, file: !164, line: 26, baseType: !129, size: 16, offset: 32)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !163, file: !164, line: 27, baseType: !146, size: 16, offset: 48)
!170 = !DILocalVariable(name: "tcph", scope: !97, file: !3, line: 181, type: !171)
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !173, line: 25, size: 160, elements: !174)
!173 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "8d74bf2133e7b3dab885994b9916aa13")
!174 = !{!175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !172, file: !173, line: 26, baseType: !129, size: 16)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !172, file: !173, line: 27, baseType: !129, size: 16, offset: 16)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !172, file: !173, line: 28, baseType: !154, size: 32, offset: 32)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !172, file: !173, line: 29, baseType: !154, size: 32, offset: 64)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !172, file: !173, line: 31, baseType: !48, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !172, file: !173, line: 32, baseType: !48, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !172, file: !173, line: 33, baseType: !48, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !172, file: !173, line: 34, baseType: !48, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !172, file: !173, line: 35, baseType: !48, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !172, file: !173, line: 36, baseType: !48, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !172, file: !173, line: 37, baseType: !48, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !172, file: !173, line: 38, baseType: !48, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !172, file: !173, line: 39, baseType: !48, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !172, file: !173, line: 40, baseType: !48, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !172, file: !173, line: 55, baseType: !129, size: 16, offset: 112)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !172, file: !173, line: 56, baseType: !146, size: 16, offset: 128)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !172, file: !173, line: 57, baseType: !129, size: 16, offset: 144)
!192 = !DILocalVariable(name: "action", scope: !97, file: !3, line: 183, type: !51)
!193 = !DILocalVariable(name: "nh_type", scope: !97, file: !3, line: 184, type: !82)
!194 = !DILocalVariable(name: "nh_proto", scope: !97, file: !3, line: 189, type: !82)
!195 = !DILocalVariable(name: "puerto1", scope: !97, file: !3, line: 191, type: !196)
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!197 = !DILocalVariable(name: "key_puerto", scope: !97, file: !3, line: 192, type: !82)
!198 = !DILocalVariable(name: "valor_puerto", scope: !97, file: !3, line: 194, type: !82)
!199 = !DILocalVariable(name: "l", scope: !200, file: !3, line: 200, type: !82)
!200 = distinct !DILexicalBlock(scope: !201, file: !3, line: 199, column: 31)
!201 = distinct !DILexicalBlock(scope: !97, file: !3, line: 199, column: 6)
!202 = !DILocalVariable(name: "____fmt", scope: !203, file: !3, line: 205, type: !204)
!203 = distinct !DILexicalBlock(scope: !200, file: !3, line: 205, column: 3)
!204 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 80, elements: !205)
!205 = !{!206}
!206 = !DISubrange(count: 10)
!207 = !DILocalVariable(name: "____fmt", scope: !208, file: !3, line: 206, type: !209)
!208 = distinct !DILexicalBlock(scope: !200, file: !3, line: 206, column: 3)
!209 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 64, elements: !210)
!210 = !{!211}
!211 = !DISubrange(count: 8)
!212 = !DILocalVariable(name: "____fmt", scope: !213, file: !3, line: 207, type: !209)
!213 = distinct !DILexicalBlock(scope: !200, file: !3, line: 207, column: 3)
!214 = !DILocalVariable(name: "____fmt", scope: !215, file: !3, line: 210, type: !204)
!215 = distinct !DILexicalBlock(scope: !216, file: !3, line: 210, column: 4)
!216 = distinct !DILexicalBlock(scope: !217, file: !3, line: 208, column: 46)
!217 = distinct !DILexicalBlock(scope: !200, file: !3, line: 208, column: 7)
!218 = !DILocalVariable(name: "l", scope: !219, file: !3, line: 217, type: !82)
!219 = distinct !DILexicalBlock(scope: !220, file: !3, line: 216, column: 31)
!220 = distinct !DILexicalBlock(scope: !97, file: !3, line: 216, column: 6)
!221 = !DILocalVariable(name: "aux", scope: !222, file: !3, line: 224, type: !51)
!222 = distinct !DILexicalBlock(scope: !223, file: !3, line: 222, column: 42)
!223 = distinct !DILexicalBlock(scope: !219, file: !3, line: 222, column: 6)
!224 = !DILocalVariable(name: "aux2", scope: !222, file: !3, line: 227, type: !48)
!225 = !DILocation(line: 0, scope: !97)
!226 = !DILocation(line: 174, column: 19, scope: !97)
!227 = !{!228, !229, i64 16}
!228 = !{!"xdp_md", !229, i64 0, !229, i64 4, !229, i64 8, !229, i64 12, !229, i64 16}
!229 = !{!"int", !230, i64 0}
!230 = !{!"omnipotent char", !231, i64 0}
!231 = !{!"Simple C/C++ TBAA"}
!232 = !DILocation(line: 176, column: 39, scope: !97)
!233 = !{!228, !229, i64 4}
!234 = !DILocation(line: 176, column: 28, scope: !97)
!235 = !DILocation(line: 176, column: 20, scope: !97)
!236 = !DILocation(line: 177, column: 34, scope: !97)
!237 = !{!228, !229, i64 0}
!238 = !DILocation(line: 177, column: 23, scope: !97)
!239 = !DILocation(line: 177, column: 15, scope: !97)
!240 = !DILocalVariable(name: "nh", arg: 1, scope: !241, file: !3, line: 46, type: !244)
!241 = distinct !DISubprogram(name: "parse_ethhdr", scope: !3, file: !3, line: 46, type: !242, scopeLine: 47, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !246)
!242 = !DISubroutineType(types: !243)
!243 = !{!82, !244, !46, !245}
!244 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!245 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!246 = !{!240, !247, !248, !249, !250}
!247 = !DILocalVariable(name: "data_end", arg: 2, scope: !241, file: !3, line: 46, type: !46)
!248 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !241, file: !3, line: 46, type: !245)
!249 = !DILocalVariable(name: "eth", scope: !241, file: !3, line: 48, type: !118)
!250 = !DILocalVariable(name: "hdrsize", scope: !241, file: !3, line: 49, type: !82)
!251 = !DILocation(line: 0, scope: !241, inlinedAt: !252)
!252 = distinct !DILocation(line: 186, column: 12, scope: !97)
!253 = !DILocation(line: 50, column: 14, scope: !254, inlinedAt: !252)
!254 = distinct !DILexicalBlock(scope: !241, file: !3, line: 50, column: 6)
!255 = !DILocation(line: 50, column: 19, scope: !254, inlinedAt: !252)
!256 = !DILocation(line: 50, column: 6, scope: !241, inlinedAt: !252)
!257 = !DILocation(line: 56, column: 14, scope: !241, inlinedAt: !252)
!258 = !{!259, !260, i64 12}
!259 = !{!"ethhdr", !230, i64 0, !230, i64 6, !260, i64 12}
!260 = !{!"short", !230, i64 0}
!261 = !DILocation(line: 187, column: 14, scope: !262)
!262 = distinct !DILexicalBlock(scope: !97, file: !3, line: 187, column: 6)
!263 = !DILocation(line: 187, column: 6, scope: !97)
!264 = !DILocalVariable(name: "nh", arg: 1, scope: !265, file: !3, line: 59, type: !244)
!265 = distinct !DISubprogram(name: "parse_iphdr", scope: !3, file: !3, line: 59, type: !266, scopeLine: 60, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !269)
!266 = !DISubroutineType(types: !267)
!267 = !{!82, !244, !46, !268}
!268 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !132, size: 64)
!269 = !{!264, !270, !271, !272, !273}
!270 = !DILocalVariable(name: "data_end", arg: 2, scope: !265, file: !3, line: 59, type: !46)
!271 = !DILocalVariable(name: "iphdr", arg: 3, scope: !265, file: !3, line: 59, type: !268)
!272 = !DILocalVariable(name: "iph", scope: !265, file: !3, line: 61, type: !132)
!273 = !DILocalVariable(name: "hdrsize", scope: !265, file: !3, line: 62, type: !82)
!274 = !DILocation(line: 0, scope: !265, inlinedAt: !275)
!275 = distinct !DILocation(line: 190, column: 11, scope: !97)
!276 = !DILocation(line: 64, column: 10, scope: !277, inlinedAt: !275)
!277 = distinct !DILexicalBlock(scope: !265, file: !3, line: 64, column: 6)
!278 = !DILocation(line: 64, column: 14, scope: !277, inlinedAt: !275)
!279 = !DILocation(line: 64, column: 6, scope: !265, inlinedAt: !275)
!280 = !DILocation(line: 67, column: 17, scope: !265, inlinedAt: !275)
!281 = !DILocation(line: 67, column: 21, scope: !265, inlinedAt: !275)
!282 = !DILocation(line: 69, column: 13, scope: !283, inlinedAt: !275)
!283 = distinct !DILexicalBlock(scope: !265, file: !3, line: 69, column: 5)
!284 = !DILocation(line: 69, column: 5, scope: !265, inlinedAt: !275)
!285 = !DILocation(line: 73, column: 14, scope: !286, inlinedAt: !275)
!286 = distinct !DILexicalBlock(scope: !265, file: !3, line: 73, column: 6)
!287 = !DILocation(line: 73, column: 24, scope: !286, inlinedAt: !275)
!288 = !DILocation(line: 73, column: 6, scope: !265, inlinedAt: !275)
!289 = !DILocation(line: 77, column: 9, scope: !265, inlinedAt: !275)
!290 = !DILocation(line: 79, column: 14, scope: !265, inlinedAt: !275)
!291 = !{!292, !230, i64 9}
!292 = !{!"iphdr", !230, i64 0, !230, i64 0, !230, i64 1, !260, i64 2, !260, i64 4, !260, i64 6, !230, i64 8, !230, i64 9, !260, i64 10, !230, i64 12}
!293 = !DILocation(line: 79, column: 9, scope: !265, inlinedAt: !275)
!294 = !DILocation(line: 79, column: 2, scope: !265, inlinedAt: !275)
!295 = !DILocation(line: 192, column: 2, scope: !97)
!296 = !DILocation(line: 192, column: 6, scope: !97)
!297 = !{!229, !229, i64 0}
!298 = !DILocation(line: 193, column: 12, scope: !97)
!299 = !DILocation(line: 195, column: 12, scope: !300)
!300 = distinct !DILexicalBlock(scope: !97, file: !3, line: 195, column: 5)
!301 = !DILocation(line: 195, column: 5, scope: !97)
!302 = !DILocation(line: 196, column: 18, scope: !300)
!303 = !DILocation(line: 196, column: 3, scope: !300)
!304 = !DILocation(line: 199, column: 6, scope: !97)
!305 = !DILocalVariable(name: "nh", arg: 1, scope: !306, file: !3, line: 119, type: !244)
!306 = distinct !DISubprogram(name: "parse_tcphdr", scope: !3, file: !3, line: 119, type: !307, scopeLine: 120, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !310)
!307 = !DISubroutineType(types: !308)
!308 = !{!82, !244, !46, !309}
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !171, size: 64)
!310 = !{!305, !311, !312, !313, !314}
!311 = !DILocalVariable(name: "data_end", arg: 2, scope: !306, file: !3, line: 119, type: !46)
!312 = !DILocalVariable(name: "tcphdr", arg: 3, scope: !306, file: !3, line: 119, type: !309)
!313 = !DILocalVariable(name: "len", scope: !306, file: !3, line: 121, type: !82)
!314 = !DILocalVariable(name: "h", scope: !306, file: !3, line: 122, type: !171)
!315 = !DILocation(line: 0, scope: !306, inlinedAt: !316)
!316 = distinct !DILocation(line: 202, column: 7, scope: !200)
!317 = !DILocation(line: 124, column: 8, scope: !318, inlinedAt: !316)
!318 = distinct !DILexicalBlock(scope: !306, file: !3, line: 124, column: 6)
!319 = !DILocation(line: 124, column: 12, scope: !318, inlinedAt: !316)
!320 = !DILocation(line: 124, column: 6, scope: !306, inlinedAt: !316)
!321 = !DILocation(line: 127, column: 11, scope: !306, inlinedAt: !316)
!322 = !DILocation(line: 127, column: 16, scope: !306, inlinedAt: !316)
!323 = !DILocation(line: 129, column: 9, scope: !324, inlinedAt: !316)
!324 = distinct !DILexicalBlock(scope: !306, file: !3, line: 129, column: 5)
!325 = !DILocation(line: 129, column: 5, scope: !306, inlinedAt: !316)
!326 = !DILocation(line: 133, column: 14, scope: !327, inlinedAt: !316)
!327 = distinct !DILexicalBlock(scope: !306, file: !3, line: 133, column: 6)
!328 = !DILocation(line: 133, column: 20, scope: !327, inlinedAt: !316)
!329 = !DILocation(line: 133, column: 6, scope: !306, inlinedAt: !316)
!330 = !DILocation(line: 0, scope: !200)
!331 = !DILocation(line: 205, column: 3, scope: !203)
!332 = !DILocation(line: 205, column: 3, scope: !200)
!333 = !DILocation(line: 206, column: 3, scope: !208)
!334 = !DILocation(line: 0, scope: !208)
!335 = !{!336, !260, i64 2}
!336 = !{!"tcphdr", !260, i64 0, !260, i64 2, !229, i64 4, !229, i64 8, !260, i64 12, !260, i64 12, !260, i64 13, !260, i64 13, !260, i64 13, !260, i64 13, !260, i64 13, !260, i64 13, !260, i64 13, !260, i64 13, !260, i64 14, !260, i64 16, !260, i64 18}
!337 = !DILocation(line: 206, column: 3, scope: !200)
!338 = !DILocation(line: 207, column: 3, scope: !213)
!339 = !DILocation(line: 0, scope: !213)
!340 = !DILocation(line: 207, column: 3, scope: !200)
!341 = !DILocation(line: 208, column: 13, scope: !217)
!342 = !DILocation(line: 208, column: 21, scope: !217)
!343 = !DILocation(line: 208, column: 18, scope: !217)
!344 = !DILocation(line: 208, column: 7, scope: !200)
!345 = !DILocation(line: 210, column: 4, scope: !215)
!346 = !DILocation(line: 210, column: 4, scope: !216)
!347 = !DILocation(line: 211, column: 4, scope: !216)
!348 = !DILocalVariable(name: "nh", arg: 1, scope: !349, file: !3, line: 101, type: !244)
!349 = distinct !DISubprogram(name: "parse_udphdr", scope: !3, file: !3, line: 101, type: !350, scopeLine: 102, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !353)
!350 = !DISubroutineType(types: !351)
!351 = !{!82, !244, !46, !352}
!352 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!353 = !{!348, !354, !355, !356, !357}
!354 = !DILocalVariable(name: "data_end", arg: 2, scope: !349, file: !3, line: 101, type: !46)
!355 = !DILocalVariable(name: "udphdr", arg: 3, scope: !349, file: !3, line: 101, type: !352)
!356 = !DILocalVariable(name: "len", scope: !349, file: !3, line: 103, type: !82)
!357 = !DILocalVariable(name: "h", scope: !349, file: !3, line: 104, type: !162)
!358 = !DILocation(line: 0, scope: !349, inlinedAt: !359)
!359 = distinct !DILocation(line: 218, column: 6, scope: !219)
!360 = !DILocation(line: 106, column: 8, scope: !361, inlinedAt: !359)
!361 = distinct !DILexicalBlock(scope: !349, file: !3, line: 106, column: 6)
!362 = !DILocation(line: 106, column: 14, scope: !361, inlinedAt: !359)
!363 = !DILocation(line: 106, column: 12, scope: !361, inlinedAt: !359)
!364 = !DILocation(line: 106, column: 6, scope: !349, inlinedAt: !359)
!365 = !DILocation(line: 112, column: 8, scope: !349, inlinedAt: !359)
!366 = !{!367, !260, i64 4}
!367 = !{!"udphdr", !260, i64 0, !260, i64 2, !260, i64 4, !260, i64 6}
!368 = !DILocation(line: 113, column: 10, scope: !369, inlinedAt: !359)
!369 = distinct !DILexicalBlock(scope: !349, file: !3, line: 113, column: 6)
!370 = !DILocation(line: 113, column: 6, scope: !349, inlinedAt: !359)
!371 = !DILocation(line: 0, scope: !219)
!372 = !DILocation(line: 222, column: 12, scope: !223)
!373 = !{!367, !260, i64 2}
!374 = !DILocation(line: 222, column: 16, scope: !223)
!375 = !DILocation(line: 222, column: 6, scope: !219)
!376 = !DILocalVariable(name: "data", arg: 1, scope: !377, file: !3, line: 29, type: !46)
!377 = distinct !DISubprogram(name: "swap_src_dst_mac", scope: !3, file: !3, line: 29, type: !378, scopeLine: 30, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !380)
!378 = !DISubroutineType(types: !379)
!379 = !{null, !46}
!380 = !{!376, !381, !383}
!381 = !DILocalVariable(name: "p", scope: !377, file: !3, line: 31, type: !382)
!382 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!383 = !DILocalVariable(name: "dst", scope: !377, file: !3, line: 32, type: !384)
!384 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 48, elements: !385)
!385 = !{!386}
!386 = !DISubrange(count: 3)
!387 = !DILocation(line: 0, scope: !377, inlinedAt: !388)
!388 = distinct !DILocation(line: 223, column: 3, scope: !222)
!389 = !DILocation(line: 31, column: 22, scope: !377, inlinedAt: !388)
!390 = !DILocation(line: 34, column: 11, scope: !377, inlinedAt: !388)
!391 = !{!260, !260, i64 0}
!392 = !DILocation(line: 35, column: 11, scope: !377, inlinedAt: !388)
!393 = !DILocation(line: 36, column: 11, scope: !377, inlinedAt: !388)
!394 = !DILocation(line: 37, column: 9, scope: !377, inlinedAt: !388)
!395 = !DILocation(line: 37, column: 7, scope: !377, inlinedAt: !388)
!396 = !DILocation(line: 38, column: 9, scope: !377, inlinedAt: !388)
!397 = !DILocation(line: 38, column: 7, scope: !377, inlinedAt: !388)
!398 = !DILocation(line: 39, column: 9, scope: !377, inlinedAt: !388)
!399 = !DILocation(line: 39, column: 7, scope: !377, inlinedAt: !388)
!400 = !DILocation(line: 40, column: 7, scope: !377, inlinedAt: !388)
!401 = !DILocation(line: 41, column: 7, scope: !377, inlinedAt: !388)
!402 = !DILocation(line: 42, column: 7, scope: !377, inlinedAt: !388)
!403 = !DILocation(line: 224, column: 18, scope: !222)
!404 = !{!230, !230, i64 0}
!405 = !DILocation(line: 0, scope: !222)
!406 = !DILocation(line: 225, column: 19, scope: !222)
!407 = !DILocation(line: 225, column: 13, scope: !222)
!408 = !DILocation(line: 226, column: 13, scope: !222)
!409 = !DILocation(line: 227, column: 20, scope: !222)
!410 = !{!367, !260, i64 0}
!411 = !DILocation(line: 228, column: 29, scope: !222)
!412 = !DILocation(line: 228, column: 22, scope: !222)
!413 = !DILocation(line: 229, column: 20, scope: !222)
!414 = !DILocation(line: 232, column: 9, scope: !219)
!415 = !DILocation(line: 232, column: 2, scope: !219)
!416 = !DILocation(line: 269, column: 1, scope: !97)
