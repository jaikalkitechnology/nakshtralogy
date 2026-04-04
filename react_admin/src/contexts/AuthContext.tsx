import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { loginByRole, logoutUser, getStoredUser, signupUser, signupAstrologer, type LoginRole } from "@/services/api";

export type UserRole = "user" | "astrologer" | "admin";

interface AuthUser {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
  walletBalance: number;
  profile?: any; // astrologer profile data
}

interface AuthContextType {
  user: AuthUser | null;
  loading: boolean;
  login: (email: string, password: string, role: UserRole) => Promise<{ error: string | null; redirectTo: string }>;
  signupAsUser: (name: string, email: string, password: string, phone?: string) => Promise<{ error: string | null; redirectTo: string }>;
  signupAsAstrologer: (fields: any) => Promise<{ error: string | null; redirectTo: string }>;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be within AuthProvider");
  return ctx;
};

function roleRedirect(role: string): string {
  switch (role) {
    case "admin": return "/admin";
    case "astrologer": return "/astrologer";
    default: return "/dashboard";
  }
}

function mapUser(data: any): AuthUser {
  return {
    id: data.id,
    name: data.name || "",
    email: data.email,
    role: data.role,
    avatar: data.avatar_url,
    walletBalance: data.wallet_balance || 0,
    profile: data.profile,
  };
}

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = getStoredUser();
    if (stored) {
      setUser(mapUser(stored));
    }
    setLoading(false);
  }, []);

  const login = async (email: string, password: string, role: UserRole) => {
    const { ok, data } = await loginByRole(email, password, role as LoginRole);
    if (ok && data.user) {
      const u = data.user;
      // validate role matches what was requested
      if (u.role !== role) {
        logoutUser();
        return { error: `This account is registered as "${u.role}", not "${role}"`, redirectTo: "" };
      }
      setUser(mapUser(u));
      return { error: null, redirectTo: roleRedirect(u.role) };
    }
    return { error: data.detail || "Login failed", redirectTo: "" };
  };

  const signupAsUser = async (name: string, email: string, password: string, phone?: string) => {
    const { ok, data } = await signupUser(name, email, password, phone);
    if (ok && data.user) {
      setUser(mapUser(data.user));
      return { error: null, redirectTo: "/dashboard" };
    }
    return { error: data.detail || "Signup failed", redirectTo: "" };
  };

  const signupAsAstrologer = async (fields: any) => {
    const { ok, data } = await signupAstrologer(fields);
    if (ok && data.user) {
      setUser(mapUser(data.user));
      return { error: null, redirectTo: "/astrologer" };
    }
    return { error: data.detail || "Signup failed", redirectTo: "" };
  };

  const logout = () => {
    logoutUser();
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, signupAsUser, signupAsAstrologer, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  );
};
