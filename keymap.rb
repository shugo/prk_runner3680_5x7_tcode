kbd = Keyboard.new

kbd.split = true

kbd.init_pins(
  [ 4, 5, 6, 7, 8 ],
  [ 28, 27, 26, 22, 20, 23, 21 ]
)

kbd.add_layer :default, %i[
    KC_ESCAPE   KC_GRAVE   KC_1     KC_2     KC_3     KC_4     KC_5         KC_6     KC_7     KC_8     KC_9     KC_0     KC_MINUS  KC_EQUAL
    KC_TAB   KC_TAB   KC_Q     KC_W     KC_E     KC_R     KC_T         KC_Y     KC_U     KC_I     KC_O     KC_P     KC_LBRACKET  KC_RBRACKET
    KC_LCTL  KC_LCTL  KC_A     KC_S     KC_D     KC_F     KC_G         KC_H     KC_J     KC_K     KC_L     KC_SCOLON  KC_QUOTE  KC_BSLASH
    KC_PGUP  KC_LSFT  KC_Z     KC_X     KC_C     KC_V     KC_B         KC_N     KC_M     KC_COMMA  KC_DOT   KC_SLASH  KC_ENTER  KC_RSFT
    KC_PGDOWN  KC_TCTG   KC_LGUI  KC_LALT  KC_LGUI  LOWER    KC_SPACE       KC_BSPACE  RAISE    KC_INSERT   KC_HOME  KC_END   KC_DELETE   KC_RCTL
]

kbd.add_layer :tcode, %i[
    KC_ESCAPE   KC_GRAVE   KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC     KC_MINUS  KC_EQUAL
    KC_TAB   KC_TAB   KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC     KC_LBRACKET  KC_RBRACKET
    KC_LCTL  KC_LCTL  KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC  KC_QUOTE  KC_BSLASH
    KC_PGUP  KC_LSFT  KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC  KC_TC   KC_TC  KC_ENTER  KC_RSFT
    KC_PGDOWN  KC_TCTG   KC_LGUI  KC_LALT  KC_LGUI  LOWER    KC_SPACE       KC_BSPACE  RAISE    KC_INSERT   KC_HOME  KC_END   KC_DELETE   KC_RCTL
]

kbd.define_mode_key :KC_TCTG, [ Proc.new { kbd.default_layer = kbd.default_layer == :default ? :tcode : :default }, nil, 300, nil ]

KANJI_TBL = {
  20=>'308e',21=>'3090',22=>'3091',109=>'305c',427=>'3069',428=>'4ee3',
  437=>'7684',456=>'305b',457=>'533a',465=>'5206',466=>'3088',468=>'5343',
  475=>'4ed8',477=>'3070',495=>'3084',506=>'304b',509=>'308c',536=>'5c71',
  537=>'8005',545=>'304d',546=>'3063',547=>'65e5',548=>'56fd',549=>'4e8c',
  557=>'5ddd',574=>'3083',576=>'91d1',579=>'5973',582=>'3050',585=>'4e0a',
  586=>'304f',588=>'3048',589=>'5e74',599=>'5165',678=>'305e',743=>'3056',
  746=>'3073',800=>'3071',815=>'4e2d',817=>'3082',818=>'304a',826=>'3068',
  828=>'3066',829=>'308b',836=>'4eba',839=>'3061',840=>'3074',853=>'3075',
  855=>'308f',857=>'6771',859=>'308d',866=>'3057',867=>'305f',868=>'4e00',
  869=>'304c',877=>'4e07',878=>'65b9',880=>'3077',895=>'3046',903=>'306d',
  905=>'3044',906=>'3001',907=>'306e',915=>'3093',916=>'307e',918=>'3064',
  920=>'307a',930=>'304e',935=>'3042',936=>'3053',938=>'5b66',945=>'3002',
  955=>'3051',957=>'3059',959=>'5730',960=>'307d',976=>'3055',977=>'3089',
  978=>'9ad8',985=>'3067',986=>'306f',987=>'306b',988=>'306a',989=>'3092',
  999=>'307f',1015=>'3080',1092=>'3065',1119=>'3054',1135=>'3079',1189=>'3078',
  1219=>'307b',1227=>'5186',1228=>'5c0f',1236=>'9053',1237=>'305a',1239=>'3052',
  1240=>'3043',1256=>'3058',1267=>'793e',1268=>'91ce',1269=>'540c',1280=>'3045',
  1305=>'3060',1306=>'308a',1308=>'3081',1309=>'5927',1312=>'3086',1316=>'5408',
  1317=>'9762',1320=>'3047',1327=>'3062',1337=>'5834',1348=>'5b50',1358=>'76ee',
  1360=>'3049',1381=>'3076',1387=>'4f1a',1388=>'524d',1389=>'305d',1397=>'4e0b',
  1472=>'307c',1530=>'3085',1540=>'306c',1556=>'3072',1557=>'3087',
}

class Keyboard
  attr_reader :switches
end

tc_index = nil
prev_tc_index = nil

kbd.before_report do
  if switch = kbd.switches.last
    tc_index = 10 * switch[0] + switch[1] - 2
  end
end

tcode = Proc.new {
  if prev_tc_index
    i = 40 * tc_index + prev_tc_index
    if codepoint = KANJI_TBL[i]
      kbd.send_key(:KC_LCTL, :KC_LSFT, :KC_U)
      kbd.macro(codepoint + " ", [])
    else
      puts "Undefined char: #{i}"
    end
    prev_tc_index = nil
  else
    prev_tc_index = tc_index
  end
}
kbd.define_mode_key :KC_TC, [ tcode, nil, 300, nil ]

kbd.start!
