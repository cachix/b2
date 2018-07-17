{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE StrictData #-}
module B2.LargeFile
  ( LargeFile(..)
  , LargeFiles(..)
  , LargeFilePart(..)
  , LargeFileParts(..)
  ) where

import           Data.Aeson ((.:))
import qualified Data.Aeson as Aeson
import           Data.HashMap.Strict (HashMap)
import           Data.Int (Int64)
import           Data.Text (Text)

import           B2.File (File, FileIDs, HasFileID(..))
import           B2.ID (ID)


data LargeFile = LargeFile
  { fileIDs         :: FileIDs
  , contentType     :: Text
  , fileInfo        :: HashMap Text Text
  , uploadTimestamp :: Int64
  } deriving (Show, Eq)

instance Aeson.FromJSON LargeFile where
  parseJSON =
    Aeson.withObject "LargeFile" $ \o -> do
      fileIDs <- Aeson.parseJSON (Aeson.Object o)
      contentType <- o .: "contentType"
      fileInfo <- o .: "fileInfo"
      uploadTimestamp <- o .: "uploadTimestamp"
      pure LargeFile {..}

instance HasFileID LargeFile where
  getFileID LargeFile {..} = getFileID fileIDs

data LargeFiles = LargeFiles
  { files      :: [LargeFile]
  , nextFileID :: Maybe (ID File)
  } deriving (Show, Eq)

instance Aeson.FromJSON LargeFiles where
  parseJSON =
    Aeson.withObject "LargeFiles" $ \o -> do
      files <- o .: "files"
      nextFileID <- o .: "nextFileId"
      pure LargeFiles {..}

data LargeFilePart = LargeFilePart
  { fileID        :: ID File
  , partNumber    :: Int64
  , contentLength :: Int64
  , contentSha1   :: Text
  } deriving (Show, Eq)

instance Aeson.FromJSON LargeFilePart where
  parseJSON =
    Aeson.withObject "LargeFilePart" $ \o -> do
      fileID <- o .: "fileId"
      partNumber <- o .: "partNumber"
      contentLength <- o .: "contentLength"
      contentSha1 <- o .: "contentSha1"
      pure LargeFilePart {..}

instance HasFileID LargeFilePart where
  getFileID LargeFilePart {..} = getFileID fileID

data LargeFileParts = LargeFileParts
  { nextPartNumber :: Maybe Int64
  , parts          :: [LargeFilePart]
  } deriving (Show, Eq)

instance Aeson.FromJSON LargeFileParts where
  parseJSON =
    Aeson.withObject "LargeFileParts" $ \o -> do
      parts <- o .: "parts"
      nextPartNumber <- o .: "nextPartNumber"
      pure LargeFileParts {..}