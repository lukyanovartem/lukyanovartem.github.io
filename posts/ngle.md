---
title: NGLE
published: 01.01.2015
tags: ретро
---
Удалось отреверсить бинарь, отвечающий за ускорение графики, а именно копирование области (скроллинг) на старых машинах HP PA-RISC навроде HP 9000/712 и 715 и их графических картах именуемых HP Artist. Производитель поставлял этот бинарь в старых релизах X11, в вендорном варианте под названием Xhp. Исходники были открыты, за исключением бинаря. Позже функционал был предоставлен в ассемблерном варианте в рамках проекта MkLinux. Проприетарастия как она есть

Листинг с добавленными комментариями  
Функция ngleDepth24_CopyAreaFromToScreen аналогична, за исключением инициализации регистра reg10: write4(-0x445f6000,reg10)
```asm
.import ngleScreenPrivIndex,data

ngleDepth8_CopyAreaFromToScreen
    ldo 0x40(sp),sp
    stw arg0,-0x64(sp) ;pSrcDraw
    stw arg1,-0x68(sp) ;pDstDraw
    stw arg2,-0x6c(sp) ;pptSrc->x
    stw arg3,-0x70(sp) ;pptSrc->y
    ldw -0x68(sp),r1  ;pDstDraw
    ldw 0x10(r1),r31  ;->pScreen
    ldw 0x19c(r31),t4 ;->devPrivates
    ldil L%ngleScreenPrivIndex,t3
    ldw  R%ngleScreenPrivIndex(t3),t3
    ldwx,s t3(t4),t2 ;devPrivates[ngleScreenPrivIndex].ptr => NgleScreenPrivPtr pScreenPriv
    stw t2,-0x38(sp)
    ldw -0x38(sp),t1 ;pScreenPriv
    ldw 0x14(t1),r1  ;->pDregs
    stw r1,-0x34(sp)
    ldw -0x34(sp),r31
    zdepi 1,10,1,t4
    add t4,r31,t3 ;pDregs+0x200000 => REG_15b0
    stw t3,-0x28(sp)
    ldw -0x28(sp),t2
;SETUP_HW()
$$$$ngle2:
    ldb 0(t2),t1 ;read1(REG_15b0) => val1
    extrs t1,31,8,r1
    stb r1,-0x2c(sp)
    ldb -0x2c(sp),r31
    extrs r31,31,8,t4
    comibf,=,n 0,t4,$$$$ngle1 ;if (val1) goto ngle1
    ldw -0x28(sp),t3
    ldb 0(t3),t2 ;read1(REG_15b0) => val1
    extrs t2,31,8,t1
    stb t1,-0x2c(sp)
$$$$ngle1:
    ldb -0x2c(sp),r1
    extrs r1,31,8,r31
    comibf,=,n 0,r31,$$$$ngle2 ;if (val1) goto ngle2
;
    ldw -0x28(sp),t2
    ldw -0x38(sp),t4 ;pScreenPriv
    ldw 0x10(t4),t3  ;->deviceID
    .word 0x22B88578    /*  ldil 0x2bcb0000,t2 */
    ldo 0x15a(t2),t1
    combf,=,n t3,t1,$$$$ngle3 ;if (deviceID != S9000_ID_HCRX) goto ngle3
    ldw -0x34(sp),r1
    .word 0x23e10274    /* ldil 0x13a02000,r31 */
    .word 0x282c0000    /* addil 0x18000,r1 */
    stw r31,0(r1) ;write4(0x13a02000,REG_10)
    b $$$$ngle4
    ldw -0x78(sp),t2 ;arg5 = alu
$$$$ngle3:
    ldw -0x34(sp),t4
    .word 0x22802274    /* ldil 0x13a01000,t3 */
    .word 0x2a6c0000    /* addil 0x18000,t4 */
    stw t3,0(r1) ;write4(0x13a01000,REG_10)
    ldw -0x78(sp),t2
$$$$ngle4:
    .word 0x23e00460    /* ldil 0x23000000,r31 */
    zdep t2,23,4,r1 ;(alu << (31-23)) & 0x00000f00
    or r1,r31,t4    ;| 0x23000000 => val2
    ldw -0x34(sp),t3
    .word 0x2a8c0000    /* addil 0x18000,t3 */
    stw t4,0x1c(r1) ;write4(val2,REG_14)
    ldw -0x34(sp),t2
    ldw -0x7c(sp),t1 ;arg6 = planeMask
    .word 0x2aac0000    /* addil 0x18000,t2 */
    stw t1,0x18(r1) ;write4(planeMask,REG_13)
    ldw -0x6c(sp),r1
    sth r1,-0x30(sp) ;x
    ldw -0x70(sp),r31
    sth r31,-0x2e(sp) ;y
    ldw -0x34(sp),t4
    ldw -0x30(sp),t3
    stw t3,0x808(t4) ;write4((x << 16) | y,REG_24)
    ldw -0x74(sp),t2 ;arg4 = pbox
    ldh 4(t2),t1     ;->x2
    extrs t1,31,16,r1
    ldw -0x74(sp),r31 ;pbox
    ldh 0(r31),t4     ;->x1
    extrs t4,31,16,t3
    sub r1,t3,t2
    sth t2,-0x30(sp) ;x2 - x1 => w
    ldw -0x74(sp),t1 ;pbox
    ldh 6(t1),r1     ;->y2
    extrs r1,31,16,r31
    ldw -0x74(sp),t4 ;pbox
    ldh 2(t4),t3     ;->y1
    extrs t3,31,16,t2
    sub r31,t2,t1
    sth t1,-0x2e(sp) ;y2 - y1 => h
    ldw -0x34(sp),r1
    ldw -0x30(sp),r31
    stw r31,0x804(r1) ;write4((w << 16) | h,REG_7)
    ldw -0x74(sp),t4 ;pbox
    ldh 0(t4),t3     ;->x1
    extrs t3,31,16,t2
    sth t2,-0x30(sp)
    ldw -0x74(sp),t1 ;pbox
    ldh 2(t1),r1     ;->y1
    extrs r1,31,16,r31
    sth r31,-0x2e(sp)
    ldw -0x34(sp),t4
    ldw -0x30(sp),t3
    stw t3,0xb00(t4) ;write4((x1 << 16) | y1,REG_25)
    bv r0(rp)
    ldo -0x40(sp),sp
```

Итоговый файл ngledoblt.c для использования с вендорным cfb X сервером версии X11R6.3
```c
void ngleDepth8_CopyAreaFromToScreen(DrawablePtr pSrcDraw, DrawablePtr pDstDraw,
                short srcx, short srcy, BoxPtr pbox, int alu, unsigned long planeMask)
{
        NgleScreenPrivPtr   pScreenPriv;
        NgleHdwPtr          pDregs;

        pScreenPriv = NGLE_SCREEN_PRIV(pDstDraw->pScreen);
        pDregs = (NgleHdwPtr) pScreenPriv->pDregs;

        SETUP_HW(pDregs);

        if (pScreenPriv->deviceID != S9000_ID_HCRX)
             pDregs->reg10 = 0x13a01000;
        else
             pDregs->reg10 = 0x13a02000;

        pDregs->reg14.all = ((alu << 8) & 0x00000f00) | 0x23000000; // raster op
        pDregs->reg13 = planeMask;

        pDregs->reg24.all = (srcx << 16) | srcy;
        pDregs->reg7.all = ((pbox->x2 - pbox->x1) << 16) | (pbox->y2 - pbox->y1);
        pDregs->reg25.all = (pbox->x1 << 16) | pbox->y1; // destination
}
```
Тест x11perf под MkLinux, показывающий прирост скорости от аппаратного ускорения

| Type | scroll10 | scroll100 | scroll500 | copywinwin10 | copywinwin100 | copywinwin500 |
|:----:|:--------:|:---------:|:---------:|:------------:|:-------------:|:-------------:|
| soft | 12300    | 457       | 21        | 15700        | 432           | 20            |
| hw   | 26700    | 3380      | 157       | 26800        | 3380          | 158           |
