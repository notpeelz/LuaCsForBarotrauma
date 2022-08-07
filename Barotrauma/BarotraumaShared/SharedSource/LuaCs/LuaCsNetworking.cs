using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Barotrauma.Networking;
using MoonSharp.Interpreter;

namespace Barotrauma
{
	partial class LuaCsNetworking
	{
		public class HttpListener
        {
			private System.Net.HttpListener listener;

			public HttpListener(System.Net.HttpListener list)
			{
				listener = list;
			}

			public void Close()
			{
				listener.Close();
			}
		}

		public class IncomingHttpRequest
		{
			private HttpListenerRequest request;

			public IncomingHttpRequest(HttpListenerRequest req)
            {
				request = req;
			}

			public string ContentType => request.ContentType;
			public string LocalEndPoint => request.LocalEndPoint.ToString();
			public string RemoteEndPoint => request.RemoteEndPoint.ToString();
			public string RawUrl => request.RawUrl;
			public Uri Url => request.Url;
			public string UserAgent => request.UserAgent;
			public string UserHostName => request.UserHostName;
			public string UserHostAddress => request.UserHostAddress;
			public NameValueCollection Headers => request.Headers;
			public string HttpMethod => request.HttpMethod;
		}

		public class IncomingHttpResponse
		{
			private HttpListenerResponse response;

			public IncomingHttpResponse(HttpListenerResponse resp)
			{
				response = resp;

				response.ContentType = "text/html";
			}

			public string ContentType
            {
                get { return response.ContentType; }
				set { response.ContentType = value; }
            }

			public void Write(string text)
			{
				byte[] data = Encoding.UTF8.GetBytes(text);
				response.ContentEncoding = Encoding.UTF8;
				response.ContentLength64 = data.LongLength;

				response.OutputStream.Write(data, 0, data.Length);
			}
		}


		public bool RestrictMessageSize = true;
		public Dictionary<string, LuaCsAction> LuaCsNetReceives = new Dictionary<string, LuaCsAction>();

#if SERVER
		[MoonSharpHidden]
		public void NetMessageReceived(IReadMessage netMessage, ClientPacketHeader header, Client client = null)
		{
			if (header == ClientPacketHeader.LUA_NET_MESSAGE)
			{
				string netMessageName = netMessage.ReadString();
				if (LuaCsNetReceives.ContainsKey(netMessageName))
				{
					try 
					{
						LuaCsNetReceives[netMessageName](netMessage, client);
					}
					catch (Exception e)
                    {
						// TODO: make LuaCsNetworking hold a reference to LuaCsSetup instead of using this global
						GameMain.LuaCs.PrintError($"Exception thrown inside NetMessageReceive({netMessageName})", LuaCsMessageOrigin.Unknown);
						GameMain.LuaCs.HandleException(e, LuaCsMessageOrigin.Unknown);
                    }
				}
			}
			else
			{
				GameMain.LuaCs.Hook.Call("netMessageReceived", netMessage, header, client);
			}
		}

#else
		[MoonSharpHidden]
		public void NetMessageReceived(IReadMessage netMessage, ServerPacketHeader header, Client client = null)
		{
			if (header == ServerPacketHeader.LUA_NET_MESSAGE)
			{
				string netMessageName = netMessage.ReadString();
				if (LuaCsNetReceives.ContainsKey(netMessageName))
                {
					try
					{
						LuaCsNetReceives[netMessageName](netMessage, client);
					}
					catch (Exception e)
					{
						GameMain.LuaCs.PrintError($"Exception thrown inside NetMessageReceive({netMessageName})", LuaCsMessageOrigin.Unknown);
						GameMain.LuaCs.HandleException(e, LuaCsMessageOrigin.Unknown);
					}
				}
			}
			else
			{
				GameMain.LuaCs.Hook.Call("netMessageReceived", netMessage, header, client);
			}
		}
#endif
		public void Receive(string netMessageName, LuaCsAction callback)
		{
			LuaCsNetReceives[netMessageName] = callback;
		}

		public IWriteMessage Start(string netMessageName)
		{
			var message = new WriteOnlyMessage();
#if SERVER
			message.Write((byte)ServerPacketHeader.LUA_NET_MESSAGE);
#else
			message.Write((byte)ClientPacketHeader.LUA_NET_MESSAGE);
#endif
			message.Write(netMessageName);
			return ((IWriteMessage)message);
		}

		public IWriteMessage Start()
		{
			return new WriteOnlyMessage();
		}

#if SERVER
		public void ClientWriteLobby(Client client) => GameMain.Server.ClientWriteLobby(client);

		public void Send(IWriteMessage netMessage, NetworkConnection connection = null, DeliveryMethod deliveryMethod = DeliveryMethod.Reliable)
		{
			if (connection == null)
			{
				foreach (NetworkConnection conn in Client.ClientList.Select(c => c.Connection))
				{
					GameMain.Server.ServerPeer.Send(netMessage, conn, deliveryMethod);
				}
			}
			else
			{
				GameMain.Server.ServerPeer.Send(netMessage, connection, deliveryMethod);
			}
		}
#else
		public void Send(IWriteMessage netMessage, DeliveryMethod deliveryMethod = DeliveryMethod.Reliable)
		{
			GameMain.Client.ClientPeer.Send(netMessage, deliveryMethod);
		}
#endif

		public void HttpRequest(string url, LuaCsAction callback, string data = null, string method = "POST", string contentType = "application/json")
		{
			try
			{
				var httpWebRequest = (HttpWebRequest)WebRequest.Create(url);
				httpWebRequest.ContentType = contentType;
				httpWebRequest.Method = method;

				if (data != null)
				{
					using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
						streamWriter.Write(data);
				}

				httpWebRequest.BeginGetResponse(new AsyncCallback((IAsyncResult result) =>
				{
					try
					{
						var httpResponse = httpWebRequest.EndGetResponse(result);
						using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
						{
							string responseResult = streamReader.ReadToEnd();
							GameMain.LuaCs.Timer.Wait((object[] par) => { callback(responseResult); }, 0);
						}
					}
					catch (Exception e)
					{
						GameMain.LuaCs.Timer.Wait((object[] par) => { callback(e.Message); }, 0);
					}
				}), null);

			}
			catch (Exception e)
			{
				GameMain.LuaCs.Timer.Wait((object[] par) => { callback(e.Message); }, 0);
			}
		}

		public void HttpPost(string url, LuaCsAction callback, string data, string contentType = "application/json")
        {
			HttpRequest(url, callback, data, "POST", contentType);
		}


		public void HttpGet(string url, LuaCsAction callback)
		{
			HttpRequest(url, callback, null, "GET");
		}

		public static async void HandleIncomingConnections(System.Net.HttpListener listener, LuaCsAction onRequestReceived)
		{
			try
			{
				while (listener.IsListening)
				{
					HttpListenerContext ctx = await listener.GetContextAsync();

					IncomingHttpRequest req = new IncomingHttpRequest(ctx.Request);
					IncomingHttpResponse resp = new IncomingHttpResponse(ctx.Response);

					onRequestReceived(req, resp);

					ctx.Response.Close();
				}

			}
			catch (Exception)
            {

            }
		}


        public LuaCsNetworking.HttpListener StartHttpServer(string address, LuaCsAction onRequestReceived)
        {
			var listener = new System.Net.HttpListener();
			listener.Prefixes.Add(address);
			listener.Start();

			HandleIncomingConnections(listener, onRequestReceived);

			return new LuaCsNetworking.HttpListener(listener);
		}

		public void CreateEntityEvent(INetSerializable entity, NetEntityEvent.IData extraData)
		{
			GameMain.NetworkMember.CreateEntityEvent(entity, extraData);
		}

#if SERVER
		public void UpdateClientPermissions(Client client)
		{
			GameMain.Server.UpdateClientPermissions(client);
		}

		public void RemovePendingClient(ServerPeer.PendingClient pendingClient, DisconnectReason reason, string msg)
		{
			GameMain.Server.ServerPeer.RemovePendingClient(pendingClient, reason, msg);
		}

		public int FileSenderMaxPacketsPerUpdate
		{
			get { return FileSender.FileTransferOut.MaxPacketsPerUpdate; }
			set { FileSender.FileTransferOut.MaxPacketsPerUpdate = value; }
		}
#endif


		public ushort LastClientListUpdateID
		{
			get { return GameMain.NetworkMember.LastClientListUpdateID; }
			set { GameMain.NetworkMember.LastClientListUpdateID = value; }
		}
	}
}