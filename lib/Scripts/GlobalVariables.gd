extends Node
const BORDER = 5
const GUNREF = [preload("res://Guns/SMG.tscn"),
					  	preload("res://Guns/Shotgun.tscn"),
					  	preload("res://Guns/Pistol.tscn")]
const LOOT_POOL_ACTIVE = [preload("res://ActiveItems/IronSkin.tscn"), preload("res://ActiveItems/BrokenClock.tscn"),
								preload("res://ActiveItems/DevilDeal.tscn"), preload("res://ActiveItems/SpiritCamera.tscn"),
								preload("res://ActiveItems/Repulsor.tscn")]
const LOOT_POOL_WHITE = [preload("res://Items/TwoPercent.tscn"), preload("res://Items/Coffee.tscn"),
								preload("res://Items/Grease.tscn"), preload("res://Items/TheChain.tscn"),
					 			preload("res://Items/OldJersey.tscn"), preload("res://Items/BeyondMeat.tscn"),
					 			preload("res://Items/Cookies.tscn"), preload("res://Items/Shells.tscn")]
const LOOT_POOL_GREEN = [preload("res://Items/PainPills.tscn"),preload("res://Items/TowerShield.tscn"),
								preload("res://Items/RollerBlades.tscn"), preload("res://Items/ExtendedMagazine.tscn"),
					 			preload("res://Items/Binoculars.tscn"),preload("res://Items/Dilopia.tscn")]
const LOOT_POOL_BLUE = [preload("res://Items/MarineHelmet.tscn"),preload("res://Items/PhoneBook.tscn"),
								preload("res://Items/Gloves.tscn"), preload("res://Items/ItchyFinger.tscn")]
const LOOT_POOL_PURPLE = [preload("res://Items/ElixirOfLife.tscn"),preload("res://Items/FullMetalJacket.tscn"),
								preload("res://Items/Batteries.tscn"),preload("res://Items/DrumClip.tscn"),
								preload("res://Items/Deadeye.tscn"), preload("res://Items/SoyMilk.tscn")]
const LOOT_POOL_ORANGE = [preload("res://Items/ChiliPepper.tscn"),preload("res://Items/BottleOfRage.tscn"),
								preload("res://Items/MysteryPowder.tscn"), preload("res://Items/Catalyst.tscn"),
								preload("res://Items/AlmondMilk.tscn")]
const ALL_ITEMS = LOOT_POOL_WHITE + LOOT_POOL_GREEN + LOOT_POOL_BLUE + LOOT_POOL_PURPLE + LOOT_POOL_ORANGE