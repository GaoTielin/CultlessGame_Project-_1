pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

__gfx__
00000000bbbbbbbbc8cc21cc6666666677777777777777777777777777777777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffff1cccc21c6dddddd677777777777777777777777777777777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffbfff21c8111c6d6dd6d6c777c777c777c77777c777c777c777c7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffffc21222216ddd6dd6cc7ccc7ccc7ccc7c7ccc7ccc7ccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000fbffffffcc12cc8c6dd6ddd6cccc7ccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffffcc12cccc6d6dd6d6cccccccccccccc7ccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000fffffbffc1c1c12c6dddddd6ccccccccc7ccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffff2cc21cc166666666ccccccc7ccccccccccccc7cccccccccccccccccccccccccccceccccc77777ccccccccccccccccccccccccccccccccccc
00000000bbbbbbbbcccccccc77777777ccccccccccccccccccccccccccccccccccccccccccccccccceecccc77777c7cccccccccccccccccccccccccccccccccc
00000000bbb3bbbbcccccccc77777777cc7ccccccccccccc7ccccccccccccccccccccccccccccccccccccc777ee7777ccccc7ccccccccccc88cccccccccccccc
000000003b3f3b3bcccccccc77777777ccccccccccccccccccccccccccccccc7cccccccccccccccccccc77777ee77ee77cc7eeecccccccc8878ccccccccccccc
00000000f3ff3b33cccccccc77777777ccccccccccccccccccccccccccccccccccccccccccccccccccc77777eeee7eeee77eeeeeeeccc88888cccccccccccccc
00000000fffff3ffccc8cccc77777777cccccccccccccccccccccccccccccccccccccccccccccccccc777777eeeeeeeeeeeeeeeeeecccc8888bccccccccccccc
00000000ffffffffcc878ccc77777777ccccc7ccccccccccccc7cccccccccccccccccccccccccccccccc77eeeeeeeeeeee777eee777cccbbbbcccccccccccccc
00000000fbffffffc88888cc77777777cccccccccccccccccccccccccccccccccccccccccccccccccccc77eeeeeeeeeeeee7eeeee7777777bbcccccccccccccc
00000000ffffffbfcc777ccc77777777ccccccccccccccccccccccccccccccccccccccccccccccccc7777eeeeeeeeeeeeeeeeeeeeeee777777cccccccccccccc
77777777ffffffffcccccccccccccccc88cccccc88ccccccccccccccccccccccccccccceccccccc777eeeeeeee7eeeeeeeeeeeeeeeeeee7777cccccccccccccc
77777777ffffffffccccccccccccccccddccccccddcccccccccccccccccccccccccccceeeccccce777eeeee777eeeeeeeeeeeeeeee7eeeee77cccccccccccccc
77777777fffffbffcccccccccccccccc88ccccccc88cccccccccccccccccccccccccccccccccceeeeeeeeeee77eeeeeeeeeeeeeeee7eeeeee77ccccccceccccc
77777777ffffffffccccccccccccccccddccccccccddccccccccccccccccccccccccccccccccceeeeeeeeeeee7eeeeeeeeeeeeee7777eeeeee7cccccceeccccc
77777777ffffffffccccccccccccdccc88ccccccc88cccccccbccccccccbccccccccccccccc7eeeeeeeeeeeeeeeeeeeeeeeeeeeee7777eeeeee77ccccccccccc
77777777fbffffffccccccccccc8d8cc88cccccc88cccccccccbbbcccccbcccccccccccccc7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7ccccccccccc
77777777ffffffffc8882828c888c8d888cccccc88cccccccccbcbcccccbbcccccccccccc7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7eeeeeeeeeeeccccccccc
66666666ffffffffc8882828c88cccd8cccccccccccccccccccbcccccccbcbcccccccccc7eeeeeeee7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7eecccccccc
cccccccccccccccccccccccc97777777bbbbbbbbccccccccccccccccccc8cccccccccccc7eeeeeeeee77eeeeeeeeeeee7eeee7eeeeeeeeeeeeee77eecccccccc
76ccc67c666ccc6676ccc67cd9999997b2bbb2bbccccccccc8ccccccccccccc8cccccccc7eeeeeeeeee77eeeeeeeeeeee7e77eeeeeeeeeeeeeeeeeeeeccccccc
776c677c7776c677776c677cd99999972d2b2d26ccccccccccac8ccccccc8ccccccccccc7eeeeeeeeee77eeeeeeeeeeeee777eeeeeeeeeeeeee7eeeee7cccccc
c76c67ccc7779c4cc76c67ccd99999972dddddd6cccccccccccc88ccccc888cccccccccceeeeeeeeee7eeeeee4eeeeeeeee7eeeeee4eeeeee7777ee7e7cccccc
cc79c4ccccc55ccccc79c4ccd99999972dddddd67cccccccc8c8988ccc88888cccccccccceeeeeeee7eeeeeeeeeeeeeeeeeeeeeee4eeeeee77777eee7ccccccc
cc55ccccccc99ccccc55ccccd99999972dddddd6bc7bbbccc889a98cc8899988ccccccccceeeeeeeeeeeeeeeee4eeeeeeeeeeeee4eeeeeeeeeee7eeecccccccc
cc99cccccccc5cccccc99cccd99999972dddddd67bbbbb3c889aaa98889aa998cccccccccceeeeeeeeeeeeeee444eeeeeeeeeeee4eeeeeeeeeeeeeeecccccccc
ccc57cccccccc7ccccccc57cd99999972dddddd6b3bb337789aaaaa8899aaa98ccccccc7eeeeeeeeeeeeeeeeeee44eeeeeeeeeef44eee7eeeeeeeeeccccccccc
0000000000000000cc77ccccccccccccccc33cccccee33ccccccccccccccccccccccccc7eeeeeeeeeeeeeee7eeee444eeeeeee74eeeee77eeeeeeccccccccccc
0000000000000000ccc7cc888cccccccc888c3ccccee8c3ccccccccccccccccccccccc7eeeeeeeeeeeeee777eeeeeee44eeee4feeeee777eeeeeeecccccccccc
0000000000000000ccc7c88888cccccccee8c3cccc888cc3cccccccccccccccccccccc7eeeeeeee4eeeeeee77eeeeee444fee44eeeeeeeeeeeeeeeeccccccccc
0000000000000000ccc78887888ccccccee8c3cccccccc3cccccccccccccccccccccc7eeeeeeeeee4eeeeeeeee4eeeee44e44feeeeeeeeeeee4eeeeccccccccc
0000000000000000ccc888777888ccccccccc3cccccccc3cccccccccccccccccccccc7eeeeeeeeee44eeeeeeeee4eeeee4444feeeeeeeeeee4eee7eeeccccccc
0000000000000000cc88877777888cccccccc3ccccccc3ccccccccccccccccccccccc7eeeeeeeeeee4eeeeeeeeee44eee444ffeeeeeeeeee4eeee77eeecccccc
0000000000000000c8887777777888cccccc333ccccc333cccccccccccccccccccccc77eeeeeeeeee44eeeeeeeeeee4fe444ffee44444444ee777777eeeccccc
000000000000000088877777777788ccccc33333ccc33333cccccccccccccccccccccc7eeeee7e7eeee444eeeeeeee44f444fee4fff4eeeeee777777eeeccccc
cccccccccccccccc887777777777788ccccccccccccccccccccccccccccccccccccceeeeeeeee77eeeeee444eeeeeee44444444ffeeeeeeee77777777eeccccc
cccccccccccccccccc77e87777777cccccc88cccccccccccccccccccccccccccccc77eeeeeeeeeeeeeeeee4444eeeee4444444feeeeeeeeeee7777eeeeeccccc
cccccccccccccccccc77887777777ccccc8878ccccc88cccccccccccccccccccccc77eeeee7eeeeeeeeee44ee44feeee44444ffeeeeeeee7eee77eeeeecccccc
ccaceccccccecacccc77777755577cccc878888ccc8878cccccccccccccccccccccc777eeeeeeeeeeeeee4eeee44feee44444feeeeeeeeee7777eeeeeecccccc
ccc7cccccccc7ccccc77777755577ccc88888788c878888ccccccccccccccccccccc777777eeeeeee7fe4e7eee444ffe444444eeeeeeeeeee777eeeeeccccccc
cce3acccccca3ecccc77777755577cccccc77ccc88888788ccccccccccccccccccccc7777777e7eeff444777eee444ff4444444ffffeeeeeee7eeeeeeccccccc
ccc3cccccccc3cccc777777755d777ccccc77ccccc7776cccccccccccccccccccccccc777777ee7744777777eeee444444444444444ff77feeeeeeeecccccccc
ccc3ccccccc3cccc777777775557777cccc77cccccc76ccccccccccccccccccccccccccee77777777777777eeeeee444444447777777eeeeeeeeeee7cccccccc
ccccbcccccccbcccccccbcccccccbcccc44444ccc44444ccccccccccccccccccccccccccc777777777777eeeeeeeec4444444777777eeeceeeeeee77cccccccc
ccccbcccccccbccccccbbccccccbbccc4455544c4455544ccccccaaaaaccccccccccccccccccccccccccceeeecccccc444444ccccceeecccceeeee7ccccccccc
cccbbbbcccbbbbccccccbccccccccbcc4449444c4449444cccccaaaaaaaaccccccccccccccccccccccccccccccccccc444444ccccccccccccccce7cccccccccc
ccccbccccccbccccccccecccccccceccc44444ccc44444ccccaaaaaaaaaaacccccccccccccccccccccccccccccccccc444444ccccccccccccccccccccccccccc
ccebbccccebbccccccccccccccccccccccc4ccccccc4cccccaaaaaaaaaaaaaacccccccccccccccccccccccccccccccc444444ccccccccccccccccccccccccccc
ccccbeccccccbeccccccccccccccccccccc4ccccccc4cccccaaaaaaaaaaaaaaccccccccccccccccccccccccccccccccf44444ccccccccccccccccccccccccccc
ccccbcccccccbccccccccccccccccccceee4ccccccc4ccccaaaaaaaaaaaaaaaacccccccccccccccccccccccccccccccf44444ccccccccccccccccccccccccccc
cccbbceccccbbcecccccccccccccccccbbb4bbbbccc4ccccaaaaaaaaaaaaaaaacccccccccccccccccccccccccccccc4444444ccccccccccccccccccccccccccc
cccccccc0000000000000000000000000000000000000000aaaaaaaaaaaaaaaaccccccccccccccccccccccccccccc44444444ccccccccccccccccccccccccccc
cccccccc0000000000000000000000000000000000000000aaaaaaaaaaaaaaaacccccccccccccccccccccccccccc444444444ccccccccccccccccccccccccccc
cccccccc0000000000000000000000000000000000000000aaaaaaaaaaaaaaaccccccccccccccccccccccccccccff444444444cccccccccccccccccccccccccc
cccccccc0000000000000000000000000000000000000000caaaaaaaaaaaaaaccccccccccccccccccccccccc444444f4444444cccccccccccccccccccccccccc
cccccccc0000000000000000000000000000000000000000ccaaaaaaaaaaaaacccccccccccccccccccccccffff3fffbbb44bbf333bbbbbbbeccccccccccccccc
cccccccc0000000000000000000000000000000000000000ccaaaaaaaaaaaacccccccccccccbbcccccccbbbbbb3bbbbb44bbbbff33bbbbbbbccccccccccccccc
cccccccc0000000000000000000000000000000000000000cccaaaaaaaaaaccccccbbbbbebbbbbbbbbbbbeeb33bbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccc
cccccccc0000000000000000000000000000000000000000cccccaaaaaacccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbb3bbbbbbbbbeeeeeccccccc
ccccfcccccfeeccccccfeccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000cccccccccccccccccccccccc
ccfccfecccccfefccfeefeccccccccccccccccfccccccccccccccccfcccccccccccccccccccccccccccccccc0000000000000000ccccccccccccccccc7fc7fcc
ceecccfeccfccfeffccccfeccccccccccccccfcccccccccccccccceccccccccccccccccccccccccccccfffcc0000000000000000cccccccccc7cfcccfeefee2c
e7efccefceefccfeccfccccfccfccccccccffecccccccffccccccfecccfcccccccfffcccccfcccccccfeeefc0000000000000000cccccccccfeee2cc8eeeee2c
cc7effcee77effcfceefcffcceeefffcccfeecccccfcfeefcccffeccceecfffccfeeefccceefcffccfecccec0000000000000000ccececccc8eee2ccc8eee2cc
cee7eecfcceceefce77efeefe77eeeeffeecccccceefe77efeeeeccce77feeeffcccceefe77efeeffecccccf0000000000000000cc8e2ccccc8e2ccccc8e2ccc
cccc7efccecc77ecccecc77eccefc77ecccccccce77e7ceeccccccccccce77eeccccccccccce77eecccccccc0000000000000000ccc2ccccccc2ccccccc2cccc
ccceeeccccceeecceecceeeceecfcfeecccccccccfecccfcccccccccceeceecfcccccccccfecfeeccccccccc0000000000000000cccccccccccccccccccccccc
00000000ccc994ccccc94ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000777eeece777eeece777eeece
00000000c494cccccc94994c00000000000000000000000000000000000000000000000000000000000000000000000000000000cceeeccccceeecccc7fe7fcc
00000000494cc4ccc94cccc400000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccc7cfcccfeefee2c
0000000094cc499c4cccc4cc00000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccfeee2cc8eeeee2c
000000004b449779344b499b00000000000000000000000000000000000000000000000000000000000000000000000000000000ccececccc8eee2ccc8eee2cc
000000003499b9bb4994977900000000000000000000000000000000000000000000000000000000000000000000000000000000cc8e2ccccc8e2ccccc8e2ccc
00000000b977bb9b977bb9bb00000000000000000000000000000000000000000000000000000000000000000000000000000000ccc2ccccccc2ccccccc2cccc
00000000bb999bbbb999bb9900000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccc
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccccccccccc00000000cccc4cccccc4ccccccc4cccc00000000777eeece7777eece
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7fe7feeeee7ffeeee7ffeeeccc7ffcccc7ffccc00000000c4c4c44cc44c4c4cc44cc44c00000000cceeeccccce882cc
eeeeeeeeeeeeeeeeeeeeeeeeee7efeeefeefee2eee77ff2ee77fffeecc77ff2cc77fffcc00000000c999cc9449cc999c49ccc99c00000000cccccccccce882cc
eeeeeeeeeeeeeeeeeeeeeeeeefeee2ee8eeeee2ee77eee2277eeef2ec77eee2277eeef2c0000000099744c9449c4479949cc479900000000ccc7eccccce882cc
eeeeeeeeeeeeeeeeeeeeeeeee8eee2eee8eee2ee77eeeee2feeeee2277eeeee2feeeee22000000003b974494494479bb494479bb00000000cce882ccccc22ccc
eeeeeeeeeeeeeeeeee8e2eeeee8e2eeeee8e2eeeffeeeeeeeeeeee22ffeeeeeeeeeeee22000000004949994b349994943499799b00000000cce882ccccc7eccc
eeeeeeeeeeeeeeeeeee2eeeeeee2eeeeeee2eeeeffeeeeeeeeeeee22ffeeeeeeeeeeee2200000000bbbb97499479bbbbb949bbbb00000000cce882cccce882cc
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee88eeeeeeeeeeee2288eeeeeeeeeeee2200000000bb449449944944bbb94944bb00000000ccc22cccccc22ccc
eeeeeeeeeeeeeeee00000000000000000000000088eeeeeeeeeeee2288eeeeeeeeeeee22cccc4ccccccc4ccccccc4cccccc4ccccccc4cccc0000000000000000
eeeeeeeeeeeeeeee000000000000000000000000e88eeeeeeeeee22ec88eeeeeeeeee22ccc4cc49cc4c4c4cccc4444cccc4c4c4cc94cc4cc0000000000000000
eeeeeeeeeeeeeeee000000000000000000000000ee88eeeeeeee22eecc88eeeeeeee22ccc99ccc49cc99944ccc9949ccc44999cc94ccc99c0000000000000000
eeeeeeeeeeeeeeee000000000000000000000000eee88eeeeee22eeeccc88eeeeee22ccc9794cc94c974494ccc9949ccc494479c49cc49790000000000000000
eeeeeeeeeeeeeeee000000000000000000000000eeee88eeee22eeeecccc88eeee22cccc3b7944b93b94494b3b9499bb349449bb9b4497bb0000000000000000
eeeeeeeeeeeeeeee000000000000000000000000eeeee88ee22eeeeeccccc88ee22ccccc399799b43949494b339499bb3494949b4399799b0000000000000000
eeeeeeeeeeeeeeee000000000000000000000000eeeeee8822eeeeeecccccc8822ccccccbbbb794bbbb9749bbb9479bbb9479bbbb497bbbb0000000000000000
eeeeeeeeeeeeeeee000000000000000000000000eeeeeee82eeeeeeeccccccc82cccccccbb3999bbbb49b99bbb93b9bbb99b94bbbb999bbb0000000000000000
__map__
7070707060706070707070707060707070707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070
7070707060706070707070707060707070707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070
7070707060706070707070707060707070707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070
7070707062706070706667707060707070707070627060707066677070607070707070706270607070666770706070707070707062706070706667707060707070707070627060707066677070607070707070706270607070666770706070707070707062706070706667707060707070707070627060707066677070607070
08090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e76777070627070
18191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f7070707070707070
28292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f7070707070707070
38393a3b3c3d3e3f707070707070707038393a3b3c3d3e3f707070707070708d38393a3b3c3d3e3f707070707070708e38393a3b3c3d3e3f707070707070708f38393a3b3c3d3e3f707070707070708e38393a3b3c3d3e3f7070707070708f7038393a3b3c3d3e3f70707070708e707038393a3b3c3d3e3f70707070708f7070
48494a4b4c4d4e4f707070707070708048494a4b4c4d4e4f707070707070708148494a4b4c4d4e4f707070707070708248494a4b4c4d4e4f707070707070708148494a4b4c4d4e4f707070707070708048494a4b4c4d4e4f707070707070858648494a4b4c4d4e4f707070707087887048494a4b4c4d4e4f7070707070807070
58595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f7070707070343434
68696a6b6c6d6e42437070333333707068696a6b6cae6e42437070333333707068696a6b6caf6e42437070333333707068696a6b6caf6e42437070333333707068696a6b6c6d6e42437070333333707068696a6b6c6d6e42437070333333707068696a6b6c9d6e42437070333333707068696a6b6c9e6e424370703333337070
78797a7b7cb96452535470707070707078797a7b7cb96452535470707070707078797a7b7cba6452535470707070707078797a7b7cbb6452535470707070707078797a7b7cbc6452535470707070707078797a7b7cbd6452535470707070707078797a7b7c916452535470707070707078797a7b7c9264525354707070707070
0101010101010101010101040506070101010101010101010101010405060701010101010101010101010104050607010101010101010101010101040506070101010101010101010101010405060701010101010101010101010104050607010101010101010101010101040506070101010101010101010101010405060701
2121212121212121212121141516172121212121212121212121211415161721212121212121212121212114151617212121212121212121212121141516172121212121212121212121211415161721212121212121212121212114151617212121212121212121212121141516172121212121212121212121211415161721
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121
70707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1
70707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1
70707070607060707070707070607070707070706070607070707070706070707070707060706070707070707060707070707070607060707070707070607070b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1
70707070627060707066677070607070707070706270607070666770706070707070707062706070706667707060707070707070627060707066677070607070b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1
08090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e7677707062707008090a0b0c0d630f0e76777070627070b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1
18191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f707070707070707018191a1b1c1d1e1f7070707070707070b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1
28292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f707070707070707028292a2b2c2d2e2f7070707070707070b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1
38393a3b3c3d3e3f70707070708f707038393a3b3c3d3e3f707070707070707038393a3b3c3d3e3f707070707070707038393a3b3c3d3e3f7070707070707070b1a0a1a0a1a0a1a5a6a0a1a0a1a0a1b1b1a0a1a0a1a0a1a5a6a0a1a0a1a0a1b1b1a0a1a0a1a0a1a5a6a0a1a0a1a0a1b1b1a0a1a0a1a0a1a5a6a0a1a0a1a0a1b1
48494a4b4c4d4e4f707070707081707048494a4b4c4d4e4f707070708f70708048494a4b4c4d4e4f708f8f707070708148494a4b4c4d4e4f70a7a87070707082b1b0b1b0b1b0b1b5b6b0b1b0b1b0b1b1b1b0b1b0b1b0b1b5b6a2b1b0b1b0b1b1b1b0b1b0b1b0b1b5b6a3b1b0b1b0b1b1b1b0b1b0b1b0b1b5b6a4b1b0b1b0b1b1
58595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f8f7070707034343458595a5b5c5d5e5f707070707034343458595a5b5c5d5e5f70b7b87070343434b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1
68696a6b6c9f6e42437070333333707068696a6b6c6d6e42437070333333707068696a6b6c6d6e42437070333333707068696a6b6c6d6e424370703333337070b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1
78797a7b7c916452535470707070707078797a7b7cbd6452535470707070707078797a7b7c916452535470707070707078797a7b7c9264525354707070707070b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1
01010101010101010101010405060701010101010101010101010104050607010101010101010101010101040506070101010101010101010101010405060701b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1
21212121212121212121211415161721212121212121212121212114151617212121212121212121212121141516172121212121212121212121211415161721b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1b1a0a1a0a1a0a1a0a1a0a1a0a1a0a1b1
21212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1b1b0b1b0b1b0b1b0b1b0b1b0b1b0b1b1
21212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1