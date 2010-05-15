﻿/** * Copyright 2008 - TMTDigital LLC * * Author:   Travis Tidwell (www.travistidwell.com) * Version:  1.0 * Date:     June 9th, 2008 * * Description:  The DashVoterBase is used as a base class for any * voting widgets that are contained in the Dash Player.  It is also  * used to just display the votes of any current node in the players playlist. * **/package com.tmtdigital.dash.display.voter{	import com.tmtdigital.dash.DashPlayer;	   import com.tmtdigital.dash.net.Service;	import com.tmtdigital.dash.utils.Resizer;	import com.tmtdigital.dash.utils.LayoutManager;   import com.tmtdigital.dash.display.voter.TagVoter;   import com.tmtdigital.dash.display.Skinable;   import com.tmtdigital.dash.events.DashEvent;   import com.tmtdigital.dash.utils.Utils;   import com.tmtdigital.dash.net.Gateway;    import com.tmtdigital.dash.config.Params;     import flash.utils.*;   import flash.events.*;   import flash.display.*;   import fl.transitions.*;   import fl.transitions.easing.*;   public class DashVoter extends Skinable   {      public function DashVoter( _skin:MovieClip, _type:String )       {         type = _type;         var _skinPath:String = "";			         if( Params.flashVars.voter && Params.flashVars.votingenabled ) {            _skinPath = Params.getRootPath();            _skinPath += "/plugins/voters/" + Params.flashVars.voter + "/voter.swf";         }          super( _skin, _skinPath );      }            public override function getSkin( newSkin:MovieClip ) : MovieClip      {         if( rootSkin && (rootSkin.getVoter is Function) ) {				return rootSkin.getVoter( type );         }                  return newSkin;            }            public override function setSkin( _skin:MovieClip )      {         super.setSkin( _skin );         			if( skin ) {				submitted = skin.submitted;				submit = skin.submit;									if( skin.tags ) {					tags = new Object();					var i:int = skin.tags.numChildren;					while (i--)					{						var tag:* = skin.tags.getChildAt(i);						var newTag:TagVoter = new TagVoter( tag );						newTag.setTag( tag.name );						newTag.addEventListener( DashEvent.VOTE_GET, voteHandler );						newTag.addEventListener( DashEvent.VOTE_SET, voteHandler );						newTag.addEventListener( DashEvent.VOTE_DELETE, voteHandler );						newTag.addEventListener( DashEvent.PROCESSING, voteHandler );						tags[tag.name] = newTag;					}				}								visible = Params.flashVars.votingenabled;			}      }		      public function setVote( vote:Object, type:String )       {         if( vote && vote.tag ) {            if( tags && tags[vote.tag] ) {               tags[vote.tag].setVote( vote );            }				            // Call our hook for this operation.            if ( rootSkin.onSetVote is Function ) {               rootSkin.onSetVote( this, type, vote );            }					         }      }            // Show the loader when votes are being processed, nothing otherwise.      private function voteHandler( event:DashEvent )      {         if( event.type == DashEvent.VOTE_SET ) {            if (submitted) {               submitted.visible = true;            }								            Gateway.setVote( event.args, Params.flashVars.playlistonly );				            Gateway.setPlaylistVote( nodeId, event.args, Params.flashVars.disableplaylist );         }         			if( DashPlayer.dash.node && DashPlayer.dash.node.spinner ) {        		DashPlayer.dash.node.spinner.visible = (event.type == DashEvent.PROCESSING);			}						// Call our hook for this operation.         if ((rootSkin.onVote is Function) && event && event.args) {            rootSkin.onVote( this, {type:event.type, vote:event.args} );         }			      }      // Loads the voter.      public function loadVoter( node:Object )      {         alpha = 0;         nodeId = node.nid;         setFieldsMC( nodeId );      }      // Sets the voter fields.      protected function setFieldsMC( nodeId:Number )      {         var shouldCache:Boolean = false;                  if (submit) {            shouldCache = true;            submit.buttonMode = true;            submit.mouseChildren = false;            submit.gotoAndStop("_up");            submit.removeEventListener( MouseEvent.MOUSE_UP, onVoteSubmit );            submit.addEventListener( MouseEvent.MOUSE_UP, onVoteSubmit );         }         if (submitted) {            submitted.visible = false;         }         for each( var tag:TagVoter in tags ) {            tag.getVotes( nodeId, shouldCache );         }      }      // Called when the user presses the submit key.      protected function onVoteSubmit( e:MouseEvent )      {         // We want to process all votes here...         for each( var tag:TagVoter in tags ) {            tag.processVotes();         }      }      public var submitted:Sprite;      public var submit:MovieClip;      public var tags:Object;		            private var type:String;      private var nodeId:Number;   }}