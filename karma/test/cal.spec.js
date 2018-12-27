describe('cal test suit',function(){
    it('test cal add',function(){
        var ret = cal(40,2,'add');
        expect(ret).toEqual(42);
    });

    it('test cal mul',function(){
        var ret = cal(21,2,'mul');
        expect(ret).toEqual(42);
    });
});
