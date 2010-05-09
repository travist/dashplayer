﻿package com.tmtdigital.dash.display.voter
{
   import com.tmtdigital.dash.display.voter.Voter;
   import com.tmtdigital.dash.display.Skinable;
   import com.tmtdigital.dash.events.DashEvent;

   // Import all dependencies
   import flash.display.MovieClip;
   
   // Declare our TagVoter class.
   public class TagVoter extends Skinable
   {
      public function TagVoter( _skin:MovieClip ) 
      {
         super( _skin );
      }
      
      // The Voter constructor.		
      public override function setSkin( _skin:MovieClip )
      {
         super.setSkin( _skin );
         
         // Set up our voters.
         vote = new Voter( _skin.vote );
		 vote.addEventListener( DashEvent.VOTE_GET, voteHandler );
         vote.addEventListener( DashEvent.VOTE_SET, voteHandler );
         vote.addEventListener( DashEvent.VOTE_DELETE, voteHandler );
         vote.addEventListener( DashEvent.PROCESSING, voteHandler );
         
         uservote = new Voter( _skin.uservote, true );
		 uservote.addEventListener( DashEvent.VOTE_GET, voteHandler );			
         uservote.addEventListener( DashEvent.VOTE_SET, voteHandler );
         uservote.addEventListener( DashEvent.VOTE_DELETE, voteHandler );			
         uservote.addEventListener( DashEvent.PROCESSING, voteHandler );			
      }
      
      // Route all messages to the parent class.
      private function voteHandler( event:DashEvent )
      {
         if( event.type == DashEvent.VOTE_SET ) {
            setVote( event.args );
         }
         
         dispatchEvent( event );
      }
      
      // Sets the vote value.
      public function setVote( _vote:Object )
      {
         vote.setVote( _vote );
      }
      
      // Sets the tag name.
      public function setTag( tag:String ) {
         // Set the user vote tag name.
         if( uservote ) {
            uservote.setTag( tag );
         }
         
         // Set the regular vote tag name.
         if( vote ) {
            vote.setTag( tag );
         }			
      }
      
      // Get both the uservote and regular vote.
      public function getVotes( nodeId:Number, cache:Boolean = false )
      {
         // Get the user vote.
         if( uservote ) {
            uservote.getVote( nodeId, cache );
         }
         
         // Get the regular vote.
         if( vote ) {
            vote.getVote( nodeId, cache );
         }
      }
      
      // Processes all cached votes.
      public function processVotes()
      {
         // Process only the user vote.
         if( uservote ) {
            uservote.processVote();
         }			
      }
      
      // Declare all of our child movie clips
      public var vote:Voter;
      public var uservote:Voter;
   }
}