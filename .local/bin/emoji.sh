#!/usr/bin/env bash
set -euo pipefail

chosen="$(
cat <<'EOF' | fuzzel --dmenu --prompt "emoji> "
😀 grinning smile happy joy cheerful grin
😃 happy joy smile big eyes cheerful vibe
😄 smile happy eyes grin friendly warm
😁 grin teeth happy smile excited energy
😆 laugh haha funny grin loud joy
😅 awkward sweat smile relief nervous haha
🤣 rofl lol laughing floor funny chaos
😂 tears joy funny cry laugh meme
🙂 smile soft friendly calm polite nice
🙃 upside down silly weird quirky joke
😉 wink flirt playful hint cheeky tease
😊 smile warm kind blush cute gentle
😇 angel innocent halo pure good boy
🥰 love hearts cute adore soft affection
😍 love heart eyes crush obsessed wow
😘 kiss love muah affection romance
😋 tasty yum food happy enjoy flavor
😛 tongue silly playful goofy teasing
😜 wink tongue goofy chaotic energy
🤪 crazy silly chaotic unhinged goofy
😝 tongue eyes closed goofy dumb fun
🤑 money rich greedy cash profit
🤗 hug cuddle friendly comfort safe
🤭 giggle shy oops hehe awkward cute
🤫 quiet shh secret whisper hush
🤔 think hmm idea question doubt
😐 neutral meh blank emotionless idle
😑 blank expression deadpan boring tired
😶 silent no mouth speechless blank
😏 smirk smug flirty suggestive shady
🙄 eye roll annoyed done with you
😴 sleep tired zzz rest lazy
🤯 mind blown wow shock insane crazy
😭 cry sad tears pain heartbreak
😡 angry mad rage pissed furious
🤬 swearing censored rage toxic anger
💀 skull dead lol dead inside funny
🤡 clown silly weird cringe idiot
👀 eyes watching looking spying curious
💩 poo shit crap dump funny gross
🔥 fire hot lit cool hype energy
✨ sparkles magic shiny aesthetic glow
❤️ love heart red romance passion
💔 broken heart sad love pain breakup
💖 love sparkle cute heart shiny
💕 love hearts romance affection cute
💞 love spin hearts moving romance
💓 heart beat love pulse alive
💗 growing love heart affection more
💘 love arrow cupid romance hit
💋 kiss lips love mark romance
👅 tongue lick tease horny playful
🫦 lip bite sexy shy suggestive
🍑 peach butt suggestive meme sexy
🍆 eggplant suggestive meme joke
🍓 strawberry cute fruit sweet
🍒 cherries cute fruit twin
🧁 cupcake sweet cute dessert
🍬 candy sweet sugar treat
🍭 lollipop sweet cute fun
🐺 wolf furry wild alpha
🦊 fox sly furry cute trickster
🐱 cat cute pet soft
🐾 paws furry animal tracks
🦄 unicorn magic cute fantasy
🌸 flower blossom cute soft pink
🌈 rainbow colorful pride gay vibe
⭐ star shiny bright glow
🌙 moon night calm aesthetic
🚀 rocket fast launch speed
🎉 party celebration fun hype
🎀 ribbon cute gift pink
👑 crown king queen royal
💍 ring love marriage engagement
🧦 socks comfy cute soft
👗 dress fashion cute style
💻 laptop work tech coding
🎧 headphones music vibe chill
📎 clip office tool attach
✏️ pencil write draw sketch
📝 note memo write plan
⚡ energy electric fast power
🌟 glow star sparkle shine
💫 dizzy star magic spin
🌌 galaxy space aesthetic stars
🌚 moon face creepy dark meme
🌝 moon face bright goofy
🛏️ bed sleep rest tired
🕯️ candle calm night aesthetic
💦 drops sweat water horny meme
🫶 heart hands love gesture
🤝 handshake deal agreement trust
👍 like approve yes good
👎 dislike no bad reject
👌 ok perfect nice clean
👏 clap applause good job
🙌 celebrate yay hype hands
🙏 pray please thanks hope
💪 strong muscle power flex
🫰 money gesture small heart
🤟 love gesture rock sign
🤘 rock metal sign edgy
🧎 kneel submissive tired rest
🧍 stand idle waiting neutral
🕺 dance party fun groove
💃 dance party fun vibe
🪩 disco ball party club
👗 dress cute fashion girly
🎀 ribbon cute soft aesthetic
🧸 teddy bear plush cute comfort
🍰 cake sweet dessert birthday
🍫 chocolate sweet snack
🥛 milk drink soft cute
🍯 honey sweet sticky
🍕 pizza food tasty comfort
🍔 burger fast food tasty
🍟 fries snack salty tasty
🌭 hotdog food street snack
🥓 bacon food meat salty
🍗 chicken food meat tasty
🍖 meat bone food caveman
🧀 cheese food dairy tasty
🥚 egg food breakfast
🍞 bread food basic
🥐 croissant food pastry
🥞 pancakes breakfast sweet
🍜 noodles food ramen
🍣 sushi food japan
🍤 shrimp food seafood
🍱 bento food box meal
🍛 curry food spicy
🍲 soup food warm
🥗 salad healthy food
🍝 pasta food italian
🍦 ice cream dessert cold
🍩 donut sweet dessert
🍪 cookie sweet snack
🍿 popcorn snack movie
😺 cat happy grin cute
😸 cat smile happy eyes
😹 cat tears joy funny
😻 cat heart eyes love
😼 cat smirk smug
😽 cat kiss love cute
🙀 cat shock scared wow
😿 cat cry sad tears
😾 cat angry mad

🙈 monkey no see shy
🙉 monkey no hear ignore
🙊 monkey no speak secret

🐶 dog cute pet loyal
🐕 dog animal friend goodboy
🦮 guide dog helper blind
🐕‍🦺 service dog support
🐩 poodle fancy dog
🐕‍🦴 bone dog chew
🐾 paw prints animal furry

🐭 mouse small cute
🐹 hamster cheeks cute
🐰 bunny rabbit cute soft
🦝 raccoon sneaky trash panda
🦡 badger animal wild
🦨 skunk stink animal
🦫 beaver builder dam
🦦 otter cute water
🦥 sloth slow lazy
🐻 bear big cute
🐻‍❄️ polar bear cold
🐼 panda bamboo cute
🐨 koala sleepy cute
🐯 tiger wild stripes
🦁 lion king strong
🐮 cow moo farm
🐷 pig oink farm
🐽 pig nose snout
🐸 frog green meme
🐵 monkey face silly
🐒 monkey animal
🦍 gorilla strong
🦧 orangutan jungle

🐔 chicken farm bird
🐓 rooster morning crow
🐣 chick hatch baby
🐤 chick baby cute
🐥 chick front cute
🦆 duck quack bird
🦢 swan elegant white
🦉 owl wise night
🦤 dodo extinct bird
🪶 feather light soft
🦩 flamingo pink bird
🦚 peacock fancy
🦜 parrot talk bird
🐦 bird small
🐦‍⬛ black bird crow
🦅 eagle strong sky
🦇 bat night spooky

🐗 boar wild pig
🐴 horse animal ride
🫎 moose big animal
🫏 donkey stubborn
🐎 horse racing fast
🦓 zebra stripes
🦌 deer forest animal
🦬 bison strong
🐄 cow farm
🐂 ox strong farm
🐃 buffalo heavy
🐏 ram sheep horn
🐑 sheep wool soft
🐐 goat climb farm
🦙 llama fluffy
🦒 giraffe tall
🐘 elephant big memory
🦏 rhino horn strong
🦛 hippo big water

🐊 crocodile danger water
🐢 turtle slow shell
🦎 lizard reptile
🐍 snake hiss danger
🐲 dragon face fantasy
🐉 dragon fantasy fire

🐳 whale big ocean
🐋 whale water
🐬 dolphin smart ocean
🦭 seal cute water
🐟 fish swim
🐠 tropical fish colorful
🐡 blowfish danger
🦈 shark scary ocean
🐙 octopus smart
🦑 squid ocean
🦐 shrimp food ocean
🦞 lobster red food
🦀 crab claws

🐌 snail slow
🦋 butterfly pretty
🐛 bug small
🐜 ant work
🐝 bee honey
🪲 beetle bug
🐞 ladybug lucky
🦗 cricket chirp
🪳 cockroach gross
🕷️ spider web
🦂 scorpion sting

🌱 seedling new life
🌿 herb plant
☘️ clover luck
🍀 four leaf luck rare
🌴 palm tropical
🌳 tree green
🌲 pine tree forest
🌵 cactus desert
🌾 grain farm
🌷 tulip flower
🌹 rose love
🌺 hibiscus flower
🌻 sunflower bright
🌼 blossom flower

🍎 apple fruit red
🍏 apple green
🍊 orange fruit citrus
🍋 lemon sour
🍌 banana fruit
🍉 watermelon summer
🍇 grapes fruit
🍈 melon fruit
🍍 pineapple tropical
🥭 mango fruit
🥝 kiwi fruit
🍅 tomato fruit
🥑 avocado trendy
🥦 broccoli healthy
🥕 carrot veggie
🌽 corn food
🌶️ chili spicy
🫑 pepper veggie
🥒 cucumber veggie
🥬 leafy green
🥔 potato food
🧄 garlic flavor
🧅 onion tears

🥖 baguette bread
🥨 pretzel snack
🥯 bagel bread
🧇 waffle breakfast
🥩 steak meat
🍗 chicken leg food
🍖 meat bone
🦴 bone
🌮 taco food
🌯 burrito food
🥙 pita wrap
🧆 falafel veggie
🥪 sandwich food
🥫 canned food
🍝 spaghetti pasta
🍜 ramen noodles
🍲 stew soup
🍛 curry spicy
🍣 sushi fish
🍱 bento box
🥟 dumpling food
🦪 oyster seafood
🍤 fried shrimp
🍙 rice ball
🍚 rice bowl
🍘 rice cracker

🍥 fish cake
🥠 fortune cookie
🥡 takeout box
🥢 chopsticks

🧂 salt seasoning
🥫 canned food
🍶 sake drink
🍺 beer drink
🍻 cheers beer
🥂 cheers glasses
🍷 wine drink
🥃 whiskey drink
🍸 cocktail drink
🍹 tropical drink
🧉 mate drink
🍾 champagne pop
🥤 soda drink
🧃 juice box
🫖 teapot tea
☕ coffee drink
🥛 milk drink
🍼 baby bottle
⌚ watch time clock
📱 phone mobile device
📲 phone arrow call
💻 laptop computer work
⌨️ keyboard typing
🖥️ desktop computer monitor
🖨️ printer office
🖱️ mouse click device
🖲️ trackball input
💽 minidisc old tech
💾 floppy disk save
💿 cd disk media
📀 dvd disk movie
📼 videocassette retro
📷 camera photo
📸 camera flash pic
📹 video camera record
🎥 movie camera film
📽️ film projector cinema
🎞️ film frames reel
📞 telephone call
☎️ phone classic
📟 pager old tech
📠 fax machine office

📺 tv screen media
📻 radio music
🎙️ studio mic podcast
🎚️ level slider control
🎛️ control knobs audio
🧭 compass direction
⏱️ stopwatch timer
⏲️ timer clock
⏰ alarm clock wake
🕰️ mantel clock old
🌡️ thermometer temp
🧨 firecracker boom
🎈 balloon party
🎉 party popper fun
🎊 confetti celebration
🎎 dolls festival
🎏 carp streamer japan
🎐 wind chime sound
🧧 red envelope gift
🎀 ribbon cute gift
🎁 wrapped gift present
🎗️ reminder ribbon
🎟️ ticket entry
🎫 ticket stub
🎖️ medal award
🏆 trophy win
🏅 sports medal
🥇 gold medal first
🥈 silver medal second
🥉 bronze medal third

⚽ football soccer ball
🏀 basketball sport
🏈 american football
⚾ baseball sport
🥎 softball sport
🎾 tennis ball
🏐 volleyball sport
🏉 rugby ball
🥏 frisbee disc
🎱 pool 8 ball
🪀 yo yo toy
🏓 ping pong
🏸 badminton
🏒 hockey
🏑 field hockey
🥍 lacrosse
🏏 cricket
🪃 boomerang
🥅 goal net
⛳ golf hole
🪁 kite fly
🏹 bow arrow
🎣 fishing rod
🤿 diving mask
🥊 boxing glove
🥋 martial arts
🎽 running shirt
🛹 skateboard
🛼 roller skate
🛷 sled snow
⛸️ ice skate
🥌 curling stone

🎯 dart target
🪄 magic wand
🎮 video game controller
🕹️ joystick retro
🎰 slot machine casino
🎲 dice game
🧩 puzzle piece
🧸 teddy bear cute
🪅 piñata party
🪆 nesting dolls

♠️ spade suit cards
♥️ heart suit cards
♦️ diamond suit cards
♣️ club suit cards
♟️ chess pawn
🃏 joker card
🀄 mahjong tile

🎭 theater masks drama
🖼️ framed picture art
🎨 artist palette paint
🧵 thread sewing
🪡 needle sewing
🧶 yarn knitting
🪢 knot rope

👓 glasses vision
🕶️ sunglasses cool
🥽 goggles protection
🥼 lab coat science
🦺 safety vest
👔 tie formal
👕 t shirt casual
👖 jeans pants
🧣 scarf warm
🧤 gloves cold
🧥 coat jacket
🧦 socks comfy
👗 dress outfit
👘 kimono japan
🥻 sari clothing
🩱 swimsuit
🩲 briefs underwear
🩳 shorts summer
👙 bikini beach
👚 blouse shirt

👛 purse bag
👜 handbag fashion
👝 clutch bag small
🛍️ shopping bags buy
🎒 backpack school
🩴 flip flops
👞 shoe formal
👟 sneaker casual
🥾 boot hiking
🥿 flat shoe
👠 high heel
👡 sandal
🩰 ballet shoes
👢 boots fashion

👑 crown royal
👒 hat woman
🎩 top hat fancy
🧢 cap casual
🪖 helmet military
⛑️ helmet safety
📿 prayer beads
💄 lipstick makeup
💍 ring marriage
💎 gem diamond

📢 loudspeaker announce
📣 megaphone shout
📯 postal horn
🔔 bell ring
🔕 bell mute
🎼 musical score
🎵 music note
🎶 music notes
🎤 microphone sing
🎧 headphones music

📚 books stack
📖 open book read
📕 red book
📗 green book
📘 blue book
📙 orange book
📓 notebook
📔 notebook decorative
📒 ledger
📃 page document
📜 scroll old text
📄 document file
📰 newspaper news
🗞️ rolled newspaper
📑 bookmark tabs
🔖 bookmark mark

🏧 atm withdraw money
🚮 trash bin litter
🚰 potable water
♿ wheelchair access
🚹 men restroom
🚺 women restroom
🚻 restroom sign
🚼 baby symbol
🚾 wc toilet
🛂 passport control
🛃 customs
🛄 baggage claim
🛅 lockers storage

⚠️ warning alert
🚸 children crossing
⛔ no entry
🚫 prohibited no
🚳 no bicycles
🚭 no smoking
🚯 no littering
🚱 non potable water
🚷 no pedestrians
📵 no phones
🔞 18 plus adult
🚗 car auto vehicle drive
🚕 taxi cab yellow
🚙 suv car offroad
🚌 bus transport city
🚎 trolleybus electric
🏎️ race car fast speed
🚓 police car law
🚑 ambulance emergency
🚒 fire engine truck
🚐 van transport cargo
🛻 pickup truck
🚚 truck delivery cargo
🚛 articulated truck big
🚜 tractor farm vehicle

🏍️ motorcycle bike fast
🛵 scooter small ride
🚲 bicycle bike eco
🛴 kick scooter
🛹 skateboard ride
🛼 roller skates

🚏 bus stop station
🛣️ motorway highway
🛤️ railway track
🛢️ oil drum fuel
⛽ fuel pump gas

🚨 siren alarm emergency
🚥 traffic light
🚦 vertical traffic light
🛑 stop sign halt

✈️ airplane flight travel
🛫 plane takeoff
🛬 plane landing
🛩️ small airplane
💺 seat airplane
🛰️ satellite space
🚀 rocket launch space
🛸 ufo alien ship

🚁 helicopter chopper
🛶 canoe boat
⛵ sailboat wind
🚤 speedboat fast water
🛥️ motor boat
🛳️ passenger ship cruise
⛴️ ferry boat
🚢 ship ocean cargo

⚓ anchor ship dock
🪝 hook tool
⛽ fuel pump

🌍 earth europe africa
🌎 earth americas
🌏 earth asia australia
🌐 globe internet world
🗺️ world map geography
🧭 compass navigation

🏔️ mountain snow
⛰️ mountain peak
🌋 volcano lava fire
🗻 mount fuji japan
🏕️ camping tent
🏖️ beach umbrella
🏜️ desert sand
🏝️ island tropical
🏞️ national park

🏟️ stadium sports
🏛️ building classical
🏗️ construction site
🧱 brick wall
🪨 rock stone
🪵 wood log
🛖 hut small house
🏠 house home
🏡 house garden
🏘️ houses neighborhood
🏚️ derelict house broken
🏢 office building
🏣 japanese post office
🏤 post office mail
🏥 hospital health
🏦 bank money
🏨 hotel stay
🏩 love hotel
🏪 convenience store
🏫 school education
🏬 department store
🏭 factory industry
🏯 japanese castle
🏰 castle fantasy

💒 wedding marriage
🗼 tokyo tower
🗽 statue of liberty
⛪ church religion
🕌 mosque religion
🛕 hindu temple
🕍 synagogue
⛩️ shinto shrine

🛤️ railway track
🚂 steam locomotive
🚆 train rail
🚇 metro subway
🚈 light rail
🚉 station train
🚊 tram streetcar

🔣 symbols input
🔤 abc letters
🔡 lowercase letters
🔠 uppercase letters
🔢 numbers digits
#️⃣ keycap number
*️⃣ keycap star
0️⃣ zero keycap
1️⃣ one keycap
2️⃣ two keycap
3️⃣ three keycap
4️⃣ four keycap
5️⃣ five keycap
6️⃣ six keycap
7️⃣ seven keycap
8️⃣ eight keycap
9️⃣ nine keycap

🔟 ten keycap
🔴 red circle
🟠 orange circle
🟡 yellow circle
🟢 green circle
🔵 blue circle
🟣 purple circle
⚫ black circle
⚪ white circle
🟤 brown circle

🟥 red square
🟧 orange square
🟨 yellow square
🟩 green square
🟦 blue square
🟪 purple square
⬛ black square
⬜ white square
🟫 brown square

🔺 red triangle up
🔻 red triangle down
🔼 small triangle up
🔽 small triangle down
🔸 small diamond orange
🔹 small diamond blue
🔶 large diamond orange
🔷 large diamond blue

➕ plus add
➖ minus subtract
➗ divide math
✖️ multiply math
♾️ infinity forever
‼️ double exclamation
⁉️ exclamation question
❓ question mark
❔ white question
❕ white exclamation
❗ exclamation mark

✔️ check heavy
☑️ checkbox checked
✖️ cross heavy
❌ cross mark
❎ cross button
➰ loop curly
➿ double loop

©️ copyright symbol
®️ registered symbol
™️ trademark symbol

🔒 lock closed secure
🔓 lock open
🔏 lock pen secure
🔐 lock key secure
🔑 key unlock
🗝️ old key antique

💡 light bulb idea
🔦 flashlight light
🕯️ candle light
🪔 oil lamp

🧯 fire extinguisher safety
🛠️ tools repair
⚒️ hammer pick
🔨 hammer build
🪓 axe chop
🔧 wrench fix
🔩 nut bolt
⚙️ gear settings
🪛 screwdriver
🪚 saw cut
🔗 link chain
⛓️ chains heavy

🧰 toolbox tools
🧲 magnet attract
🪜 ladder climb
⚗️ alembic lab
🧪 test tube science
🧫 petri dish
🧬 dna biology
🔬 microscope lab
🔭 telescope space
🩺 stethoscope doctor health
💉 syringe injection vaccine
💊 pill medicine drug
🩹 bandage injury heal
🩼 crutch support injury
🩻 xray bones scan
🧠 brain smart think
🫀 heart organ life
🫁 lungs breathe air
🦷 tooth dental
🦴 bone skeleton

🚪 door enter exit
🪑 chair sit
🛋️ couch sofa relax
🛏️ bed sleep rest
🪟 window view
🪞 mirror reflection
🚽 toilet bathroom
🛁 bathtub wash
🚿 shower clean
🪠 plunger fix toilet
🧴 lotion bottle
🧷 safety pin
🧹 broom clean
🧺 basket laundry
🧻 toilet paper roll
🪣 bucket water
🧼 soap clean
🫧 bubbles wash
🪥 toothbrush dental
🧽 sponge clean

🧯 extinguisher fire safety
🛒 shopping cart buy
🛍️ shopping bags store
🎁 gift present wrap
📦 package box delivery
📫 mailbox mail
📪 mailbox closed
📬 mailbox open
📭 mailbox empty
📮 postbox send
✉️ envelope letter
📧 email send
📨 incoming mail
📩 envelope arrow
📤 outbox send
📥 inbox receive
📦 parcel box

🗂️ card index dividers
📁 folder files
📂 open folder
🗃️ card file box
🗄️ file cabinet
🗑️ trash bin delete
📋 clipboard list
📊 bar chart stats
📈 chart up growth
📉 chart down loss
🧾 receipt bill
📜 scroll document

🧮 abacus math count
📏 ruler measure
📐 triangle ruler
✂️ scissors cut
🗒️ spiral notepad
🗓️ calendar date
📆 tear off calendar
📅 calendar date marked

🕑 clock two time
🕒 clock three time
🕓 clock four time
🕔 clock five time
🕕 clock six time
🕖 clock seven time
🕗 clock eight time
🕘 clock nine time
🕙 clock ten time
🕚 clock eleven time
🕛 clock twelve time

🌅 sunrise morning
🌄 sunrise mountains
🌇 sunset city
🌆 city dusk
🌃 night city lights
🌉 bridge night
🌌 galaxy stars sky

🌠 shooting star wish
☀️ sun bright day
🌤️ sun cloud
⛅ partly cloudy
🌥️ cloud sun
☁️ cloud sky
🌦️ rain sun
🌧️ rain weather
⛈️ storm lightning
🌩️ lightning storm
🌨️ snow weather
❄️ snowflake cold
☃️ snowman
⛄ snowman no snow
🌬️ wind face
💨 dash wind speed
🌪️ tornado storm
🌫️ fog mist
🌊 water wave ocean

🏁 finish flag race
🚩 red flag warning
🎌 crossed flags japan
🏳️ white flag surrender
🏴 black flag pirate
🏳️‍🌈 rainbow flag pride
🏳️‍⚧️ trans flag pride

🔁 repeat loop
🔂 repeat one
▶️ play button
⏸️ pause button
⏹️ stop button
⏺️ record button
⏭️ next track
⏮️ previous track
⏩ fast forward
⏪ rewind

🔀 shuffle random
🔊 volume loud
🔉 volume medium
🔈 volume low
🔇 mute silent

📶 signal bars
📡 antenna signal
🔋 battery full
🪫 battery low
🔌 plug power
💻 laptop computer
🖥️ desktop monitor

🧑 person neutral
👤 bust silhouette
👥 busts group
🫂 people hugging

🧑‍🎤 singer artist
🧑‍💻 programmer coder
🧑‍🔬 scientist lab
🧑‍🚀 astronaut space
🧑‍🚒 firefighter hero
🧑‍✈️ pilot plane
🧑‍⚕️ doctor medic
🧑‍🍳 cook chef
🧑‍🎓 student graduate
🧑‍🏫 teacher school
🧑‍⚖️ judge law
🧑‍🌾 farmer agriculture
🧑‍🔧 mechanic repair
🧑‍🏭 factory worker
🧑‍💼 office worker
🧑‍🔮 fortune teller
🧑‍🎨 artist paint
🧑‍🚀 astronaut galaxy

🛌 person in bed sleep
🛀 person bath relax
🧘 person meditation calm
🧍 person standing idle
🧎 person kneeling
🏃 running fast
🚶 walking slow
🧗 climbing mountain
🏊 swimming water
🚴 cycling bike
🏋️ lifting weights
🤸 cartwheel gymnast
⛹️ bouncing ball sport
🤾 handball sport
🏌️ golf swing
🧘‍♂️ meditation yoga
🧘‍♀️ meditation yoga

💑 couple love
👩‍❤️‍👩 couple women love
👨‍❤️‍👨 couple men love
💏 kiss couple love
👩‍❤️‍💋‍👨 kiss couple
👨‍❤️‍💋‍👨 kiss men
👩‍❤️‍💋‍👩 kiss women

🅰️ a button blood type
🅱️ b button blood type
🅾️ o button blood type
🆎 ab button blood type
🆑 clear button
🆒 cool button
🆓 free button
🆔 id button identity
🆕 new button fresh
🆖 ng button no good
🆗 ok button confirm
🆘 sos emergency help
🆙 up button increase
🆚 vs versus compare

🈁 here japanese button
🈂️ service charge japanese
🈷️ monthly amount
🈶 not free of charge
🈯 reserved japanese
🉐 bargain deal
🈹 discount sale
🈚 free of charge
🈲 prohibited
🉑 acceptable
🈸 application
🈴 passing grade
🈳 vacancy empty
㊗️ congratulations
㊙️ secret

🔠 input latin uppercase
🔡 input latin lowercase
🔢 input numbers
🔣 input symbols
🔤 input letters

♻️ recycle green
🔱 trident symbol
📛 name badge
🔰 beginner mark
⭕ hollow red circle
✅ check mark button
☑️ check box
✔️ check mark
❌ cross mark
❎ cross mark button

➰ curly loop
➿ double curly loop
〰️ wavy dash
✳️ eight spoked asterisk
✴️ eight pointed star

❇️ sparkle star
©️ copyright
®️ registered
™️ trademark

#️⃣ hash key
*️⃣ star key

0️⃣ keycap zero
1️⃣ keycap one
2️⃣ keycap two
3️⃣ keycap three
4️⃣ keycap four
5️⃣ keycap five
6️⃣ keycap six
7️⃣ keycap seven
8️⃣ keycap eight
9️⃣ keycap nine
🔟 keycap ten

🔺 red triangle up
🔻 red triangle down
◀️ triangle left
▶️ triangle right
🔼 small triangle up
🔽 small triangle down

⏏️ eject button
🎦 cinema movie
🔅 dim button
🔆 bright button
📳 vibration mode
📴 mobile off

♀️ female sign
♂️ male sign
⚧️ transgender symbol

✖️ multiply x
➕ plus add
➖ minus subtract
➗ divide

♾️ infinity endless
‼️ double exclamation
⁉️ exclamation question
❓ question mark
❔ white question
❕ white exclamation
❗ exclamation mark

〽️ part alternation mark
⚠️ warning danger
🚸 children crossing
🔰 beginner mark

🔞 18 plus adult
📵 no mobile phones
🚫 prohibited no
🚳 no bicycles
🚭 no smoking
🚯 no littering
🚱 non potable water
🚷 no pedestrians

🔄 counterclockwise arrows
🔃 clockwise arrows
🔁 repeat loop
🔂 repeat one
🔀 shuffle random

🆗 ok button
🆒 cool button
🆓 free button
🆕 new button
🆙 up button
🆚 vs button

🏳️ white flag surrender
🏴 black flag pirate
🏁 chequered flag race
🚩 triangular flag red
🎌 crossed flags japan
🏳️‍🌈 rainbow pride flag
🏳️‍⚧️ transgender pride flag

🏴‍☠️ pirate flag skull
🇪🇺 european union flag
🇺🇳 united nations flag
🇺🇸 usa flag
🇬🇧 uk flag
🇯🇵 japan flag
🇰🇷 korea flag
🇨🇳 china flag
🇩🇪 germany flag
🇫🇷 france flag
🇪🇸 spain flag
🇮🇹 italy flag
🇳🇱 netherlands flag
🇺🇦 ukraine flag
🇵🇱 poland flag
🇸🇪 sweden flag
🇳🇴 norway flag
🇫🇮 finland flag
🇩🇰 denmark flag
🇨🇦 canada flag
🇧🇷 brazil flag
🇦🇺 australia flag
🇮🇳 india flag
🇲🇽 mexico flag
🇿🇦 south africa flag
🇹🇷 turkey flag
🇸🇦 saudi arabia flag
🇦🇷 argentina flag
🇨🇱 chile flag
🇨🇴 colombia flag
🇵🇪 peru flag
🇻🇪 venezuela flag
🇵🇹 portugal flag
🇬🇷 greece flag
🇮🇪 ireland flag
🇨🇿 czech republic flag
🇸🇰 slovakia flag
🇭🇺 hungary flag
🇷🇴 romania flag
🇧🇬 bulgaria flag
🇭🇷 croatia flag
🇷🇸 serbia flag
🇸🇮 slovenia flag
🇱🇹 lithuania flag
🇱🇻 latvia flag
🇪🇪 estonia flag
🪬 nazar amulet evil eye
🪩 disco ball party club
🪭 folding fan aesthetic
🪮 hair comb grooming
🪇 maracas music shake
🪈 flute music instrument
🪗 accordion music
🪘 drum rhythm beat
🪙 coin money gold
🪪 id card identity
🪫 low battery empty
🪤 mouse trap catch
🪣 bucket container
🪥 toothbrush clean teeth
🪦 headstone grave rip
🪧 protest sign message
🪪 id card identity
🪫 battery empty low

🫠 melting face awkward dying inside
🫡 salute respect ok boss
🫢 shock cover mouth
🫣 peek shy watch
🫤 meh unsure disappointed
🫥 invisible empty ghost
🫦 lip bite horny shy
🫧 bubbles clean soap cute
🫨 shaking face panic unstable
🫶 heart hands love care
🫰 finger heart tiny love
🫳 hand down drop
🫴 hand up offer

🫵 pointing at you blame you
🫱 rightwards hand give
🫲 leftwards hand receive
🫸 stop hand block
🫷 stop hand block left

🫎 moose animal big
🫏 donkey stubborn animal
🫑 bell pepper veggie
🫒 olive food snack
🫓 flatbread food
🫔 tamale food
🫕 fondue cheese food
🫖 teapot tea drink
🫗 pouring liquid drink
🫙 jar container food
🫚 ginger root spice
🫛 peas veggie
🫜 root vegetable
🫐 blueberries fruit

🫠 melt awkward cringe
🫥 invisible empty
🫧 bubbles soap clean
🫨 shake panic fear

🛗 elevator lift building
🛝 playground slide fun
🛟 ring buoy save water
🛜 wireless signal wifi
🛢️ oil barrel fuel
🛖 hut small home
🛠️ tools repair fix
🛡️ shield defense
🛠️ tools hammer wrench
⚔️ crossed swords battle
🗡️ dagger knife weapon
🏹 bow arrow weapon
🪓 axe chop weapon
🔪 kitchen knife cut

🧿 evil eye protection
🪬 amulet protection
🧸 teddy bear comfort
🪅 pinata party
🪆 nesting dolls toy

🪐 ringed planet space
🌑 new moon dark
🌒 waxing crescent
🌓 first quarter moon
🌔 waxing gibbous
🌕 full moon bright
🌖 waning gibbous
🌗 last quarter moon
🌘 waning crescent
🌙 crescent moon night

☄️ comet space rock
🛸 ufo alien
🌠 shooting star wish
🌌 galaxy stars space

🧑‍🦽 wheelchair manual
🧑‍🦼 wheelchair motorized
🧑‍🦯 white cane blind
🧑‍🦳 person white hair
🧑‍🦰 person red hair
🧑‍🦱 person curly hair
🧑‍🦲 bald person

🧑‍🤝‍🧑 people holding hands
👭 women holding hands
👬 men holding hands
👫 couple holding hands

🧑‍❤️‍🧑 couple love neutral
👩‍❤️‍👩 women couple love
👨‍❤️‍👨 men couple love

🧑‍⚕️ health worker
🧑‍🌾 farmer
🧑‍🍳 cook chef
🧑‍🎓 student graduate
🧑‍🎤 singer performer
🧑‍🏫 teacher
🧑‍🏭 factory worker
🧑‍💻 programmer coder
🧑‍🔧 mechanic
🧑‍🔬 scientist
🧑‍🚀 astronaut
🧑‍🚒 firefighter
🧑‍✈️ pilot
🧑‍⚖️ judge

🧑‍🎨 artist paint
🧑‍🎭 actor theater
🧑‍🎼 composer music
🧑‍🔮 mystic fortune teller
🧑‍🍼 feeding baby parent

🧑‍🧑‍🧒 family child
👨‍👩‍👧 family girl
👨‍👩‍👦 family boy
👨‍👩‍👧‍👦 family kids
👩‍👩‍👧 family women
👨‍👨‍👦 family men

🪑 chair sit rest
🛋️ couch relax
🛏️ bed sleep
🪟 window view
🪞 mirror reflect
🚪 door open close

🧯 fire extinguisher
🪠 plunger toilet fix
🧴 lotion bottle
🧼 soap clean
🧽 sponge clean
🧹 broom sweep
🧺 laundry basket
🧻 toilet paper

🧊 ice cube cold
🫗 pour liquid
🧉 mate drink
🫖 teapot tea
🍶 sake drink
🍾 champagne
🥂 cheers glasses

🧃 juice box
🥤 soda drink
🧋 bubble tea drink
☕ coffee drink
🍵 tea cup
🥛 milk drink

🧭 compass navigation
🗺️ world map
🧱 bricks build
🪵 wood log
🪨 rock stone

👨‍💻 man technologist programmer coder linux
🐧 penguin tux linux mascot
💻 laptop code hacking programming
🧠 brain big brain kernel
🖥️ desktop computer linux machine
EOF
)"

[ -n "$chosen" ] || exit 0

emoji="$(printf '%s' "$chosen" | awk '{print $1}')"
printf '%s' "$emoji" | wl-copy
