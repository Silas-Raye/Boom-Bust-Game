void load_dialogue() {
  lvl1_dialogue.set("lvl1_d1",
    "Listen up, kid. You're in with \nthe mob now, and we got a job \nfor ya. To start, we need ya to \nblast that grid to \nsmithereens.");
  lvl1_dialogue.set("lvl1_d2",
    "You got explosives in the bags \non your belt, right? Good, if you \nneed to rotate em, just hit that \nR button.");
  lvl1_dialogue.set("lvl1_d3",
    "Now, the red area around the \nbomb is the explosion radius. \nYou only got one match, so you \ngotta be smart.");
  lvl1_dialogue.set("lvl1_d4",
    "This here's important so you \nbest listen up. Chain together \nthose explosions by putting a \nbomb in the radius \nof the one before it.");
  lvl1_dialogue.set("lvl1_pe", // pe stands for post explosion
    "Good job kid, your final score \nwas " + lvl1.get_score() + "%, but don't worry about \nthat none. Next round ya gonna \nhave more bombs, \ntrust me.");
  dialogue_tree.add(lvl1_dialogue);
  
  lvl2_dialogue.set("lvl2_d1",
    "Hey, check dis out. I hooked ya \nup wit' more bombs, savvy? \nNow ya should have plenty to \nwork with.");
  lvl2_dialogue.set("lvl2_d2",
    "Unfortunately, thanks to an \nunexplained explosion at the \nmatch factory, ya still only \ngot one match.");
  lvl2_dialogue.set("lvl2_pe",
    "Holy smokes, did you see that \nblast?! Your final score was \n" + lvl2.get_score() + "%.");
  dialogue_tree.add(lvl2_dialogue);
  
  lvl3_dialogue.set("lvl3_d1",
    "Okay, listen up, kid. This is ya \nfirst real gig, capisce? The \neggheads in the lab got \nsomethin' new for \nya to play with...");
  lvl3_dialogue.set("lvl3_d2",
    "STICKY BOMBS! They're like \nregular bombs, but smaller and \nonce ya put 'em down, they \nain't comin' back up.");
  lvl3_dialogue.set("lvl3_pe",
    "Your final score was " + lvl3.get_score() + "%, but \nya better keep ya score up, if ya \nknow what's good for ya, pal. \nOtherwise, the boss \nwill come knockin'.");
  dialogue_tree.add(lvl3_dialogue);
  
  lvl4_dialogue.set("lvl4_d1",
    "This is it, kid, the big bust \nwe've been preparing you for! \nThe eggheads cooked up \nsomething special \nfor the occasion…");
  lvl4_dialogue.set("lvl4_d2",
    "FRAGILE BOMBS! They're \nbigger than yer usual stuff. But \ndon't get any ideas, kid. They're \ndelicate flowers, so \nya can't rotate 'em.");
  lvl4_dialogue.set("lvl4_pe",
    "That was one helluva \nfireworks show! Your final score \nwas " + lvl4.get_score() + "%. Not bad, kid, not bad \nat all.");
  dialogue_tree.add(lvl4_dialogue);

  lvl5_dialogue.set("lvl5_d1",
    "Hey, welcome to freeplay mode. \nEvery time ya reset the level, \nwe'll give ya different bombs. \nGood luck, kid, ya \ngonna need it.");
  lvl5_dialogue.set("lvl5_pe",
    "Your final score was " + lvl5.get_score() + "%.");
  dialogue_tree.add(lvl5_dialogue);
}
